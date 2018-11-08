source("../data/tigo/tigo.R")


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


run.subsAndPerfByCell <- function(prensaData, shouldPlot= F, net4g= T) {
  # Relationship between variance from 5 month mean for # of prensa 
  # subscribers and cell performance ratio 
  
  if (missing(prensaData)) { prensaData <- get.prensa.cellData() }
  
  if(net4g){ netData <- prensaData$cellPerfDiff4g}
  else {netData <- prensaData$cellPerfDiff3g}

  if (shouldPlot){ plot(prensaData$cellSubsDiff, netData)}
  
  lm(prensaData$cellSubsDiff ~ netData)
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



