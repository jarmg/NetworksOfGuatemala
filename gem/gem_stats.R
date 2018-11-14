library(foreign)
library(dplyr)
library(ggplot2)

source('/home/jared/Guatemala/NetworksOfGuatemala/gem/variables.R')

GEM_FILE = '/home/jared/Guatemala/NetworksOfGuatemala/data/gem/gem_2018.sav'


load.gem.data <- function()
  #Loads and cleans the gem data 
  #(uses recode() function from variables.R)
    rawData() %>% recode


rawData <- function()
  #Loads the raw gem data
  read.spss(GEM_FILE, use.value.labels = FALSE) %>%
    data.frame()



mobileRng  <- function(data, low, high)
  filter(data, mobilePay > low & mobilePay < high)


cell_payments_by_eth <- function(data, eths, rng) {
  #Graphs cell phone payment vs ethnicity


  d <- filter(data, ethnicity %in% eths) %>%
        filter(mobilePay > rng[1] & mobilePay < rng[2])
  ggplot(d, aes(x=mobilePay, fill=ethnicity)) + geom_density(alpha = .3)
}


cell_payments_by_edu <- function(data, educ_lvls, rng) {
  #Graphs education level vs monthly cell phone payment
  
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
  #Runs a logit regression of whether people think it is
  # easy to start a business related to their education,
  # whether they have home internet, they income, and how much
  # they pay for their phone each month 

  glm(
      easystart ~ 
        log(incomeHousehold) + educLevel + intInHome + mobilePay, 
      family = binomial(link='logit'), 
      data=gem
  )
}


bill_vs_edu <- function(data) {
  #Calculates the average income and education by municipality

  d <- data[!is.na(data$mobilePay),] #Filters out NAs
  sum_d <- group_by(d, xxcity) %>%
    summarise(bill = mean(mobilePay), educ = mean(educLevel))
  return(sum_d)
}



run.model.startBiz  <- function() {
  #Loads gem data and runs the startBiz analysis

  gemData <- load.gem.data()
  reg.startBiz(gemData)
}





