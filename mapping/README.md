Goal: 
Write scripts to create a matrix of community relations, where columns/rows are labeled by city. As a starting point, the value in each element should represent the number of calls between people from those cities.



### Notes for reading the csv's in R interactive mode (console):

// row.names = 1 means use first column as row names
jvpMat <- read.csv("jvpmatrix.csv", row.names = 1)
binMat <- read.csv("binarymatrix.csv", row.names = 1)

### To change all NA vals to 0s (useful for plotting):
binMat[is.na(binMat)] <- 0


### To make paired list from matrix:
library(reshape)
jvpList <- as.matrix(jvpList)
melt(jvpList)

same with binList, then:
jvpList <- cbind(jvpList, binList[3])
to add column


plot(comm, jvp)
abline(lm(jvp~comm), col="red") # regression line (y~x)
