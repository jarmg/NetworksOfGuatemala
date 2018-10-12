library(data.table)

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
  gem$incomeHousehold = factor(gem$incomeHousehold)

  #Set level to middle of income category
  levels(gem$incomeHousehold) = 
    c(NA, NA, 250, 625, 1175, 1800, 2250,
      2750, 4000, 7500, 12500, 17000, 25000)

  gem$incomeHousehold = as.numeric(as.character(gem$incomeHousehold))
  gem
}
          
recode.intInHome <- function(gem){
  gem$intInHome <- as.numeric(gem$intPay > 0)
  gem$intInHome[is.na(gem$intPay)] <- 0
  gem
}

recode.ethnicity <- function(gem) {
  gem$ethnicity <- 
    factor(gem$ethnicity, labels = names(attributes(gem$ethnicity)$value))
  gem
}


recode.startbiz <- function(gem) {
  # 'No' <- 2, 'Yes' <- 1
  gem$easystart[gem$easystart == 1] <- 1
  gem$easystart[gem$easystart == 2] <- 0
  gem$easystart[gem$easystart < 0] <- NA
  gem
}


recode.mobilePersonal <- function(gem) {
  gem$mobilePersonal[gem$mobilePersonal < 0] <- NA
  gem$mobilePersonal[gem$mobilePersonal == 2] <- 0
  gem$mobilePersonal[gem$mobilePersonal == 1] <- 1
  gem
}

recode <- function(data) {
  old_names = recodings
  new_names = names(mapply(function(name) {deparse(substitute(name))}, recodings))
  setnames(data, old=old_names, new=new_names) %>%
    recode.income %>%
    recode.startbiz %>%
    recode.mobilePersonal %>%
    recode.intInHome %>%
    recode.ethnicity
}
