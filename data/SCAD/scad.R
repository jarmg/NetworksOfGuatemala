library(dplyr)

scad  <- read.csv('raw/scad_2017.csv')

scad <- scad[scad$countryname == 'Guatemala',]

getYear  <- function(yr) {
  as.character(yr) %>%
    substr(8, 9) %>%
    as.numeric
}

# Show the distribution of years in the dataset. The problem with this
# dataset is the small number of observations in the target time range 
table(sapply(scad$startdate, getYear))
