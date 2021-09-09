## code to prepare `crimemap` dataset goes here
setwd("~/Clark/RA-ing/SummerInstitute/GIS/chicago")

crimemap <- read.csv("Crimes_-_Map.csv")

usethis::use_data(crimemap, overwrite = TRUE)
