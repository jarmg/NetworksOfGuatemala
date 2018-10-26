library(dplyr)
library(ggplot2)

perf <- readLines("WQ_perfdata.json")
perfData <- jsonlite::fromJSON(perf)

nav <- readLines("WQ_navdata.json")
navData <- jsonlite::fromJSON(nav)


getPrensaData <- function() {
  traffic <- readLines("PrensaNavData.json") %>% jsonlite::fromJSON()
  perf <- readLines("perfMaySept.json") %>% jsonlite::fromJSON()
  
  traffic$dateAndCell <- paste(traffic$`to_char(date_time,'yyyy-mm')`, traffic$bts_sh_nm)
  perf$dateAndCell <- paste(perf$`to_char(fct_dt,'yyyy-mm')`, perf$lvl_val)
  perf$perfRatio3g <- perf$`sum(timenavreq803g)`/perf$`sum(time3g)`
  perf$perfRatio4g <- perf$`sum(timenavreq804g)`/perf$`sum(time4g)`
  
  md <- merge(perf, traffic, all = F)
  md$`sum(subscribers)`[is.na(md$`sum(subscribers)`)] <- 0
  
  
  callAvg<- group_by(md, bts_sh_nm) %>%
    summarise(
           avgPerfRatio3g = mean(perfRatio3g, na.rm = T),
           avgPerfRatio4g = mean(perfRatio4g, na.rm = T),
           avgPrensaSubs = mean(`sum(subscribers)`, na.rm = T),
           avgPrensaDown = mean(`sum(bytes_down)`, na.rm = T)
    )
  
           
  md2 <- left_join(md, callAvg)
  tail(md2[md$lvl_val == 'WZCP894E',])
  md2 <- mutate(md2,
                perfDiff4g = perfRatio4g - avgPerfRatio4g,
                perfDiff3g = perfRatio3g - avgPerfRatio3g,
                diffBytes = `sum(bytes_down)` - avgPrensaDown,
                diffSubs =  `sum(subscribers)` - avgPrensaSubs)
}
  


