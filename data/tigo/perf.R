library(dplyr)
library(ggplot2)

js <- readLines("export.json")
data <- jsonlite::fromJSON(js)

plot.perfByDate <- function() {
	data$fct_dt <- factor(data$fct_dt)
	f <- group_by(data, fct_dt) %>%
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


perfVariance(data) {
  perf = data$perf3g
  var(perf)  
}


plot.perfByDate()


