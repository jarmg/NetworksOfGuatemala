# makes a decreasing sorted vector of all unique vals
make_mode_vec_uniques <- function (v) with(rle(sort(v)), values[order(lengths, decreasing = TRUE)])

# makes a sorted mode vector. will be useful for getting the second most common element
# if the most active tower during a customer’s respective timeframe criteria has less than 30% more activity than the second-most-active tower, then the record is removed.
is_itinerant <- function(cell_ids) {

    if (length(cell_ids) == 1) {
	return(FALSE) 
    }

    new_vec <- as.vector(cell_ids)
    mode_vec_uniques <- make_mode_vec_uniques(new_vec)     
   
    num_instances_most_active_tower <- length(which(cell_ids == mode_vec_uniques[1]))
    num_instances_second_most_active_tower <- sum(cell_ids == mode_vec_uniques[2] )

    print(paste("num instances most act is ", num_instances_most_active_tower))

    if (is.na(num_instances_second_most_active_tower) | (num_instances_second_most_active_tower == 0))
	return(FALSE)

    print(paste("num instances 2nd most act is ", num_instances_second_most_active_tower))

    tot <- (num_instances_most_active_tower) + (num_instances_second_most_active_tower)
    diff_in_percent <- (num_instances_second_most_active_tower) / (tot)

    print(paste("percent active is ", 1 - diff_in_percent))

    if (diff_in_percent < 0.30) {
	print(paste("ANUMBER with this cellID is itinerant", cell_ids))
	return(FALSE)
    }
    return(TRUE) 
}


is_work_time <- function(call_start_time, k_options) {
    if ((get_hour(call_start_time) >= k_options$k_work_start) & (get_hour(call_start_time) <= k_options$k_work_end))
    return(TRUE)
  else
    return(FALSE)
}


# determines the probable place
# home = (cell_id in which the individual is most active after 6pm) & !isItinerant()
# work = !home
# uses ifelse to test each element of vector
home_or_work <- function(call_start_time, k_options) {
  ifelse(!is_work_time(call_start_time, k_options), "Home", "Work")
}

