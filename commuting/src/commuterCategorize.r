require(dplyr)

# returns true if date falls on either a Saturday or Sunday. returns false otherwise
# TODO:
# output day of week instead 
isWeekend <- function(x) {
  if (weekdays(as.Date(x)) == "Saturday" | (weekdays(as.Date(x)) == "Sunday"))
    return(TRUE)
  else
    return(FALSE)
}

# import call detail records into cdr
cdr <- read.csv("Projects/guatemala/raw_data/cdr.csv")
cdr # print to check



# group by cell tower (CELL_ID) and number of times 
group_by(cdr, CELL_ID) %>% summarise(num = n())

# group by caller (ANUMBER) and show the mean duration of call
group_by(cdr, ANUMBER) %>% summarise(meanNumSeconds = mean(SECONDS))

# group by caller (ANUMBER) and say if the call was made on a weekend
group_by(cdr, ANUMBER) %>% summarise(isWeekend = isWeekend(START_DATE_TIME))


group_by(cdr, ANUMBER) %>% summarise_if(isnumeric, mean, na.rm = TRUE)
#summarise_if(isWeekend(START_DATE_TIME), mean, na.rm = TRUE)





# group by caller (ANUMBER) and number of outgoing calls
group_by(cdr, ANUMBER) %>% summarise(num = n())


# class(weekdays(as.Date(cdr$START_DATE_TIME)))


#group_by(cdr, ANUMBER, START_DATE_TIME)  %>% summarise(

