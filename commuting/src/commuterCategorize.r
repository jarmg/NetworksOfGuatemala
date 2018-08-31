# Makes a decreasing sorted vector of all unique vals
# TODO: Use this for is_itinerant() function to compare top two modes
make_mode_vec_uniques <- function (v) with(rle(sort(v)), values[order(lengths, decreasing = TRUE)])

# IN PROGRESS
# Makes a sorted mode vector. 
# Will be useful for obtaining the second most common element 
# if the most active tower during a customer’s respective timeframe criteria 
# has less than 30% more activity than the second-most-active tower, 
# then the record is removed.
#is_itinerant <- function(cell_ids) {

#    if (length(cell_ids) == 1) {
#	return(FALSE) 
#    }
#    new_vec <- as.vector(cell_ids)
#    mode_vec_uniques <- make_mode_vec_uniques(new_vec)     
#    num_instances_most_active_tower <- length(which(cell_ids == mode_vec_uniques[1]))
#    num_instances_second_most_active_tower <- sum(cell_ids == mode_vec_uniques[2] )
#    print(paste("num instances most act is ", num_instances_most_active_tower))
#    if (is.na(num_instances_second_most_active_tower) | (num_instances_second_most_active_tower == 0))
#	return(FALSE)
#    print(paste("num instances 2nd most act is ", num_instances_second_most_active_tower))
#    tot <- (num_instances_most_active_tower) + (num_instances_second_most_active_tower)
#    diff_in_percent <- (num_instances_second_most_active_tower) / (tot)
#    print(paste("percent active is ", 1 - diff_in_percent))
#    if (diff_in_percent < 0.30) {
#	print(paste("ANUMBER with this cellID is itinerant", cell_ids))
#	return(FALSE)
#    }
#    return(TRUE) 
#}


is_work_time <- function(call_start_time, k_options) {
    # Determines whether a call_start_time occurs during typical work hours. 
    #
    # Args:
    #   call_start_time: The time at the start of a call for a given record.
    #   k_options: The data frame containing a set of user-defined
    #              constants.
    #
    # Returns:
    #   TRUE if during work time, FALSE otherwise
    
    if ((get_hour(call_start_time) >= k_options$k_work_start) & (get_hour(call_start_time) <= k_options$k_work_end))
    return(TRUE)
  else
    return(FALSE)
}


home_or_work <- function(call_start_time, k_options) {
    # Determines whether a given call time occurs during work or home hours.
    #
    # Args:
    #   call_start_time: The time at the start of a call for a given record.
    #   k_options: The data frame containing a set of user-defined
    #              constants.
    #
    # Returns:
    #  Since ifelse tests conditions for each vector, it writes "Home" or
    #  "Work" to each element accordingly.

    ifelse(!is_work_time(call_start_time, k_options), "Home", "Work")
}

get_mode <- function(v) {
    # Gets the mode of vector v

    uniqv <- unique(v)
    uniqv[which.max(tabulate(match(v, uniqv)))]
}

get_home_or_work_loc_by_label <- function(possible_locs, home_and_work_vec, label) {
    # Gets the mode of a set of CELL_IDs to determine which is the most likely
    # home/work id.
    #
    # Args:
    #   possible_locs: A single-column dframe of possible_locs. Depending on
    #                  value set in k_options, possible vals could be a
    #                  dframe of cell_ids, munis, or depts.
    #   home_and_work_vec: A single-column dframe with values of "Home" and
    #    	           "Work", which are classified as such by time of 
    #                      day and correspond to the values in possible_locs.
    #   label: The label (can be either "Home" or "Work") which is used to 
    #          filter all possible_locs. E.g. if the input label == "Home",
    #          Then this function will take all possible_locs, subset all
    #          vals such that their corresponding home_work_vec val ==
    #          "Home", and find the mode of possible_locs.
    #
    # Returns:
    #   The most probable home/work location.
        
    possible_locs <- as.data.frame(possible_locs)
    home_and_work_vec <- as.data.frame(home_and_work_vec)
    
    filt <- data.frame(possible_locs, home_and_work_vec) %>%
	filter(home_and_work_vec == label) 

    #if(isItinerant(filt$CELL_ID)) {
    #return() # returns <NA> (I think)
    #print("found itinerant record")
    #}
    
    probable_home_or_work_loc = get_mode(filt$possible_locs)

    return(probable_home_or_work_loc)
}

# TODO: Can use get_id_by_label instead?
get_home_id <- function(fcdr, HOME_TYPE, number) {
    # Gets the home_id of a given number.
    #
    # Args:
    #   HOME_TYPE: The user-defined home type (muni, dept, or cell_id).
    #   fcdr: The filtered cdr data frame.
    #   number: The number for which to get home_id (ANUMBER or BNUMBER).
    #
    # Returns:
    #   The home_id.

    filt <- fcdr %>%
	filter(ANUMBER == number)
    ID <- filt$HOME_ID
    return(as.character(ID))
}

