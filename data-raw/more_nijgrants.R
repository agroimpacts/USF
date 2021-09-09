## code to prepare `more_nijgrants` dataset goes here
setwd("C:/Users/pilii/Documents/Clark/RA-ing/SummerInstitute/")
more_nijgrants <- read.csv("NIJ_Baltimore/more_nijgrants.csv")
usethis::use_data(more_nijgrants, overwrite = TRUE)
