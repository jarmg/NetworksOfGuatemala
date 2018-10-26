

run.prensaAnalysis <- function(){
  
  plot(md2$avgPerfRatio4g, md2$perfDiff4g)
  
  dt <- getPrensaData()
  prensa <- dt[dt$`sum(subscribers)` > 0,]
  
  summary(lm(md$`sum(bytes_down)`/md$`sum(subscribers)` ~ md$perfRatio3g))
  summary(lm(md$`sum(subscribers)`/md$`sum(subs)` ~ md$perfRatio4g))
  mean(md$`sum(bytes_down)`/md$`sum(subscribers)`)
  md[is.na(md$subs),]
  md$`sum(subscribers)`/md$`sum(subs)` 
  md = md[md$`sum(subs)` != 0,]
  
  md$`sum(subscribers)`[is.na(md$`sum(subscribers)`)] <- 0
  md$`sum(subscribers)`
  
  
  #TODO: Use a poisson on number of subscribers
  summary(lm(md$`sum(subscribers)` ~ md$perfRatio4g))  
}


plot.perfByDate <- function(perf) {
  perf$fct_dt <- factor(perf$fct_dt)
  f <- group_by(perf, fct_dt) %>%
    summarise(
      perf3g = mean(timenavreq803g/time3g, na.rm = T),
      perf4g = mean(timenavreq804g/time4g, na.rm = T),
      time3g = sum(time3g)
    )
  ggplot() +
    geom_point(
      data = f, 
      aes(x = f$fct_dt, y = f$perf3g, color = "red")
    )
}


plot.navData <- function(navData) {
  navData$service_name <- factor(navData$service_name)
  gnd <- group_by(navData, service_name) %>% 
    summarise(subs = sum(subscribers, na.rm = T))
  plot(gnd)
  ggplot() +
    geom_line(
      data = gnd, 
      aes(x = date_time, 
          y = subscribers,
          color = "red"
      )
    )
}