# TODO: Can use get_id_by_label instead?
get_work_id <- function(fcdr, number) {
    # Same as get_home_id but work_id.
  
    filt <- fcdr %>%
	filter(ANUMBER == number)
    ID = filt$WORK_ID
    return(as.character(ID))
}

# IN PROGRESS
# option: either "city" or "state"
#get_geo_info_by_coords <- function(option, lat, lon) {
#    geo_information <- revgeo(lat, lon, output = "frame")
#    if(option == "city")
#	return(geo_information$city)
#    else if(option == "state")
#	return(geo_information$state)
#    else
#	stop("Error in getGeoInfoByCoords() call.\n
#	      Must specifiy option for first param.\n 
#	      Option choices: city or state")
#}


get_coords <- function(tower_id, towers) {
    # Gets the lat/lon coords for a given tower.
    #
    # Args:
    #   tower_id: The tower whose lat/lon coords are to be obtained.
    #   towers: The data frame consisting of all towers and lat/lons.
    #
    # Returns:
    #   The coordinates of the tower.
  
    coords <- filter(towers, CELL_ID == tower_id) %>%
	select(LATITUDE, LONGITUDE)
    lat <- coords[1, 1]
    lon <- coords[1, 2]
    return(paste(lat, lon, sep = ","))
}


# Calculates driving distance in km between two points
# From https://stackoverflow.com/questions/16863018/getting-driving-distance-between-two-points-lat-lon-using-r-and-google-map-ap€‹
driving_distance <- function(origin, destination){
  xml.url <- paste0('http://maps.googleapis.com/maps/api/distancematrix/xml?origins=',origin,'&destinations=',destination,'&mode=driving&sensor=false')
  xmlfile <- xmlParse(getURL(xml.url))
  dist <- xmlValue(xmlChildren(xpathApply(xmlfile,"//distance")[[1]])$value)
  distance <- as.numeric(sub(" km","",dist))
  #ft <- distance*3.28084 # FROM METER TO FEET
  km <- distance/1000.0 # from meters to km
  return(km) 
}


get_distance <- function(fcdr, towers) {
    # Creates a data frame containing the distances between home and work
    # towers.
    #
    # Args:
    #   fcdr: The filtered cdr.
    #   towers: The data frame consisting of all tower data. 
    #
    # Returns:
    #   The data frame of fcdr with an added column of driving distances
    #   between home and work.
  
    dist <- group_by(fcdr, ANUMBER) %>% 
	summarise(distCommute = driving_distance(get_coords(get_home_id(fcdr, k_options$HOME_TYPE, ANUMBER), towers), get_coords(get_work_id(fcdr, ANUMBER), towers)))
  return(dist)
}


show_home_and_work_towers <- function(data, towers, k_options) {
    # Creates a data frame which shows the home/work towers for each
    # ANUMBER.
    #
    # Args:
    #   data: The cdr.
    #   towers: The tower data.
    #   k_options: The data frame containing a set of user-defined
    #              constants.
    #
    # Returns:
    #   The data frame with all home and work towers for each ANUMBER.
  
    probable_place <- group_by(data, ANUMBER, START_DATE_TIME, CELL_ID) %>% 
	summarise(PLACE = home_or_work(START_DATE_TIME, k_options)) %>%
	group_by(ANUMBER) %>%
	summarise(HOME_ID = get_home_or_work_loc_by_label(CELL_ID, PLACE, "Home"),
	      WORK_ID = get_home_or_work_loc_by_label(CELL_ID, PLACE, "Work")) %>%
	return()
}


show_home_by_label <- function(data, towers, k_options) {
    # Shows the type of home_id based on user-defined constant.
    #
    # Args:
    #   data: The cdr.
    #   towers: The tower data.
    #   k_options: The data frame containing a set of user-defined
    #              constants.
    #
    # Returns:
    #   The filtered cdr with the home shown for each ANUMBER. 

    label <- k_options$k_home_type[1]
       
    # if home_type is tower
    if (label == 1) { 	
	probable_place <- group_by(data, ANUMBER, START_DATE_TIME, CELL_ID) %>% 
	    summarise(PLACE = home_or_work(START_DATE_TIME, k_options)) %>%
	    group_by(ANUMBER) %>%
	    summarise(HOME_ID = get_home_or_work_loc_by_label(CELL_ID, PLACE, "Home")) %>%
	    return()
    }

    # home_type is city
    else if (label == 2) { 	
	print("data is:")
	print(head(data))
	probable_place <- group_by(data, ANUMBER, START_DATE_TIME, CITY) %>% 
	    summarise(PLACE = home_or_work(START_DATE_TIME, k_options)) %>%
	    group_by(ANUMBER) %>%
	    summarise(HOME_ID = get_home_or_work_loc_by_label(CITY, PLACE, "Home")) %>%
	    return()
    }

    # home_type is state
    else if (label == 3) { 	
	probable_place <- group_by(data, ANUMBER, START_DATE_TIME, STATE) %>% 
	    summarise(PLACE = home_or_work(START_DATE_TIME, k_options)) %>%
	    group_by(ANUMBER) %>%
	    summarise(HOME_ID = get_home_or_work_loc_by_label(STATE, PLACE, "Home")) %>%
	    return()
    }
}

