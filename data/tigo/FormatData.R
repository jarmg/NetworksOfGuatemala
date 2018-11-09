#Save data json files at RDATA files for increased read performance

library(dplyr)

qosDataPath <- "~/Guatemala/NetworksOfGuatemala/data/tigo/perfMaySept"
navDataPath <- "~/Guatemala/NetworksOfGuatemala/data/tigo/fullNavData"


to.RDS  <- function(pathPrefix) {
  rawPath <- paste0(pathPrefix, '.json')
  newPath <- paste0(pathPrefix, '.RData')
  readLines(rawPath) %>% 
    jsonlite::fromJSON() %>%
    saveRDS(newPath)
}

#to.RDS(qosDataPath)
to.RDS(navDataPath)
