library(dplyr)

addCellAverages <- function(prensa) {
  callAvg <- group_by(prensa, bts_sh_nm) %>%
    summarise(
           avgPerfRatio3g = mean(perfRatio3g, na.rm = T),
           avgPerfRatio4g = mean(perfRatio4g, na.rm = T),
           avgPrensaSubs = mean(`sum(subscribers)`, na.rm = T),
           avgPrensaDown = mean(`sum(bytes_down)`, na.rm = T)
    )

    left_join(prensa, callAvg) %>%
      mutate(perfDiff4g = perfRatio4g - avgPerfRatio4g,
              perfDiff3g = perfRatio3g - avgPerfRatio3g,
              diffBytes = `sum(bytes_down)` - avgPrensaDown,
              diffSubs =  `sum(subscribers)` - avgPrensaSubs)
}


mergeOnCellAndMonth <- function(traffic, perf) {
  traffic$dateAndCell <- paste(traffic$`to_char(date_time,'yyyy-mm')`, traffic$bts_sh_nm)
  perf$dateAndCell <- paste(perf$`to_char(fct_dt,'yyyy-mm')`, perf$lvl_val)
  perf$perfRatio3g <- perf$`sum(timenavreq803g)`/perf$`sum(time3g)`
  perf$perfRatio4g <- perf$`sum(timenavreq804g)`/perf$`sum(time4g)`

  merge(perf, traffic, all = F)
}


getPrensaData <- function() {
  traffic <- readLines("PrensaNavData.json") %>% jsonlite::fromJSON()
  perf <- readLines("perfMaySept.json") %>% jsonlite::fromJSON()
  
  d <- mergeOnCellAndMonth(traffic, perf)
  addCellAverages(d)
}
  


