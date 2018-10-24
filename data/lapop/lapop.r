library(haven)
library(dplyr)

ROOT  <- '~/Guatemala/NetworksOfGuatemala' 
DATA  <- 'data/lapop/raw'

lapop.data.load <- function(year= 2017) {
  dataFile  <- paste(ROOT, '/', DATA, '/', year, '.dta', sep='')
  read_dta(dataFile)
}
