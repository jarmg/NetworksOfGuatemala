library(foreign)

GEM_FILE = "./gem_2018.sav"

read_data <- function(file_name) {
  return(read.spss(file_name))
}
