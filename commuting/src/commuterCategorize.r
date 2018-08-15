



# makes a decreasing sorted vector of all unique vals
makeModeVecUniques <- function (v) with(rle(sort(v)), values[order(lengths, decreasing = TRUE)])



# makes a sorted mode vector. will be useful for getting the second most common element
# if the most active tower during a customer’s respective timeframe criteria has less than 30% more activity than the second-most-active tower, then the record is removed.
isItinerant <- function(cellIDs) {

    if (length(cellIDs) == 1) {
	return(FALSE) 
    }

    newVec <- as.vector(cellIDs)
    modeVecUniques <- makeModeVecUniques(newVec)     

   
    numInstancesOfMostActiveTower <- length(which(cellIDs == modeVecUniques[1]))
    numInstancesOfSecondMostActiveTower <- sum(cellIDs == modeVecUniques[2] )

    print(paste("num instances most act is ", numInstancesOfMostActiveTower))

    if (is.na(numInstancesOfSecondMostActiveTower) | (numInstancesOfSecondMostActiveTower == 0))
	return(FALSE)

    print(paste("num instances 2nd most act is ", numInstancesOfSecondMostActiveTower))

    tot <- (numInstancesOfMostActiveTower) + (numInstancesOfSecondMostActiveTower)
    diffInPercent <- (numInstancesOfSecondMostActiveTower) / (tot)

    print(paste("percent active is ", 1 - diffInPercent))

    if (diffInPercent < 0.30) {
	print(paste("ANUMBER with this cellID is itinerant", cellIDs))
	return(FALSE)
    }
    return(TRUE) 
}


isWorkTime <- function(x, threshs) {
  source('/Users/tedhadges/Projects/guatemala/NetworksOfGuatemala/commuting/src/timeParser.r')
  if ((getHour(x) >= threshs[1]) & (getHour(x) <= threshs[2]))
    return(TRUE)
  else
    return(FALSE)
}


# determines the probable place
# home = (cell_id in which the individual is most active after 6pm) & !isItinerant()
# work = !home
# uses ifelse to test each element of vector
homeOrWork <- function(callStartTime, threshs) {
  ifelse(!isWorkTime(callStartTime, threshs), "Home", "Work")
}


# get the mode of a vector v
getMode <- function(v) {
    #getModeVector(v)
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}


getModeByLabel <- function(CELL_ID, PLACE, label) {
  filt <- data.frame(CELL_ID, PLACE) %>%
    filter(PLACE == label) 

  if(isItinerant(filt$CELL_ID)) {
      #return() # returns <NA> (I think)
      print("found itinerant record")
  }

  mode = getMode(filt$CELL_ID)
  return(mode)
}


getHomeID <- function(fcdr, number) {
  filt <- fcdr %>%
    filter(ANUMBER == number)
  
  ID = filt$HOME_ID
  return(as.character(ID))
}

getWorkID <- function(fcdr, number) {
  filt <- fcdr %>%
    filter(ANUMBER == number)
  
  ID = filt$WORK_ID
  return(as.character(ID))
}


getCoords <- function(tower_ID, towers) {
  coords <- filter(towers, CELL_ID == tower_ID) %>%
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


# new distance function:
getDistance <- function(fcdr, towers) {
  dist <- group_by(fcdr, ANUMBER) %>% summarise(distCommute = drivingDistance(getCoords(getHomeID(fcdr, ANUMBER), towers), getCoords(getWorkID(fcdr, ANUMBER), towers)))
  return(dist)
}



showHomeAndWorkTowers <- function(data, towers, threshs) {
  probablePlace <- group_by(data, ANUMBER, START_DATE_TIME, CELL_ID) %>% 
    summarise(PLACE = homeOrWork(START_DATE_TIME, threshs)) %>%
    group_by(ANUMBER) %>%
    summarise(HOME_ID = getModeByLabel(CELL_ID, PLACE, "Home"), WORK_ID = getModeByLabel(CELL_ID, PLACE, "Work")) %>%
    return()
}


# in progress
removeRecordsWithNoHomeWorkPair <- function(data, towers, threshs) {
  # TODO: 
  # get original count of unique ANUMBERS
  # filter out ANUMBERS that do not have pairs
  # get the new count and report the percentage removed
  
  print("Removing records with no home/work pairs...")
  origNum <- nrow(data) # get orig num records
  
  filt_cdr <- showHomeAndWorkTowers(data, towers, threshs) %>% 
    filter(!is.na(HOME_ID) & !is.na(WORK_ID)) #redefine cdr with only pairs
  

  newNum <- nrow(filt_cdr) # get new num records after removing records w/o home and work locs
  
  print(paste("raw data: ", origNum, " record(s)", sep=""))
  print(paste("filtered data: ", newNum, " record(s)", sep=""))
  print(paste("percentage removed", 100 - (origNum/newNum)))
  
  return(filt_cdr)
}



# load data and merge CDR with tower info
getData <- function(paths) {
  cdr_raw <- read.csv(paths[1]) # import call detail records
  print("Loaded raw data")
  towers <- read.csv(paths[2]) # import tower locations
  print("Loaded tower data")
  cdr <- merge(cdr_raw,towers,by="CELL_ID") # merge data into one table
  print("Merged tower and cell data")
  
  # make a list of two data frames (cdr and towers)
  df.cdr <- data.frame(cdr) 
  df.towers <- data.frame(towers) 
  return(list("cdr"=df.cdr, "towers"=df.towers))
  
}

# init file paths
initPaths <- function() {
  CDR_DATA <- "/Users/tedhadges/Projects/guatemala/raw_data/dummySet.csv"
  TOWER_DATA <- "/Users/tedhadges/Projects/guatemala/raw_data/tower_data.csv"
  paths <- c(CDR_DATA, TOWER_DATA)
  
  return(paths)
}

initThresholds <- function() {
# work time thresholds
  WORK_START_TIME <- 8 # work usually starts at this time
  WORK_END_TIME <- 18 # work usually ends at this time
  threshs <- c(WORK_START_TIME, WORK_END_TIME)
}


# check if packs installed and load them
loadPacks <- function() {
  list.of.packages <- c("dplyr", "modeest", "lubridate", "XML", "bitops", "RCurl", "profvis")
  new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
  if(length(new.packages)) install.packages(new.packages)
  
  # load the packs
  library(dplyr)
  library(modeest)
  library(lubridate)
  library(XML)
  library(bitops)
  library(RCurl)
}

    

main <- function() {
  loadPacks() # install (if necessary) and load packages
  paths <- initPaths() # init file paths
  threshs <- initThresholds() # init threshold vals
  
  dataList <- getData(paths)
  cdr <- dataList$cdr
  towers <- dataList$towers
  
  fcdr <- removeRecordsWithNoHomeWorkPair(cdr, towers, threshs)
  fcdr_dist <- getDistance(fcdr, towers)
  
  return(fcdr_dist)
}
