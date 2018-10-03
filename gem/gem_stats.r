library(foreign)
library(dplyr)
library(ggplot2)

source('variables.r')

GEM_FILE = "./gem_2018.sav"


load_data <- function() {
  data <-
    read.spss(GEM_FILE) %>%
    data.frame() %>%
    recode()
  return(data)
}


cell_payments_by_eth <- function(data, numb) {
  d = filter(data,
             PAY_CELL < numb &
               (ETHNICITY == "Indígena (Maya)" |  ETHNICITY == "No indígena (ladino)")
             )
  ggplot(d, aes(x=PAY_CELL, fill=ETHNICITY)) + geom_density(alpha = .3)
}


payment_granularity_by_educ <- function(data) {
  d = filter(data,
             PAY_CELL < 450 &
               (ETHNICITY == "Indígena (Maya)" |  ETHNICITY == "No indígena (ladino)")
             )
  d$PAY_CELL = d$PAY_CELL %% 10
  ggplot(d, aes(x=PAY_CELL, fill=EDUC_LEVEL)) + geom_density(alpha = .3)
}
