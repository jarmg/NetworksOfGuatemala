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
  
  md <- merge(perf, traffic, all = T)
  
  plot(md$perfRatio4g, md$`sum(bytes_down)`)
  plot(md$perfRatio3g, md$`sum(bytes_down)`)
  plot(md$perfRatio4g, md$`sum(subscribers)`)
  plot(md$perfRatio4g, md$`sum(bytes_down)`/md$`sum(subscribers)`)
  
  summary(lm(md$`sum(bytes_down)`/md$`sum(subscribers)` ~ md$perfRatio3g))
  
  md$`sum(subscribers)`[is.na(md$`sum(subscribers)`)] <- 0
  md$`sum(subscribers)`
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

plot.perfByDate(perfData)


