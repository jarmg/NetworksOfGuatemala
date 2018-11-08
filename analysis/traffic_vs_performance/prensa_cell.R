library(dplyr)


qosDataPath <- "~/Guatemala/NetworksOfGuatemala/data/tigo/perfMaySept.json"
navDataPath <- "~/Guatemala/NetworksOfGuatemala/data/tigo/PrensaNavData.json"
cellDataPath <- "~/Guatemala/NetworksOfGuatemala/data/tigo/cells.csv"

addCellAverages <- function(prensa) {                                      
  cellAvg <- group_by(prensa, bts_sh_nm) %>%                               
    summarise(                                                             
           cellAvgPerfRatio3g = mean(perfRatio3g, na.rm = T),              
           cellAvgPerfRatio4g = mean(perfRatio4g, na.rm = T),              
           cellAvgPrensaSubs = mean(subscribers, na.rm = T),               
           cellAvgPrensaDown = mean(bytesdown, na.rm = T)                  
    )                                                                      
                                                                           
    left_join(prensa, cellAvg) %>%                                         
      mutate(cellPerfDiff4g   = perfRatio4g - cellAvgPerfRatio4g,          
              cellPerfDiff3g  = perfRatio3g - cellAvgPerfRatio3g,          
              cellBytesDiff   = bytesdown - cellAvgPrensaDown,             
              cellSubsDiff    = subscribers - cellAvgPrensaSubs)           
}                                                                          
     

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

get.prensa.cellData <- function() {                                        
  traffic <- readLines(navDataPath) %>% jsonlite::fromJSON()               
  perf <- readLines(qosDataPath)    %>% jsonlite::fromJSON()               
  d <- aggregate.cellAndMonth(traffic, perf)                               
  d <- mergeLocationData(d)                                                
  addCellAverages(d)                                                       
} 

run.subsAndPerfByCell <- function(prensaData, shouldPlot= F, net4g= T) {   
  # Relationship between variance from 5 month mean for # of prensa        
  # subscribers and cell performance ratio                                 
                                                                           
  if (missing(prensaData)) { prensaData <- get.prensa.cellData() }         
                                                                           
  if(net4g){ netData <- prensaData$cellPerfDiff4g}                         
  else {netData <- prensaData$cellPerfDiff3g}                              
  if (shouldPlot){ plot(prensaData$cellSubsDiff, netData)}                 
                                                                           
  lm(prensaData$cellSubsDiff ~ netData)                                    
}                                                                          
