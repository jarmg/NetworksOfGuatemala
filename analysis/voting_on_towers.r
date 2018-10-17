# Builds a basic OLS regression model that looks at the relationship 
# between the number of cell towers in a muni and voter participation in 
# 2015

library(dplyr)

source('../utils.R')


voting <-
  read.csv('~/Guatemala/NetworksOfGuatemala/data/election_data/elecData2015.csv', encoding = 'latin1')
pop    <-
  read.csv('~/Guatemala/NetworksOfGuatemala/data/populationByMuni.csv', encoding = 'latin1')
towers <-
  read.csv('~/Guatemala/NetworksOfGuatemala/data/tower_data/cellTowers_1_2018.csv', encoding = 'latin1')


prepData  <- function() {
  voting$muni <- CleanString(voting$MUNI)
  pop$muni    <- CleanString(pop$Municipio) 
  towers$muni <- CleanString(towers$Municipio)
  merged      <- merge(voting, pop) %>% merge(towers)
  merged$pop2015  <- as.numeric(gsub(",", "", as.character(merged$X2015)))
  merged$PersPerTower <- merged$pop2015 / merged$Cantidad.de.Radiobases
  merged = merged[merged$PersPerTower != Inf,]
  merged$participation  <- 
    (merged$FCN_NUM_VOTES + merged$UNE_NUM_VOTES)/merged$pop2015
  merged
}


run.reg <- function(dat) {
  lm(dat$participation ~ dat$PersPerTower)
}