# get the mode of a vector v
get_mode <- function(v) {
    #getModeVector(v)
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

get_mode_by_label <- function(CELL_ID, PLACE, label) {
  filt <- data.frame(CELL_ID, PLACE) %>%
    filter(PLACE == label) 

  #if(isItinerant(filt$CELL_ID)) {
      #return() # returns <NA> (I think)
      #print("found itinerant record")
  #}

  mode = get_mode(filt$CELL_ID)

  print("mode is")
  print(mode)

  return(mode)
}

get_home_id <- function(HOME_TYPE, fcdr, number) {
  filt <- fcdr %>%
    filter(ANUMBER == number)

    ID <- filt$HOME_ID

    return(as.character(ID))
}

get_work_id <- function(fcdr, number) {
  filt <- fcdr %>%
    filter(ANUMBER == number)
  
  ID = filt$WORK_ID
  return(as.character(ID))
}

# in progress
# option: either "city" or "state"
get_geo_info_by_coords <- function(option, lat, lon) {

    geo_information <- revgeo(lat, lon, output = "frame")

    if(option == "city")
	return(geo_information$city)
    else if(option == "state")
	return(geo_information$state)
    else
	stop("Error in getGeoInfoByCoords() call.\n
	      Must specifiy option for first param.\n 
	      Option choices: city or state")
}

get_coords <- function(tower_id, towers) {
  coords <- filter(towers, CELL_ID == tower_id) %>%
   select(LATITUDE, LONGITUDE)
  lat <- coords[1, 1]
  lon <- coords[1, 2]
  return(paste(lat, lon, sep = ","))
}

# calculates driving distance in km between two points
# from https://stackoverflow.com/questions/16863018/getting-driving-distance-between-two-points-lat-lon-using-r-and-google-map-ap€‹
driving_distance <- function(origin, destination){
  
  xml.url <- paste0('http://maps.googleapis.com/maps/api/distancematrix/xml?origins=',origin,'&destinations=',destination,'&mode=driving&sensor=false')
  xmlfile <- xmlParse(getURL(xml.url))
  dist <- xmlValue(xmlChildren(xpathApply(xmlfile,"//distance")[[1]])$value)
  distance <- as.numeric(sub(" km","",dist))
  #ft <- distance*3.28084 # FROM METER TO FEET
  km <- distance/1000.0 # from meters to km
  return(km) 
}


# new distance function:
get_distance <- function(fcdr, towers) {
  dist <- group_by(fcdr, ANUMBER) %>% 
      summarise(distCommute = driving_distance(get_coords(get_home_id(k_options$HOME_TYPE, fcdr, ANUMBER), towers), get_coords(get_work_id(fcdr, ANUMBER), towers)))
  return(dist)
}

show_home_and_work_towers <- function(data, towers, k_options) {
  probable_place <- group_by(data, ANUMBER, START_DATE_TIME, CELL_ID) %>% 
    summarise(PLACE = home_or_work(START_DATE_TIME, k_options)) %>%
    group_by(ANUMBER) %>%
    summarise(HOME_ID = get_mode_by_label(CELL_ID, PLACE, "Home"),
	      WORK_ID = get_mode_by_label(CELL_ID, PLACE, "Work")) %>%
    return()
}


# options for label: tower, city, state
show_home_by_label <- function(data, towers, k_options) {
   
    label <- k_options$k_home_type[1]
    print("label is:")
    print(label)
   
    # if home_type is tower
    if (label == 1) { 	
	probable_place <- group_by(data, ANUMBER, START_DATE_TIME, CELL_ID) %>% 
	    summarise(PLACE = home_or_work(START_DATE_TIME, k_options)) %>%
	    group_by(ANUMBER) %>%
	    summarise(HOME_ID = get_mode_by_label(CELL_ID, PLACE, "Home")) %>%
	    return()
    }

    # home_type is city
    else if (label == 2) { 	
	print("data is:")
	print(head(data))
	probable_place <- group_by(data, ANUMBER, START_DATE_TIME, CITY) %>% 
	    summarise(PLACE = home_or_work(START_DATE_TIME, k_options)) %>%
	    group_by(ANUMBER) %>%
	    summarise(HOME_ID = get_mode_by_label(CITY, PLACE, "Home")) %>%
	    return()
    }

    # home_type is state
    else if (label == 3) { 	
	probable_place <- group_by(data, ANUMBER, START_DATE_TIME, STATE) %>% 
	    summarise(PLACE = home_or_work(START_DATE_TIME, k_options)) %>%
	    group_by(ANUMBER) %>%
	    summarise(HOME_ID = get_mode_by_label(STATE, PLACE, "Home")) %>%
	    return()
    }
}

remove_records_with_no_home_work_pair <- function(data, towers, k_options) {
    
  print("Removing records with no home/work pairs...")
  orig_num <- nrow(data) # get orig num records
  
  #redefine cdr with only pairs
  filt_cdr <- show_home_and_work_towers(data, towers, k_options) %>% 
    filter(!is.na(HOME_ID) & !is.na(WORK_ID)) 

  # get new num records after removing records w/o home and work locs
  new_num <- nrow(filt_cdr)

  print(paste("raw data: ", orig_num, " record(s)", sep = ""))
  print(paste("filtered data: ", new_num, " record(s)", sep = ""))
  print(paste("percentage removed", 100 - (orig_num / new_num)))
  
  return(filt_cdr)
}

remove_records_with_no_home <- function(data, towers, k_options) {
    
  print("Removing records with no home...")
  orig_num <- nrow(data) # get orig num records

  print("home_id is")
  print(data$HOME_ID)

  #redefine cdr showing only recs with homes
  filt_cdr <- show_home_by_label(data, towers, k_options) %>%
    filter(!is.na(HOME_ID) & (HOME_ID != "NOT APPLICABLE") &
	   (HOME_ID != "TO BE DETERMINED" &
	    (HOME_ID != "NIVEL DEPARTAMENTAL")))
print("hey")
  # get new num records after removing records w/o home 
  new_num <- nrow(filt_cdr)

  print(paste("raw data: ", orig_num, " record(s)", sep = ""))
  print(paste("num records with homes: ", new_num, " record(s)", sep = ""))
  print(paste("percentage removed", 100 - (orig_num / new_num)))
  
  return(filt_cdr)
}


# load data and merge CDR with tower info
get_data <- function(PATHS) {
  cdr_raw <- read.csv(PATHS[1]) # import call detail records
  print("Loaded raw data")
  towers <- read.csv(PATHS[2]) # import tower locations
  print("Loaded tower data")
  cdr <- merge(cdr_raw, towers, by="CELL_ID") # merge data into one table
  print("Merged tower and cell data")
  elec_data <- read.csv(PATHS[3]) # import 2015 secondary election data  
  print("Loaded election data")

  
  # make a list of two data frames (cdr and towers)
  df.cdr <- data.frame(cdr) 
  df.towers <- data.frame(towers) 
  df.elec_data <- data.frame(elec_data)
  return(list("cdr" = df.cdr, "towers" = df.towers, "elec_data" = df.elec_data))
}

# init file paths
init_paths <- function() {
  CDR_DATA <- "/Users/tedhadges/Projects/guatemala/raw_data/dummySet.csv"
  TOWER_DATA <- "/Users/tedhadges/Projects/guatemala/raw_data/tower_data.csv"
  ELECTION_DATA <- "../../mapping/data/elecData2015.csv"
  PATHS <- c(CDR_DATA, TOWER_DATA, ELECTION_DATA)
  
  return(PATHS)
}

# MANUALLY SET ALL PARAMS/OPTIONS HERE
# Return a dataframe of all params
# The dframe is like a hashmap where the column names are
# keys and the elements in the row are values
set_options<- function() {
 
  k_work_start_time <- 8 # set work start time here
  k_work_end_time <- 18 # set work end time here 
 
  # use HOME_TYPE to define how to classify HOME_ID 
  # opts: tower: 1, city: 2, state: 3 
  k_home_id_type <- 2   

  k_options_frame <- data.frame("k_work_start", "k_work_end", "k_home_type")
  k_options_frame$k_work_start <- k_work_start_time
  k_options_frame$k_work_end <- k_work_end_time 
  k_options_frame$k_home_type <- k_home_id_type

  return(k_options_frame)
}


# check if packs installed and load them
load_packs <- function() {

    source('/Users/tedhadges/Projects/guatemala/NetworksOfGuatemala/commuting/src/timeParser.r')

  list_of_packages <- c("dplyr", "modeest", "lubridate", "XML", "bitops", "RCurl", "profvis", "ggmap", "reshape")
  new_packages <- list_of_packages[!(list_of_packages %in% installed.packages()[,"Package"])]
  if(length(new_packages)) install.packages(new_packages)
  
  # load the packs
  library(dplyr)
  library(modeest)
  library(lubridate)
  library(XML)
  library(bitops)
  library(RCurl)
  library(reshape)
}

# input is a two-column dframe with ANUMBER HOME_ID
group_by_home_loc <- function(dframe) {

    groupedFrame <- group_by(dframe, HOME_ID) %>%
	tally() %>%
	return()
}

# in progress
plot_by_home_id <- function(dframe) {
	
    plot(x, axes = FALSE,
    #axis(side = 1, at = c(1,5,10))

    #axis(side = 2, at = c(1,3,7,10))

    main="Number of Callers by Home Location",
    xlab="Home IDs",
    ylab="Number of Callers",
    type="b",
    col="blue")
    lines(x,col="red")
    fill=c("blue")
}

main_commute <- function() {
  load_packs() # install (if necessary) and load packages
  PATHS <- init_paths() # init file paths
  k_options <- set_options() # dframe with all params/options

  data_list <- get_data(PATHS)
  cdr <- data_list$cdr
  towers <- data_list$towers

  #fcdr <- removeRecordsWithNoHomeWorkPair(cdr, towers, threshs)
  print("cdr is:")
  print(head(cdr))

  fcdr <- remove_records_with_no_home(cdr, towers, k_options)
  
  #fcdr_dist <- get_distance(fcdr, towers)
  cdr_for_plotting<- group_by_home_loc(fcdr)
  
  return(cdr_for_plotting)
}
