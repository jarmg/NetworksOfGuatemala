library(data.table)

recodings <- 
  c(PAY_CELL  = 'Q72.11.3',
    PAY_INT   = 'Q72.11.4',
    PAY_TV    = 'Q72.11.5',
    ETHNICITY = 'Q60',
    LIFE_IMPRVD = 'Q64',
    TV_IN_HOME   = 'Q72.9',
    CELL_IN_HOME = 'Q72.6',
    OWN_CELL     = 'Q86',
    NEWS_CTY  = 'JG2',
    NEWS_MUNI = 'JG3',
    WHY_NOT_INT_CTY  = 'JG4',
    WHY_NOT_INT_MUNI = 'JG5',
    BETTER_INT = 'JG6',
    NUM_BEDROOMS = 'Q70.1.1',
    NUM_HOUSEHOLD_MEMS = 'hhsize',
    EDUC_LEVEL = 'xxreduc',
    HOUSEHOLD_INCOME = 'xxhhinc'
  )
          
recode <- function(data) {
  old_names = recodings
  new_names = names(mapply(function(name) {deparse(substitute(name))}, recodings))
  setnames(data, old=old_names, new=new_names)
  
}
