library(foreign)
library(dplyr)
library(ggplot2)

source('/home/jared/Guatemala/NetworksOfGuatemala/gem/variables.r')

GEM_FILE = '/home/jared/Guatemala/NetworksOfGuatemala/gem/gem_2018.sav'


load_data <- function() {
  data <-
    read.spss(GEM_FILE) %>%
    data.frame() %>%
    recode()
  return(data)
}


cell_payments_by_eth <- function(data, numb) {
  ggplot(d, aes(x=PAY_CELL, fill=ETHNICITY)) + geom_density(alpha = .3)
}

cell_payments_by_edu <- function(data, educ_lvls) {
  d = filter(data, EDUC_LEVEL %in% educ_lvls)
  print(educ_lvls)
  ggplot(d, aes(x=PAY_CELL, fill=as.character(EDUC_LEVEL))) + geom_density(alpha = .3)
}


payment_granularity_by_educ <- function(data) {
  d$PAY_CELL = d$PAY_CELL %% 10
  ggplot(d, aes(x=PAY_CELL, fill=EDUC_LEVEL)) + geom_density(alpha = .3)
}


bill_vs_edu <- function(data) {
  d <- data[!is.na(data$PAY_CELL),]
  sum_d <- group_by(d, xxcity) %>%
    summarise(bill = mean(PAY_CELL), educ = mean(EDUC_LEVEL))
  return(sum_d)
}

