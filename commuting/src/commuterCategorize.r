require(dplyr)
require(modeest)
require(lubridate)
library(XML)
library(bitops)
library(RCurl)


# time range within a person is assumed to be home
BEGINTIME = 1 # 1:00am
ENDTIME = 6 # 6:00am

CDR = "Projects/guatemala/raw_data/dummySet.csv"
TOWER_LOCATIONS = "Projects/guatemala/raw_data/tower_data.csv"

WORK_START_TIME = 8 # work usually starts at this time
WORK_END_TIME = 18 # work usually ends at this time





# makes a sorted mode vector. will be useful for getting the second most common element
#makeModeVector <- function (v) with(rle(sort(v)), values[order(lengths, decreasing = TRUE)])
#getMode <- function(x) {
  #v = makeModeVector(x)
  #return(v[1])
#}



# can probably delete, but check first if parts will be useful
#showHomeAndWorkTowers <- function() {
 # probablePlace <- group_by(cdr,ANUMBER, START_DATE_TIME, CELL_ID) %>% summarise(PLACE = homeOrWork(START_DATE_TIME)) %>%
  #  group_by(ANUMBER, PLACE) %>% summarise(CELL_ID = getMode(CELL_ID)) %>%
   # merge(towers, by = "CELL_ID") %>%
  #return()
#}





##############################

# in progress
isItinerant <- function(x) {
  # TODO
  # from paper:
  # If that cell has less than 30 percent more activity than the next-most-active cell during the same period, 
  # it is assumed that the user is itinerant and no home location is assigned.
  ifelse()
}



isWorkTime <- function(x) {
  if ((hour(x) >= WORK_START_TIME) & (hour(x) <= WORK_END_TIME))
    return(TRUE)
  else
    return(FALSE)
}



# determines the probable place
# home = (cell_id in which the individual is most active after 6pm) & !isItinerant()
# work = !home
# uses ifelse to test each element of vector
homeOrWork <- function(x) {
  ifelse(!isWorkTime(x), "Home", "Work")
}



# get the mode of a vector v
getMode <- function(v) {
  print("mode")
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}



getModeByLabel <- function(CELL_ID, PLACE, label) {
  filt <- data.frame(CELL_ID, PLACE) %>%
    filter(PLACE == label) 
  mode = getMode(filt$CELL_ID)
  return(mode)
}



# might need to change
# returns the coordinates of an ANUMBER's work CELL_ID
getWorkCoords <- function(number) {
  coords <- filter(showHomeAndWorkTowers(), ANUMBER == number) %>%
    filter(PLACE == "Work") %>%
    select(LATITUDE, LONGITUDE)
  lat <- coords[1,1]
  lon <- coords[1,2]
  return(paste(lat, lon, sep=","))
}



# might need to change
# returns the coordinates of an ANUMBER's home CELL_ID
getHomeCoords <- function(number) {
  coords <- filter(showHomeAndWorkTowers(), ANUMBER == number) %>%
    filter(PLACE == "Home") %>%
    select(LATITUDE, LONGITUDE)
  lat <- coords[1,1]
  lon <- coords[1,2]
  return(paste(lat, lon, sep=","))
}



# calculates driving distance in km between two points
# from https://stackoverflow.com/questions/16863018/getting-driving-distance-between-two-points-lat-lon-using-r-and-google-map-ap€‹
drivingDistance <- function(origin,destination){
  xml.url <- paste0('http://maps.googleapis.com/maps/api/distancematrix/xml?origins=',origin,'&destinations=',destination,'&mode=driving&sensor=false')
  xmlfile <- xmlParse(getURL(xml.url))
  dist <- xmlValue(xmlChildren(xpathApply(xmlfile,"//distance")[[1]])$value)
  distance <- as.numeric(sub(" km","",dist))
  #ft <- distance*3.28084 # FROM METER TO FEET
  km <- distance/1000.0 # from meters to km
  return(km) 
}



# need to check function after removing ACALLERS with no home/work pairs
showDistance <- function() {
  probablePlace <- group_by(cdr,ANUMBER, START_DATE_TIME, CELL_ID) %>% summarise(PLACE = homeOrWork(START_DATE_TIME)) %>%
    group_by(ANUMBER, PLACE) %>% summarise(CELL_ID = getMode(CELL_ID)) %>%
    merge(towers, by = "CELL_ID") %>%
    mutate(DISTANCE_TO_WORK = drivingDistance(getHomeCoords(ANUMBER),getWorkCoords(ANUMBER))) %>%
    filter(PLACE == "Home") %>%
    return()
}



showHomeAndWorkTowers <- function() {
  probablePlace <- group_by(cdr, ANUMBER, START_DATE_TIME, CELL_ID) %>% 
    summarise(PLACE = homeOrWork(START_DATE_TIME)) %>%
    group_by(ANUMBER) %>%
    summarise(HOME_ID = getModeByLabel(CELL_ID, PLACE, "Home"), WORK_ID = getModeByLabel(CELL_ID, PLACE, "Work")) %>%
    return()
}



# in progress
removeRecordsWithNoHomeWorkPair <- function() {
  # TODO: 
  # get original count of unique ANUMBERS
  # filter out ANUMBERS that do not have pairs
  # get the new count and report the percentage removed
  origNum <- nrow(cdr)
  showHomeAndWorkTowers() %>% filter(!is.na(HOME_ID) & !is.na(WORK_ID)) %>% print()
  
}



# import call detail records into cdr_raw
# import tower locations into towers
# merge data into one table: cdr
getData <- function() {
  cdr_raw <- read.csv(DATALOCATION)
  towers <- read.csv(TOWER_LOCATIONS)
  cdr <- merge(cdr_raw,towers,by="CELL_ID")
}




