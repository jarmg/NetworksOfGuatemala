
getStatsByHomeID <- function(homeID, elecData, OPTIONS) {

    # if home is tower 
    if (OPTIONS$HOME_TYPE == 1) { 	
	stop("This function is not yet defined for tower to tower communitiy mapping")
    }

    # if home is municipality
    else if (OPTIONS$HOME_TYPE == 2) {     
	#print("Getting election stats by municipality")
	#print("elecData$MUNI is:")
	#select(elecData, MUNI) %>%
	    #filter(rownames, MUNI == "MIXCO") %>%
	
    
	#temp<-filter(elecData, MUNI == "Mixco")
	
	stats <- filter(elecData, MUNI == homeID)
	#stats <- elecData[elecData$MUNI == homeID, ]

	return(stats)
    }

    # if home is department 
    else if (OPTIONS$HOME_TYPE == 3) {
		stats <- filter(elecData, DEPT == homeID & MUNI == "Nivel Departamental")

    }

    return(stats)
}

getStatsByMuni <- function(muni, elecData) {
    stats <- filter(elecData, MUNI == muni)
    return(stats)
}

writeSimilarityVals <- function(jvp_mat, elecData, OPTIONS) {

    # V = 100 - |(A_1 - A_2|
       
    for (i in 1:nrow(jvp_mat)) {
	rowName <- rownames(jvp_mat)[i]
	for (j in 1:ncol(jvp_mat)) {

	    colName <- colnames(jvp_mat)[j]
	    currentElm <- jvp_mat[i,j]
	    
	    print("current pair is")
	    print(paste(rowName, colName, sep=","))

	    muni1 <- getStatsByMuni(rowName, elecData)
	    muni1_perc_UNE <- muni1$PERC_UNE[1]
	    
	    muni2 <- getStatsByMuni(colName, elecData)
	    muni2_perc_UNE <- muni2$PERC_UNE[1]

	    val <- (100 - abs(muni1_perc_UNE - muni2_perc_UNE))

	    jvp_mat[i,j] <- val 
	    val <- 0 # can maybe delete this
	}
    }
    return(jvp_mat)
}





similarityCheck <- function(elecData, validRecs, allHomeRecs, binMat, OPTIONS) {
   
    print("binMat is")
    print(binMat)

    for (i in 1:nrow(binMat)) {
	for (j in 1:ncol(binMat)) {

	    rowName <- rownames(binMat[i])
	    colName <- colnames(binMat[j])
	    currentElm <- binMat[i,j]
	    print("currentElm is")
	    print(currentElm)
	    
	    if (!is.na(currentElm) & !is.null(currentElm)) {
		binMat[i,j] <- getSimilarityVal(rowName, colName, elecData, OPTIONS)
	    }
	}
    }


    print("dframe is:")
    print(dframe)


   #df <- as.data.frame(newMat)

    return(dframe)
}


# in progress. not yet used
isRelated <- function(c1, c2, mat) {

    #if has >= 1
    # related

    if (!is.na(mat[c1,c2]))
	return(TRUE)
    else
	return(FALSE)
}




incrementMatrixElems <- function(validRecs, allHomeRecs, mat, OPTIONS) {
    
    newMat <- mat

    # try this instead of for loop
   # newMat <- by(validRecs, seq_len(nrow(validRecs)), function(incMatEl) ifelse(is.na(currentElm)), 1, currentElm + 1)


    #lapply(unique(Raw$SPP), makePlot, data = Raw)

   for (i in 1:nrow(validRecs)) { 
       
       currentElm <- newMat[getHomeID(OPTIONS$HOME_TYPE, allHomeRecs, as.character(validRecs$ANUMBER[i])), getHomeID(OPTIONS$HOME_TYPE, allHomeRecs, as.character(validRecs$BNUMBER[i]))]

       if (is.na(currentElm))
	   newMat[getHomeID(OPTIONS$HOME_TYPE, allHomeRecs, as.character(validRecs$ANUMBER[i])), getHomeID(OPTIONS$HOME_TYPE, allHomeRecs, as.character(validRecs$BNUMBER[i]))] <-  1
       else
	   newMat[getHomeID(OPTIONS$HOME_TYPE, allHomeRecs, as.character(validRecs$ANUMBER[i])), getHomeID(OPTIONS$HOME_TYPE, allHomeRecs, as.character(validRecs$BNUMBER[i]))] <- newMat[getHomeID(OPTIONS$HOME_TYPE, allHomeRecs, as.character(validRecs$ANUMBER[i])), getHomeID(OPTIONS$HOME_TYPE, allHomeRecs, as.character(validRecs$BNUMBER[i]))] + 1
   }

   df <- as.data.frame(newMat)
   #df[apply(newMat,1,function(x)any(!is.na(x))),]

   # remove rows which are all NA 
   df <- df[!(rowSums(is.na(df))==NCOL(df)),] 

   # remove cols which are all NA 
   df <- df[, !(colSums(is.na(df))==NROW(df))] 


    return(df)
}

getRecsWithKnownHomes <- function(validBRecs, allARecs) {

    validRecs <- allARecs %>%
	filter(grepl(paste(validBRecs$ANUMBER, collapse="|"), allARecs$BNUMBER)) 
    
    return(validRecs)
}


# return a dframe where all BNUMBERS are present as ANUMBERs in the CDR
filterByBinA <- function(homeRecs) {

    validBRecs <- homeRecs %>%
	filter(grepl(paste(homeRecs$BNUMBER, collapse="|"), homeRecs$ANUMBER)) 
    
    #print("Printing filtered CDR of all BNUMBERS who appear as BNUMBERs in the above table but appear as ANUMBERs here. This means we have their HOME_ID")
    #print(validBRecs)

    return(validBRecs)
}


