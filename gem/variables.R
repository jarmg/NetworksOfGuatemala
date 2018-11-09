library(plyr)
library(dplyr)
library(data.table)

source('~/Guatemala/NetworksOfGuatemala/utils.R')

recodings <- 
  c(mobilePay = 'Q72.11.3',
    intPay    = 'Q72.11.4',
    tvPay     = 'Q72.11.5',
    ethnicity = 'Q60',
    lifeImproved  = 'Q64',
    tvInHome      = 'Q72.9',
    mobileInHome  = 'Q72.6',
    mobilePersonal= 'Q86',
    newsCntry     = 'JG2',
    newsMuni      = 'JG3',
    whyNoIntCntry = 'JG4',
    whyNoIntMuni  = 'JG5',
    intImprove    = 'JG6',
    bedrooms      = 'Q70.1.1',
    membersHousehold   = 'hhsize',
    educLevel          = 'xxreduc',
    incomeHousehold    = 'xxhhinc'
  )


recode.income <- function(gem) {
  #Set level to middle of income category
  levels(gem$incomeHousehold) = 
    c(NA, NA, 250, 625, 1175, 1800, 2250,
      2750, 4000, 7500, 12500, 17000, 25000)

  gem$incomeHousehold = as.numeric(as.character(gem$incomeHousehold))
  gem
}


recode.indig <- function(gem) {
  #Add column for whether or not they are indigenous
  gem$indig <- revalue(gem$ethnicity, 
                  c('Indígena (Maya)' = 1, 'No indígena (ladino)' = 0)
                )
  gem$indig <- levels(gem$indig)[gem$indig] %>% as.numeric
  gem
}


#NOTE: Currently unused since the numbers are being convereted to NAs on
# factor casting
recode.intInHome <- function(gem){
  gem$intInHome <- as.numeric(gem$intPay > 0)
  gem$intInHome[is.na(gem$intPay)] <- 0
  gem
}


recode.startbiz <- function(gem) {
  gem$easystart <- 
    revalue(gem$easystart, c('Yes' = 1, 'No' = 0))
  gem$easystart <-
    as.numeric(levels(gem$easystart)[gem$easystart])
  gem
}


recode.mobilePersonal <- function(gem) {
  gem$mobilePersonal <- 
    revalue(gem$mobilePersonal, c('Sí' = 1, 'No' = 0))
  gem$mobilePersonal <- 
    as.numeric(levels(gem$mobilePersonal)[gem$mobilePersonal])
  gem
}


FixDuplicatedFactors <- function(rd) {
  #FIXME (jmg 10/17/18): This manually changes two data rows to prevent
  # factor level duplication and I'm not SURE these are actually the same location
  rd$xxcity[which(rd$xxcity == 21,)]  <- 20
  vlabs = attr(rd$xxcity, "value.labels")
  setattr(rd$xxcity, "value.labels", vlabs[vlabs != 21])

  d  <- lapply(rd, Int2Factor)
  as.data.frame(d, stringsAsFactors = FALSE)
}


recode <- function(rawData) {
  data <- FixDuplicatedFactors(rawData)
  old_names = recodings
  new_names = names(mapply(function(name) {deparse(substitute(name))}, recodings))
  setnames(data, old=old_names, new=new_names) %>%
    recode.indig %>%
    recode.income %>%
    recode.startbiz %>%
    recode.mobilePersonal
}
