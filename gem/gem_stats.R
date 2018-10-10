library(foreign)
library(dplyr)
library(ggplot2)

source('/home/jared/Guatemala/NetworksOfGuatemala/gem/variables.r')

GEM_FILE = '/home/jared/Guatemala/NetworksOfGuatemala/gem/data/gem_2018.sav'


load_data <- function() {
  data <-
    read.spss(GEM_FILE, use.value.labels = FALSE) %>%
    data.frame() %>%
    recode()
  return(data)
}

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
  ggplot(d, aes(x=mobilePay, fill=as.character(educLevel))) + geom_density(alpha = .3)
}


payment_granularity_by_educ <- function(data) {
  d$mobilePay = d$mobilePay %% 10
  ggplot(d, aes(x=mobilePay, fill=educLevel)) + geom_density(alpha = .3)
}


bill_vs_edu <- function(data) {
  d <- data[!is.na(data$mobilePay),]
  sum_d <- group_by(d, xxcity) %>%
    summarise(bill = mean(mobilePay), educ = mean(educLevel))
  return(sum_d)
}

