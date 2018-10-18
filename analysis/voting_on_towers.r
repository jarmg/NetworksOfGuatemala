# Builds a basic OLS regression model that looks at the relationship 
# between the number of cell towers in a muni and voter participation in 
# 2015

library(dplyr)

source('~/Guatemala/NetworksOfGuatemala/utils.R')


voting <-
  read.csv('~/Guatemala/NetworksOfGuatemala/data/election_data/elecData2015.csv', encoding = 'latin1')
pop    <-
  read.csv('~/Guatemala/NetworksOfGuatemala/data/populationByMuni.csv', encoding = 'latin1')
towers <-
  read.csv('~/Guatemala/NetworksOfGuatemala/data/tower_data/cellTowers_1_2018.csv', encoding = 'latin1')


prepData  <- function() {
  voting$muni <- CleanStrings(voting$MUNI)
  pop$muni    <- CleanStrings(pop$Municipio) 
  towers$muni <- CleanStrings(towers$Municipio)
  merged      <- merge(voting, pop) %>% merge(towers)
  merged$pop2015  <- as.numeric(gsub(",", "", as.character(merged$X2015)))
  merged$PersPerTower <- merged$pop2015 / merged$Cantidad.de.Radiobases
  merged = merged[merged$PersPerTower != Inf,]
  merged$participation  <- 
    (merged$FCN_NUM_VOTES + merged$UNE_NUM_VOTES)/merged$pop2015
  merged
}


mergeGem  <- function(dat, gem) {
  gem$muni  <- CleanStrings(gem$xxcity)
  gg  <- group_by(gem, muni) %>%
            dplyr::summarize(
                      count     = n(),
                      income    = mean(incomeHousehold, na.rm = T),
                      mobilePay = mean(mobilePay, na.rm = T),
                      indig     = mean(indig, na.rm = T),
                      mobilePersonal = mean(mobilePersonal, na.rm = T)
            )
  merge(gg, dat)
}

run.ParticTowers <- function() {
  prepData() %>% attach
  lm(participation ~ PersPerTower)
}

run.ParticTowersIncome <- function() {
  gem <- load.gem.data()
  prepData() %>% mergeGem(gem) %>% attach
  lm(participation ~ PersPerTower + log(income))
}

run.ParticTowersEthnic <- function() {
  gem <- load.gem.data()
  prepData() %>% mergeGem(gem) %>% attach
  lm(participation ~ PersPerTower + indig)
}

run.ParticTowersForInternetUsers <- function() {
  gem <- load.gem.data()
  gem <- gem[gem$newsCntry == "A través de internet",]
  prepData() %>% mergeGem(gem) %>% attach
  lm(participation ~ PersPerTower)
}