find_and_remove_records_with_no_home_work_pair <- function(data, towers, k_options) {
    # Removes all records that do not have home/work pairs.
    #
    # Args:
    #   data: The cdr.
    #   towers: The tower data.
    #   k_options: k_options: The data frame containing a set of user-defined
    #              constants.
    #
    # Returns:
    #   The filtered cdr containing only records that have home/work pairs.

  
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


# TODO: Split functions such that, in main(), show_home_and_work_towers() 
#       passes its return value into remove_records_with_no_home() 
find_and_remove_records_with_no_home <- function(data, towers, k_options) {
    # Removes all records that do not have home_ids.
    #
    # Args:
    #   See above.
    #
    # Returns:
    #   The filtered cdr containing only records that have homes.
    
    print("Removing records with no home...")
    orig_num <- nrow(data) # get orig num records

    #redefine cdr showing only recs with homes
    filt_cdr <- show_home_by_label(data, towers, k_options) %>%
	filter(!is.na(HOME_ID) & (HOME_ID != "NOT APPLICABLE") &
	       (HOME_ID != "TO BE DETERMINED" &
		(HOME_ID != "NIVEL DEPARTAMENTAL")))
  
    # get new num records after removing records w/o home 
    new_num <- nrow(filt_cdr)

    print(paste("raw data: ", orig_num, " record(s)", sep = ""))
    print(paste("num records with homes: ", new_num, " record(s)", sep = ""))
    print(paste("percentage removed", 100 - (orig_num / new_num)))
  
  return(filt_cdr)
}


get_data <- function(PATHS) {
    # Load all data into a vector of data frames.
    #
    # Args:
    #   PATHS: The vector of paths containing user-defined file paths.
    # 
    # Returns:
    #   A list of three data frames (cdr, towers, and elec_data). 

    cdr_raw <- read.csv(PATHS[1]) # import call detail records
    print("Loaded raw data")
    towers <- read.csv(PATHS[2]) # import tower locations
    print("Loaded tower data")
    cdr <- merge(cdr_raw, towers, by="CELL_ID") # merge data into one table
    print("Merged tower and cell data")
    elec_data <- read.csv(PATHS[3]) # import 2015 secondary election data  
    print("Loaded election data")
  
    # make a list of three data frames (cdr, towers, elec_data)
    df.cdr <- data.frame(cdr) 
    df.towers <- data.frame(towers) 
    df.elec_data <- data.frame(elec_data)
    return(list("cdr" = df.cdr, "towers" = df.towers, "elec_data" = df.elec_data))
}


# init file paths
init_paths <- function() {
  CDR_DATA <- "/Users/tedhadges/Projects/guatemala/raw_data/Filtered_Sample.csv"
  TOWER_DATA <- "/Users/tedhadges/Projects/guatemala/raw_data/tower_data.csv"
  ELECTION_DATA <- "../../mapping/data/elecData2015.csv"
  PATHS <- c(CDR_DATA, TOWER_DATA, ELECTION_DATA)
  
  return(PATHS)
}


set_options<- function() {
    # Creates a data frame of user-defined constants to be used in other
    # functions. Manually set all params here.
 
    k_work_start_time <- 8 # set work start time here
    k_work_end_time <- 18 # set work end time here 
  
    # use k_home_id_type to define how to classify home_id
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
    source("timeParser.r")
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

# dframe is a two-column dframe with ANUMBER HOME_ID
# Returns a data frame whose columns are "HOME_ID" and "n", where n is the
# number of callers who have that home_id.
group_by_home_loc <- function(dframe) {
    groupedFrame <- group_by(dframe, HOME_ID) %>%
	tally() %>%
	return()
}


# IN PROGRESS
#plot_by_home_id <- function(dframe) {
    #plot(x, axes = FALSE,
    #axis(side = 1, at = c(1,5,10))
    #axis(side = 2, at = c(1,3,7,10))
    #main="Number of Callers by Home Location",
    #xlab="Home IDs",
    #ylab="Number of Callers",
    #type="b",
    #col="blue")
    #lines(x,col="red")
    #fill=c("blue")
#}

main_commute <- function() {
  load_packs() # install (if necessary) and load packages
  PATHS <- init_paths() # init file paths
  k_options <- set_options() # dframe with all params/options

  data_list <- get_data(PATHS)
  cdr <- data_list$cdr
  towers <- data_list$towers

  #fcdr <- removeRecordsWithNoHomeWorkPair(cdr, towers, threshs)
  
  fcdr <- find_and_remove_records_with_no_home(cdr, towers, k_options)
  
  #fcdr_dist <- get_distance(fcdr, towers)
  cdr_for_plotting<- group_by_home_loc(fcdr)
  
  return(cdr_for_plotting)
}