# return a filtered cdr with all records for each anumber
# homeIDs is a dframe of unique ANUMBERS which have homes assigned
getAllHomeRecs <- function(homeIDs, cdr) {

    #fcdr <- group_by(homeIDs) %>% 
	#summarise(records = getAllRecsByANUMBER(homeIDs$ANUMBER, cdr))
    fcdr <- cdr %>%
	filter(grepl(paste(homeIDs$ANUMBER, collapse="|"), cdr$ANUMBER)) 
    #print("Printing all outgoing call recs of ANUMBERs who have HOME_IDs")
    #print(fcdr)
    
    return(fcdr)
}


getUniqueLabels <- function(elecData, OPTIONS) {
   
    if (OPTIONS$HOME_TYPE == 1) { # home_ID is tower
       stop("getUniqueMunis() not yet defined for this category")
    }
   
    else if (OPTIONS$HOME_TYPE == 2) { # home_ID is muni
	uniqueLabels <- unique(elecData$MUNI) # should already be unique.. redundant?
	return(uniqueLabels)
    }

    else if (OPTIONS$HOME_TYPE == 3) { # home_id is dept
	uniqueLabels <- unique(elecData$DEPT) # should already be unique.. redundant?
	return(uniqueLabels)
    }
}

create_JVP_matrix <- function(elecData, OPTIONS) {
    uniqueLabels <- getUniqueLabels(elecData, OPTIONS)
    n <- length(uniqueLabels)

    jvp_mat <- matrix(, nrow = n , ncol = n)
    
    colnames(jvp_mat) <- uniqueLabels[1:ncol(jvp_mat)]
    rownames(jvp_mat) <- uniqueLabels[1:nrow(jvp_mat)]

    return(jvp_mat)
}


getUniqueHome_IDs <- function(dframe) {
    
    uniqueHomes <- unique(dframe$HOME_ID)
    return(uniqueHomes)
}


# create an NxN labeled matrix where N is HOME_ID
createHomeIDMatrix <- function(dframe) {
    uniqueHomes <- getUniqueHome_IDs(dframe)
    n <- length(uniqueHomes)

    mat <- matrix(, nrow = n , ncol = n)
    
    colnames(mat) <- uniqueHomes[1:ncol(mat)]
    rownames(mat) <- uniqueHomes[1:nrow(mat)]

    return(mat)
}

# create a dframe of only records with home addresses
getAllHomeIDs <- function(data, towers, threshs) {
    
  print("Removing records with no home/work pairs...")
  origNum <- nrow(data) # get orig num records
  
  filt_cdr <- showHomeAndWorkTowers(data, towers, threshs) %>% 
    filter(!is.na(HOME_ID) & (HOME_ID!= ("TO BE DETERMINED"))) 
  filt_cdr$WORK_ID <- NULL

  newNum <- nrow(filt_cdr) # get new num records after removing records w/o home and work locs
  
  print(paste("raw data: ", origNum, " record(s)", sep=""))
  print(paste("filtered data: ", newNum, " record(s)", sep=""))
  print(paste("percentage removed", 100 - (origNum/newNum)))

  #print("Printing all ANUMBERS who have HOME_IDs")
  #print(filt_cdr)
  
  return(filt_cdr)
}

loadSources <- function() {
    print("Loading sources")
    source("../../commuting/src/commuterCategorize.r")
    print("Success")
}


makeBinaryMatrix <- function(mat) {

    # change all values >= 1 to 1 to make binary
    mat[] <- +(mat >= 1)

    return(mat)
}

mainMapping <- function() {
    loadSources()
    loadPacks()
    #threshs <- initThresholds() # init threshold vals
    OPTIONS <- setOptions()
    dataList <- getData(initPaths())

    cdr <- dataList$cdr
    towers <- dataList$towers
    elecData <- dataList$elecData

    print("elecData$MUNI is")
    print(elecData$MUNI)

    #print("elecData is: ")
    #print(elecData)
    #homeIDs <- getAllHomeIDs(cdr, towers, threshs) # records with home addresses

    origNumRecs <- nrow(cdr)

    homeIDs <- removeRecordsWithNoHome(cdr, towers, OPTIONS)
    
    #homeIDs <- mainCommute() # from commuterCategorize
    
    allHomeRecs <- getAllHomeRecs(homeIDs, cdr) # CDR with all ANUMS who have homes
    validBRecs<- filterByBinA(allHomeRecs) # return a dframe where all BNUMBERS also present as ANUMBER
    validRecs <- getRecsWithKnownHomes(validBRecs, allHomeRecs)
    numValidRecs <- nrow(validRecs)

    print(paste("Original number of records: ", origNumRecs))
    print(paste("Number of records for which there exist HOME_IDs and an ANUMBER for every BNUMBER: ", numValidRecs)) 
    print(paste("Percentage removed: ", 100 - (numValidRecs/origNumRecs)))

    home_ID_mat <- createHomeIDMatrix(homeIDs) # create matrix using HOME_ID 
    jvp_mat <- create_JVP_matrix(elecData, OPTIONS)
            
    # increment matrix elems: +1 for each call between communities 
    incMat <- incrementMatrixElems(validRecs, homeIDs, home_ID_mat, OPTIONS)
    communication_Mat <- makeBinaryMatrix(incMat)

    jvp_mat <- writeSimilarityVals(jvp_mat, elecData, OPTIONS) 


    write.table(jvp_mat, file="jvpmatrix.csv", row.names=TRUE, col.names=NA, sep =",") 


    #head(relationMatrix)
    # write to csv file
    #write.table(incMat, file="mymatrix.csv", row.names=TRUE, col.names=NA, sep =",") 
    return(jvp_mat)
}

