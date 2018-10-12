library(foreign)
library(dplyr)
library(ggplot2)

source('/home/jared/Guatemala/NetworksOfGuatemala/gem/variables.R')

GEM_FILE = '/home/jared/Guatemala/NetworksOfGuatemala/gem/data/gem_2018.sav'


loadData <- function()
    rawData() %>% recode


rawData <- function()
  read.spss(GEM_FILE, use.value.labels = FALSE) %>%
    data.frame()



mobileRng  <- function(data, low, high)
  filter(data, mobilePay > low & mobilePay < high)


cell_payments_by_eth <- function(data, eths, rng) {
  d <- filter(data, ethnicity %in% eths) %>%
        filter(mobilePay > rng[1] & mobilePay < rng[2])
  ggplot(d, aes(x=mobilePay, fill=ethnicity)) + geom_density(alpha = .3)
}


cell_payments_by_edu <- function(data, educ_lvls, rng) {
  d <- filter(data, educLevel %in% educ_lvls) %>%
        filter(mobilePay > rng[1] & mobilePay < rng[2])
  ggplot(d, aes(x=mobilePay, fill=as.character(educLevel))) + 
    geom_density(alpha = .3) + 
    labs(fill="Education level")
}


payment_granularity_by_educ <- function(data) {
  d$mobilePay = d$mobilePay %% 10
  ggplot(d, aes(x=mobilePay, fill=educLevel)) + geom_density(alpha = .3)
}


reg.startBiz <- function(gem) {
  glm(
      easystart ~ 
        log(incomeHousehold) + educLevel + intInHome + mobilePay, 
      family = binomial(link='logit'), 
      data=gem
  )
}


bill_vs_edu <- function(data) {
  d <- data[!is.na(data$mobilePay),]
  sum_d <- group_by(d, xxcity) %>%
    summarise(bill = mean(mobilePay), educ = mean(educLevel))
  return(sum_d)
}

run.model.startBiz  <- function() {
  gemData <- loadData()
  reg.startBiz(gemData)
}





