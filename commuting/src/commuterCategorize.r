# sort by ANUMBER
# for each ANUMBER:
  # find which CELLID is closest at typical home time
  # find which CELLID is closest at typical away time

# import call detail records into cdr
cdrRaw <- read.csv("Projects/guatemala/raw_data/cdr.csv")
cdrRaw # print to check

# convert to data frame structure
require(data.table) 
cdr <- as.data.table(cdrRaw)



#rename the columns
names(cdr) <- c("startTime", "caller", "receiver", "seconds", "callFrom", "callTo", "network", "towerID") # name the columns
cdr # print the data to look at it 
#for each cdr[caller=="7IFFJJHOO"]


# drop unnecessary columns
cdr$callFrom <- NULL
cdr$callTo <- NULL
cdr$network <- NULL
cdr$receiver <- NULL
cdr$seconds <- NULL
cdr


# isolate caller
cdr

