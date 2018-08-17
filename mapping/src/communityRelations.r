
incrementMatrixElems <- function(validRecs, allHomeRecs, mat) {
    
    newMat <- mat

    # try this instead of for loop
   # newMat <- by(validRecs, seq_len(nrow(validRecs)), function(incMatEl) ifelse(is.na(currentElm)), 1, currentElm + 1)


    #lapply(unique(Raw$SPP), makePlot, data = Raw)


   for (i in 1:nrow(validRecs)) { 

       currentElm <- newMat[getHomeID(allHomeRecs, as.character(validRecs$ANUMBER[i])), getHomeID(allHomeRecs, as.character(validRecs$BNUMBER[i]))]

       if (is.na(currentElm))
	   newMat[getHomeID(allHomeRecs, as.character(validRecs$ANUMBER[i])), getHomeID(allHomeRecs, as.character(validRecs$BNUMBER[i]))] <-  1
       else
	   newMat[getHomeID(allHomeRecs, as.character(validRecs$ANUMBER[i])), getHomeID(allHomeRecs, as.character(validRecs$BNUMBER[i]))] <- newMat[getHomeID(allHomeRecs, as.character(validRecs$ANUMBER[i])), getHomeID(allHomeRecs, as.character(validRecs$BNUMBER[i]))] + 1
   }

   df <- as.data.frame(newMat)
   #df[apply(newMat,1,function(x)any(!is.na(x))),]
   print(class(df))

   # remove rows which are all NA 
   df <- df[!(rowSums(is.na(df))==NCOL(df)),] 

   # remove cols which are all NA 
   df <- df[, !(colSums(is.na(df))==NROW(df))] 


 
   #df[na.omit(df), ]


   #df <- df %>% drop_na(rnor, cfam)


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
    
    print("Printing filtered CDR of all BNUMBERS who appear as BNUMBERs in the above table but appear as ANUMBERs here. This means we have their HOME_ID")
    print(validBRecs)

    return(validBRecs)
}


# return a filtered cdr with all records for each anumber
# homeIDs is a dframe of unique ANUMBERS which have homes assigned
getAllHomeRecs <- function(homeIDs, cdr) {
    
    #fcdr <- group_by(homeIDs) %>% 
	#summarise(records = getAllRecsByANUMBER(homeIDs$ANUMBER, cdr))
    fcdr <- cdr %>%
	filter(grepl(paste(homeIDs$ANUMBER, collapse="|"), cdr$ANUMBER)) 
    print("Printing all outgoing call recs of ANUMBERs who have HOME_IDs")
    print(fcdr)
    
    return(fcdr)
}


getUniqueHome_IDs <- function(dframe) {
    
    uniqueHomes <- unique(dframe$HOME_ID)
    return(uniqueHomes)
}


# create an NxN labeled matrix where N is HOME_ID
createMatrix <- function(dframe) {
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

  print("Printing all ANUMBERS who have HOME_IDs")
  print(filt_cdr)
  
  return(filt_cdr)
}

loadSources <- function() {
    print("Loading sources")
    source("../../commuting/src/commuterCategorize.r")
    print("Success")
}



main <- function() {
    loadSources()
    loadPacks()
    threshs <- initThresholds() # init threshold vals
    dataList <- getData(initPaths())
    cdr <- dataList$cdr
    towers <- dataList$towers
    homeIDs <- getAllHomeIDs(cdr, towers, threshs) # records with home addresses
    allHomeRecs <- getAllHomeRecs(homeIDs, cdr) # CDR with all ANUMS who have homes
    validBRecs<- filterByBinA(allHomeRecs) # return a dframe where all BNUMBERS also present as ANUMBER
    validRecs <- getRecsWithKnownHomes(validBRecs, allHomeRecs)

    #useThisForMatrix <- getAllHomeIDs(validRecs, towers, threshs)
    
    print("Printing final CDR of all valid numbers")
    print(validRecs)

    print("Printing homeIDs. originally used to make matrix")
    print(homeIDs)

    print("printing useThisForMatrix. Try to use this instead for matrix")
    #print(useThisForMatrix)
       
    mat <- createMatrix(homeIDs) # create matrix using HOME_ID 
    
    incMat <- incrementMatrixElems(validRecs, homeIDs, mat)

    #print(incMat)
    write.table(incMat, file="mymatrix.txt", row.names=TRUE, col.names=TRUE, sep =",") 

    
}

