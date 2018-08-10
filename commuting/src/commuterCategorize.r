require(dplyr)
require(modeest)
require(lubridate)


# time range within a person is assumed to be home
BEGINTIME = 1 # 1:00am
ENDTIME = 6 # 6:00am

DATALOCATION = "Projects/guatemala/raw_data/dummySet.csv"


# determines the probable place
# uses ifelse to test each element of vector
homeOrWork <- function(x) {
  ifelse(weekdays(as.Date(x)) == "Saturday" | (weekdays(as.Date(x)) == "Sunday") & isNightTime(x), "Home", "Work")
}

# use this to set the constraints for what is considered night time
isNightTime <- function(x) {
  if (hour(x) >= BEGINTIME & hour(x) <= ENDTIME)
    return (TRUE)
  else
    return(FALSE)
}

# get the mode of a vector v
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

# import call detail records into cdr
getData <- function() {
  cdr <- read.csv(DATALOCATION)
}


showHomeAndWorkTowers <- function() {
  probablePlace <- group_by(cdr,ANUMBER, START_DATE_TIME, CELL_ID) %>% summarise(place = homeOrWork(START_DATE_TIME))
  workID <- group_by(probablePlace, ANUMBER, place) %>% summarise(cell = getmode(CELL_ID))
  return(workID)
}



