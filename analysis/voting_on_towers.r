# Builds a basic OLS regression model that looks at the relationship 
# between the number of cell towers in a muni and voter participation in 
# 2015

library(dplyr)

unwanted_array = list(    'Š'='S', 'š'='s', 'Ž'='Z', 'ž'='z', 'À'='A',
                          'Á'='A', 'Â'='A', 'Ã'='A', 'Ä'='A', 'Å'='A',
                          'Æ'='A', 'Ç'='C', 'È'='E', 'É'='E', 'Ê'='E',
                          'Ë'='E', 'Ì'='I', 'Í'='I', 'Î'='I', 'Ï'='I',
                          'Ñ'='N', 'Ò'='O', 'Ó'='O', 'Ô'='O', 'Õ'='O',
                          'Ö'='O', 'Ø'='O', 'Ù'='U', 'Ú'='U', 'Û'='U',
                          'Ü'='U', 'Ý'='Y', 'Þ'='B', 'ß'='Ss', 'à'='a',
                          'á'='a', 'â'='a', 'ã'='a', 'ä'='a', 'å'='a',
                          'æ'='a', 'ç'='c', 'è'='e', 'é'='e', 'ê'='e',
                          'ë'='e', 'ì'='i', 'í'='i', 'î'='i', 'ï'='i',
                          'ð'='o', 'ñ'='n', 'ò'='o', 'ó'='o', 'ô'='o',
                          'õ'='o', 'ö'='o', 'ø'='o', 'ù'='u', 'ú'='u',
                          'û'='u', 'ý'='y', 'ý'='y', 'þ'='b', 'ÿ'='y' )

voting <-
  read.csv('~/Guatemala/NetworksOfGuatemala/data/election_data/elecData2015.csv', encoding = 'latin1')
pop    <-
  read.csv('~/Guatemala/NetworksOfGuatemala/data/populationByMuni.csv', encoding = 'latin1')
towers <-
  read.csv('~/Guatemala/NetworksOfGuatemala/data/tower_data/cellTowers_1_2018.csv', encoding = 'latin1')


removeAccents  <- function(strings) {
  chartr(paste(names(unwanted_array), collapse=''),
         paste(unwanted_array, collapse=''), strings)
}


prepData  <- function() {
  voting$muni <- tolower(voting$MUNI)      %>% removeAccents
  pop$muni    <- tolower(pop$Municipio)    %>% removeAccents
  towers$muni <- tolower(towers$Municipio) %>% removeAccents
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



