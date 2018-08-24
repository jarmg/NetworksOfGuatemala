



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


isWorkTime <- function(callStartTime, OPTIONS) {
    if ((getHour(callStartTime) >= OPTIONS$WORK_START_TIME) & (getHour(callStartTime) <= OPTIONS$WORK_END_TIME))
    return(TRUE)
  else
    return(FALSE)
}


# determines the probable place
# home = (cell_id in which the individual is most active after 6pm) & !isItinerant()
# work = !home
# uses ifelse to test each element of vector
homeOrWork <- function(callStartTime, OPTIONS) {
  ifelse(!isWorkTime(callStartTime, OPTIONS), "Home", "Work")
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

  #if(isItinerant(filt$CELL_ID)) {
      #return() # returns <NA> (I think)
      #print("found itinerant record")
  #}

  mode = getMode(filt$CELL_ID)
  return(mode)
}


# options: tower, city, state
# Note: I think options can be deleted here since, 
# at this point, the ID will always be whatever is in the HOME_ID column
getHomeID <- function(HOME_TYPE, fcdr, number) {
  filt <- fcdr %>%
    filter(ANUMBER == number)

	#option <- HOME_TYPE

	ID <- filt$HOME_ID
#print("homeID is:")
#print(ID)

 
    #if (option == 1) 
    #  ID <- filt$HOME_ID

    #else if (option == 2) 
#	ID <- filt$CITY

#    else if (option == 3)
#	ID <- filt$STATE
#    else
#	stop("Must specifiy option in param 1 of getHomeID. Choices: tower, city, state")

      return(as.character(ID))
}

getWorkID <- function(fcdr, number) {
  filt <- fcdr %>%
    filter(ANUMBER == number)
  
  ID = filt$WORK_ID
  return(as.character(ID))
}


# in progress
# option: either "city" or "state"
getGeoInfoByCoords <- function(option, lat, lon) {

    geo_information <- revgeo(lat,lon,output="frame")

    if(option == "city")
	return(geo_information$city)
    else if(option == "state")
	return(geo_information$state)
    else
	stop("Error in getGeoInfoByCoords() call. Must specifiy option for first param. Option choices: city or state")
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
  dist <- group_by(fcdr, ANUMBER) %>% 
      summarise(distCommute = drivingDistance(getCoords(getHomeID(OPTIONS$HOME_TYPE, fcdr, ANUMBER), towers), getCoords(getWorkID(fcdr, ANUMBER), towers)))
  return(dist)
}


showHomeAndWorkTowers <- function(data, towers, OPTIONS) {
  probablePlace <- group_by(data, ANUMBER, START_DATE_TIME, CELL_ID) %>% 
    summarise(PLACE = homeOrWork(START_DATE_TIME, OPTIONS)) %>%
    group_by(ANUMBER) %>%
    summarise(HOME_ID = getModeByLabel(CELL_ID, PLACE, "Home"), WORK_ID = getModeByLabel(CELL_ID, PLACE, "Work")) %>%
    return()
}


# options for label: tower, city, state
showHomeByLabel <- function(data, towers, OPTIONS) {
   
    label <- OPTIONS$HOME_TYPE[1]
    
    if (label == 1) { # home_type is tower
	probablePlace <- group_by(data, ANUMBER, START_DATE_TIME, CELL_ID) %>% 
	    summarise(PLACE = homeOrWork(START_DATE_TIME, OPTIONS)) %>%
	    group_by(ANUMBER) %>%
	    summarise(HOME_ID = getModeByLabel(CELL_ID, PLACE, "Home")) %>%
	    return()
    }

    else if (label == 2) { # home_type is city
	probablePlace <- group_by(data, ANUMBER, START_DATE_TIME, CITY) %>% 
	    summarise(PLACE = homeOrWork(START_DATE_TIME, OPTIONS)) %>%
	    group_by(ANUMBER) %>%
	    summarise(HOME_ID = getModeByLabel(CITY, PLACE, "Home")) %>%
	    return()
    }


    else if (label == 3) { # home_type is state
	
	probablePlace <- group_by(data, ANUMBER, START_DATE_TIME, STATE) %>% 
	    summarise(PLACE = homeOrWork(START_DATE_TIME, OPTIONS)) %>%
	    group_by(ANUMBER) %>%
	    summarise(HOME_ID = getModeByLabel(STATE, PLACE, "Home")) %>%
	    return()
    }




}





removeRecordsWithNoHomeWorkPair <- function(data, towers, OPTIONS) {
    
  print("Removing records with no home/work pairs...")
  origNum <- nrow(data) # get orig num records
  
  filt_cdr <- showHomeAndWorkTowers(data, towers, OPTIONS) %>% 
    filter(!is.na(HOME_ID) & !is.na(WORK_ID)) #redefine cdr with only pairs

  newNum <- nrow(filt_cdr) # get new num records after removing records w/o home and work locs
  
  print(paste("raw data: ", origNum, " record(s)", sep=""))
  print(paste("filtered data: ", newNum, " record(s)", sep=""))
  print(paste("percentage removed", 100 - (origNum/newNum)))
  
  return(filt_cdr)
}

