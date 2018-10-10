library(data.table)

recodings <- 
  c(mobilePay = 'Q72.11.3',
    intPay    = 'Q72.11.4',
    tvPay     = 'Q72.11.5',
    ethnicity = 'Q60',
    lifeImproved  = 'Q64',
    tvInHome      = 'Q72.9',
    mobileInHome  = 'Q72.6',
    mobilePersonal= 'Q86',
    newsCntry     = 'JG2',
    newsMuni      = 'JG3',
    whyNoIntCntry = 'JG4',
    whyNoIntMuni  = 'JG5',
    intImprove    = 'JG6',
    bedrooms      = 'Q70.1.1',
    membersHousehold   = 'hhsize',
    educLevel          = 'xxreduc',
    incomeHousehold    = 'xxhhinc'
  )
          
recode <- function(data) {
  old_names = recodings
  new_names = names(mapply(function(name) {deparse(substitute(name))}, recodings))
  setnames(data, old=old_names, new=new_names)
  
}
