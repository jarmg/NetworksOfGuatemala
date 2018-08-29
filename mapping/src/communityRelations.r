#getDistanceByMunis <- function(muni1, muni2, map) {

#cacheDistances <- function(

read_mat_csv <- function(option) {
    # Reads a csv file and returns a matrix as a data frame.
    #
    # Args:
    #   option: Use '1' to read joint voting matrix.
    #           Use '2' to read commuting matrix.
    #
    # Returns:
    #   The matrix as a data frame.
    if (option == 1)
	mat <- read.csv("jvp_mat.csv", row.names = 1)
    else if (option == 2)
	mat <- read.csv("comm_mat.csv", row.names = 1)
    else
	stop("Must specify an option.\n1: joint voting patterns\n
	     2: communication patterns")
    
    return(mat)
}

make_paired_list_from_matrix <- function(mat) {
    # Converts matrix elements to a list of pairs.
    #
    # Args:
    #   mat: The matrix to be converted.
    # 
    # Returns:
    #   The paired list of values.
    
    # make the paired list
    mat_as_paired_list <- as.matrix(mat) # make sure not dframe

    # mat row/col pairs to row/row pairs
    mat_as_paired_list <- melt(mat_as_paired_list)
    
    return(mat_as_paired_list)
}

append_comm_vals_to_jvp_list <- function(jvp_list, comm_list) {
    # Appends commuting data column to joint voting pattern list.
    #
    # Args:
    #   jvp_list: The joint voting pattern list.
    #   comm_list: The commuting list.
    # 
    # Returns:
    #   The merged list containing both jvp and comm data.

    jvp_list <- cbind(jvp_list, comm_list[3])
    return(jvp_list)
}

plot_reg_line <- function(jvp_list) {
    # Generates a scatter plot with a linear regression line.
    #
    # Args:
    #   jvp_list: The list containing muni pairs and their
    #             corresponding jvp and comm data
    #
    # Returns:
    #   Returns NULL. 
    
    comm <- jvp_list[, 4] # comm vec
    jvp <- jvp_list[, 3] # voting vec

    plot(comm, jvp)
    abline(lm(jvp~comm), col = "red")  # regression line (y~x)
    return(NULL)
}

get_stats_by_home_id <- function(home_id, elec_data, k_options) {
    # Filters election data based on user defined home classification
    
    
    # if home is tower
    if (k_options$k_home_type == 1) { 	
	stop("This function is not yet defined for tower to tower communitiy mapping")
    }

    # if home is municipality
    else if (k_options$k_home_type == 2) {
	stats <- filter(elec_data, MUNI == homeID & MUNI != "NIVEL DEPARTAMENTAL")
	return(stats)
    }

    # if home is department
    else if (k_options$k_home_type == 3) {
		stats <- filter(elec_data, DEPT == home_id & MUNI == "NIVEL DEPARTAMENTAL")
    return(stats)
    }
}

get_stats_by_muni <- function(muni, elec_data) {
    stats <- filter(elec_data, MUNI == muni)
    return(stats)
}

write_similarity_vals <- function(jvp_mat, elec_data, k_options) {

    # V = 100 - |(A_1 - A_2|

    for (i in 1:nrow(jvp_mat)) {
	row_name <- rownames(jvp_mat)[i]
	for (j in 1:ncol(jvp_mat)) {

	    col_name <- colnames(jvp_mat)[j]

	    print("current pair is")
	    print(paste(row_name, col_name, sep = ","))

	    muni1 <- get_stats_by_muni(row_name, elec_data)
	    muni1_perc_une <- muni1$PERC_UNE[1]

	    muni2 <- get_stats_by_muni(col_name, elec_data)
	    muni2_perc_une <- muni2$PERC_UNE[1]

	    val <- (100 - abs(muni1_perc_une - muni2_perc_une))

	    jvp_mat[i,j] <- val
	    val <- 0  # can maybe delete this
	}
    }
    return(jvp_mat)
}


similarity_check <- function(elec_data, valid_recs,
			     all_home_recs, bin_mat, k_options) {

    for (i in 1:nrow(bin_mat)) {
	for (j in 1:ncol(bin_mat)) {

	    row_name <- rownames(bin_mat[i])
	    col_name <- colnames(bin_mat[j])
	    current_elm <- bin_mat[i,j]
	    	    
	    if (!is.na(current_elm) & !is.null(current_elm)) {
		bin_mat[i,j] <- get_similarity_val(row_name, col_name, elec_data, k_options)
	    }
	}
    }
    #df <- as.data.frame(new_mat)

    return(dframe)
}

# in progress. not yet used
# set a filter here for determining whether two communities are related
is_related <- function(comm1, comm2, mat) {

    if (!is.na(mat[comm1, comm2]))
	return(TRUE)
    else
	return(FALSE)
}

increment_matrix_elems <- function(valid_recs, all_home_recs, mat, k_options) {
    new_mat <- mat
      
    for (i in 1:nrow(valid_recs)) {
       current_elm <- new_mat[get_home_id(k_options$k_home_type,
					  all_home_recs,
					  as.character(valid_recs$ANUMBER[i])),
	                                  get_home_id(k_options$k_home_type,
			                  all_home_recs, 
			                  as.character(valid_recs$BNUMBER[i]))]

       if (is.na(current_elm))
	   new_mat[get_home_id(k_options$k_home_type,
			       all_home_recs,
			       as.character(valid_recs$ANUMBER[i])),
	                       get_home_id(k_options$k_home_type,
			       all_home_recs,
			       as.character(valid_recs$BNUMBER[i]))] <- 1
       else
	   new_mat[get_home_id(k_options$k_home_type,
			       all_home_recs,
			       as.character(valid_recs$ANUMBER[i])),
	                       get_home_id(k_options$k_home_type,
			       all_home_recs,
			       as.character(valid_recs$BNUMBER[i]))] <- 
			       new_mat[get_home_id(k_options$k_home_type, 
                               all_home_recs,
			       as.character(valid_recs$ANUMBER[i])),
	                       get_home_id(k_options$k_home_type,
			       all_home_recs, 
			       as.character(valid_recs$BNUMBER[i]))] + 1
   }

   df <- as.data.frame(new_mat)

   return(df)
}

# remove cols which are all NA 
remove_cols_with_all_nas <- function(df) {
   return(df[, !(colSums(is.na(df)) == NROW(df))])
}

# remove rows which are all NA 
remove_rows_with_all_nas <- function(df) {
   return(df[!(rowSums(is.na(df)) == NCOL(df)), ])
}

get_recs_with_known_homes <- function(valid_bnum_recs, all_anum_recs) {
    valid_recs <- all_anum_recs %>%
	filter(grepl(paste(valid_bnum_recs$ANUMBER, collapse = "|"),
		     all_anum_recs$BNUMBER))

    return(valid_recs)
}

# return a dframe where all BNUMBERS are present as ANUMBERs in the CDR
filter_by_bnum_in_a <- function(home_recs) {

    valid_bnum_recs <- home_recs %>%
	filter(grepl(paste(home_recs$BNUMBER, collapse="|"),
		     home_recs$ANUMBER))

    return(valid_bnum_recs)
}

# return a filtered cdr with all records for each anumber
# homeIDs is a dframe of unique ANUMBERS which have homes assigned
get_all_home_recs <- function(home_ids, cdr) {

    fcdr <- cdr %>%
	filter(grepl(paste(home_ids$ANUMBER, collapse = "|"), cdr$ANUMBER))

    return(fcdr)
}


get_unique_labels <- function(elec_data, k_options) {

    # home_id is tower
    if (k_options$k_home_type == 1) {
	stop("getUniqueMunis() not yet defined for this category")
    }

    # home_id is muni
    else if (k_options$k_home_type == 2) {
	unique_labels <- unique(elec_data$MUNI)
	return(unique_labels)
    }

    # if home_id is dept
    else if (k_options$k_home_type == 3) {
	unique_labels <- unique(elec_data$DEPT)
	return(unique_labels)
    }
}

create_jvp_matrix <- function(elec_data, k_options) {
    unique_labels <- get_unique_labels(elec_data, k_options)
    n <- length(unique_labels)

    jvp_mat <- matrix(, nrow = n, ncol = n)

    colnames(jvp_mat) <- unique_labels[1:ncol(jvp_mat)]
    rownames(jvp_mat) <- unique_labels[1:nrow(jvp_mat)]

    return(jvp_mat)
}

get_unique_home_ids <- function(dframe) {
    unique_homes <- unique(dframe$HOME_ID)
    return(unique_homes)
}

# create an NxN labeled matrix where N is HOME_ID
create_home_id_matrix <- function(dframe) {
    unique_homes <- get_unique_home_ids(dframe)
    n <- length(unique_homes)

    mat <- matrix(, nrow = n, ncol = n)

    colnames(mat) <- unique_homes[1:ncol(mat)]
    rownames(mat) <- unique_homes[1:nrow(mat)]

    return(mat)
}

# create a dframe of only records with home addresses
get_all_home_ids <- function(data, towers, threshs) {

  print("Removing records with no home/work pairs...")
  orig_num <- nrow(data)  # get orig_num records

  filt_cdr <- show_home_and_work_towers(data, towers, threshs) %>%
    filter(!is.na(HOME_ID) & (HOME_ID != ("TO BE DETERMINED")))
  filt_cdr$WORK_ID <- NULL

  # get new_num records after removing records w/o home and work locs
  new_num <- nrow(filt_cdr)

  print(paste("raw data: ", orig_num, " record(s)", sep = ""))
  print(paste("filtered data: ", new_num, " record(s)", sep = ""))
  print(paste("percentage removed", 100 - (orig_num / new_num)))

  return(filt_cdr)
}

load_sources <- function() {
    print("Loading sources")
    source("../../commuting/src/commuterCategorize.r")
    print("Success")
}

make_binary_matrix <- function(mat) {

    # change all values >= 1 to 1 to make binary
    mat[] <- + (mat >= 1)

    return(mat)
}


# reads raw data and generates csv files for comm and jvp
main_mapping <- function() {
    load_sources()
    load_packs()

    # init constant vals
    k_options <- set_options()
    data_list <- get_data(init_paths())

    cdr <- data_list$cdr
    towers <- data_list$towers
    elec_data <- data_list$elec_data
    print("elec_data is:")
    print(head(elec_data))

    orig_numm_recs <- nrow(cdr)

    home_ids <- remove_records_with_no_home(cdr, towers, k_options)

    # CDR with all ANUMS who have homes
    all_home_recs <- get_all_home_recs(home_ids, cdr)

    # return a dframe where all BNUMBERS also present as ANUMBER
    valid_bnum_recs <- filter_by_bnum_in_a(all_home_recs)
    valid_recs <- get_recs_with_known_homes(valid_bnum_recs, all_home_recs)
    num_valid_recs <- nrow(valid_recs)

    print(paste("Original number of records: ", orig_numm_recs))
    print(paste("Number of records for which there exist home_ids and an ANUMBER
		for every BNUMBER: ", num_valid_recs))
    print(paste("Percentage removed: ",
		100 - (num_valid_recs / orig_numm_recs)))

    jvp_mat <- create_jvp_matrix(elec_data, k_options)
print("jvp_mat is:")
print(jvp_mat)
    home_id_mat <- jvp_mat

    # increment matrix elems: +1 for each call between communities
    inc_mat <- increment_matrix_elems(valid_recs, home_ids, home_id_mat, k_options)
    binary_mat <- make_binary_matrix(inc_mat)

    # write vals into jvp_mat
    jvp_mat <- write_similarity_vals(jvp_mat, elec_data, k_options)

    # write jvp_mat to file
    #write.table(jvp_mat, file="jvpmatrix.csv", row.names=TRUE, col.names=NA,
    #sep =",")

    # write to csv file
    write.table(jvp_mat, file = "jvp_mat.csv",
		row.names = TRUE, col.names = NA, sep = ",")
    write.table(binary_mat, file = "comm.mat.csv",
		row.names = TRUE, col.names = NA, sep = ",")

    return(0)
}
