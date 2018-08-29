
get_hour <- function(timestamp){
  time = strsplit(as.character(timestamp), ' ')[[1]][2]
  hour = strsplit(time, ':')[[1]][1]
  return(as.numeric(hour))
}
