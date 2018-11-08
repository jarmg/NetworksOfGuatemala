library(dplyr)

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

run.subsAndPerfByCelltoCell <- function(prensaData) {                      
  # Relationship between variance from 5 month mean for each cell          
  # vs national average of variance for the month for # of prensa          
  # subscribers and cell performance ratio                                 
                                                                           
  if (missing(prensaData)) { prensaData <- get.prensa.cellData() }         
                                                                           
  #collect average of the local monthly cell variance across the state     
  grouped <- group_by(prensaData, monthyear, STATE) %>%                    
    summarise(stateSubsAvgVar  = mean(cellSubsDiff))                       
                                                                           
  mutated <- left_join(prensaData, grouped) %>%                            
    mutate(subShiftVar = cellSubsDiff - stateSubsAvgVar)                   
  mutated                                                                  
  #plot(subShiftVar, cellPerfDiff4g)                                       
                                                                           
 }          