removeRecordsWithNoHome <- function(data, towers, OPTIONS) {
    
  print("Removing records with no home...")
  origNum <- nrow(data) # get orig num records

  
  filt_cdr <- showHomeByLabel(data, towers, OPTIONS) %>% 
    filter(!is.na(HOME_ID) & (HOME_ID != "NOT APPLICABLE") & (HOME_ID != "TO BE DETERMINED")) #redefine cdr showing only recs with homes

  newNum <- nrow(filt_cdr) # get new num records after removing records w/o home 
  
  print(paste("raw data: ", origNum, " record(s)", sep=""))
  print(paste("num records with homes: ", newNum, " record(s)", sep=""))
  print(paste("percentage removed", 100 - (origNum/newNum)))
  
  return(filt_cdr)
}


# load data and merge CDR with tower info
getData <- function(PATHS) {
  cdr_raw <- read.csv(PATHS[1]) # import call detail records
  print("Loaded raw data")
  towers <- read.csv(PATHS[2]) # import tower locations
  print("Loaded tower data")
  cdr <- merge(cdr_raw,towers,by="CELL_ID") # merge data into one table
  print("Merged tower and cell data")
  elecData <- read.csv(PATHS[3]) # import 2015 secondary election data  
  print("Loaded election data")

  
  # make a list of two data frames (cdr and towers)
  df.cdr <- data.frame(cdr) 
  df.towers <- data.frame(towers) 
  df.elect <- data.frame(elecData)
  return(list("cdr"=df.cdr, "towers"=df.towers, "elecData"=df.elect))
}

# init file paths
initPaths <- function() {
  CDR_DATA <- "/Users/tedhadges/Projects/guatemala/raw_data/dummySet.csv"
  TOWER_DATA <- "/Users/tedhadges/Projects/guatemala/raw_data/tower_data.csv"
  ELECTION_DATA <- "../../mapping/data/elecData2015.csv"
  PATHS <- c(CDR_DATA, TOWER_DATA, ELECTION_DATA)
  
  return(PATHS)
}


initThresholds <- function() {
# work time thresholds
  WORK_START_TIME <- 8 # work usually starts at this time
  WORK_END_TIME <- 18 # work usually ends at this time
  threshs <- c(WORK_START_TIME, WORK_END_TIME)
}


# MANUALLY SET ALL PARAMS/OPTIONS HERE
# Return a dataframe of all params
# The dframe is like a hashmap where the column names are
# keys and the elements in the row are values
setOptions<- function() {
 
  WORK_START <- 8 # set work start time here
  WORK_END <- 18 # set work end time here 
 
  # use HOME_TYPE to define how to classify HOME_ID 
  # opts: tower: 1, city: 2, state: 3 
  HOME_CLASSIFY_DEF <- 2   

  optionsFrame <- data.frame("WORK_START_TIME", "WORK_END_TIME", "HOME_TYPE")
  optionsFrame$WORK_START_TIME <- WORK_START
  optionsFrame$WORK_END_TIME <- WORK_END
  optionsFrame$HOME_TYPE <- HOME_CLASSIFY_DEF

  return(optionsFrame)
}


# check if packs installed and load them
loadPacks <- function() {

    source('/Users/tedhadges/Projects/guatemala/NetworksOfGuatemala/commuting/src/timeParser.r')

  list.of.packages <- c("dplyr", "modeest", "lubridate", "XML", "bitops", "RCurl", "profvis", "ggmap")
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

# input is a two-column dframe with ANUMBER HOME_ID
groupByHomeLoc <- function(dframe) {

    groupedFrame <- group_by(dframe, HOME_ID) %>%
	#summarise(numAnums = count(dframe)) %>%
	tally() %>%
	return()
}

plotByHomeID <- function(dframe) {
	
    plot(x, axes = FALSE,
    #axis(side = 1, at = c(1,5,10))

    #axis(side = 2, at = c(1,3,7,10))

    #box()
    main="Number of Callers by Home Location",
    xlab="Home IDs",
    ylab="Number of Callers",
    type="b",
    col="blue")
    lines(x,col="red")
    fill=c("blue")
}


mainCommute <- function() {
  loadPacks() # install (if necessary) and load packages
  PATHS <- initPaths() # init file paths
  #threshs <- initThresholds() # init threshold vals
  OPTIONS <- setOptions() # dframe with all params/options

   
  dataList <- getData(PATHS)
  cdr <- dataList$cdr
  towers <- dataList$towers

  #print("datalist is:")
  #print(head(dataList))
  
  #fcdr <- removeRecordsWithNoHomeWorkPair(cdr, towers, threshs)

  fcdr <- removeRecordsWithNoHome(cdr, towers, OPTIONS)
  
  #fcdr_dist <- getDistance(fcdr, towers)
  cdrForPlotting<- groupByHomeLoc(fcdr)
  
  return(cdrForPlotting)
}

