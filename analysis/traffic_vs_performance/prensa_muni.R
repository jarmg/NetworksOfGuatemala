library(dplyr)

qosDataPath <- "~/Guatemala/NetworksOfGuatemala/data/tigo/perfMaySept.json"
navDataPath <- "~/Guatemala/NetworksOfGuatemala/data/tigo/PrensaNavData.json"
cellDataPath <- "~/Guatemala/NetworksOfGuatemala/data/tigo/cells.csv"    

mergeLocationData <- function(prensa) {                                    
  cells <- read.csv(cellDataPath)                                          
  cells$cell <- cells$CELL_ID                                              
  left_join(prensa, cells)                                                 
}  


aggregate.cellAndMonth <- function(traffic, perf) {                        
  traffic$dateAndCell <- paste(traffic$monthyear, traffic$bts_sh_nm)          
  perf$dateAndCell <- paste(perf$monthyear, perf$lvl_val)                  
  perf$perfRatio3g <- perf$timenavreq3g/perf$time3g                        
  perf$perfRatio4g <- perf$timenavreq4g/perf$time4g                        
  merge(perf, traffic, all = F)                                            
}


aggregate.muni <- function(prensa) {                                       
  cityAvg <- group_by(prensa, CITY) %>%                                    
    summarise(                                                             
           cityAvgPerfRatio3g = mean(perfRatio3g, na.rm = T),              
           cityAvgPerfRatio4g = mean(perfRatio4g, na.rm = T),              
           cityAvgPrensaSubs = mean(subscribers, na.rm = T)                
    )                                                                      
                                                                           
  prensa <- group_by(prensa, CITY, monthyear) %>%                          
    summarise(                                                             
           perfRatio3g = mean(perfRatio3g, na.rm = T),                     
           perfRatio4g = mean(perfRatio4g, na.rm = T),                     
           prensaSubs = sum(subscribers, na.rm = T)                        
    )                                                                      
                                                                           
    left_join(prensa, cityAvg) %>%                                         
      mutate(cityPerfDiff4g  = perfRatio4g - cityAvgPerfRatio4g,           
              cityPerfDiff3g = perfRatio3g - cityAvgPerfRatio3g,           
              citySubsDiff   = prensaSubs - cityAvgPrensaSubs)             
}                                                                          
    

get.prensa.muniData <- function() {                                        
  traffic <- readLines(navDataPath) %>% jsonlite::fromJSON()               
  perf <- readLines(qosDataPath)    %>% jsonlite::fromJSON()               
  d <- aggregate.cellAndMonth(traffic, perf)                               
  d <- mergeLocationData(d)                                                
  aggregate.muni(d)                                                        
}  

                                                                        
run.subsAndPerfByMuni <- function(prensaData, shouldPlot= F, net4g= T) {   
  # Relationship between variance from 5 month mean for # of prensa        
  # subscribers and performance ratio for all cells in a muni              
                                                                           
  if (missing(prensaData)) { prensaData <- get.prensa.muniData() }         
                                                                           
  if(net4g){ netData <- prensaData$cityPerfDiff4g}                         
  else {netData <- prensaData$cityPerfDiff3g}                              
                                                                           
  if (shouldPlot){ plot(prensaData$citySubsDiff, netData)}                 
                                                                           
  lm(prensaData$citySubsDiff ~ netData)                                    
}                                                                          
    
