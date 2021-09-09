## code to prepare `p1crime` dataset goes here
library(sf)
p1crime <- st_read("~/Clark/RA-ing/SummerInstitute/GIS/baltimore/Part1_Crime_data/Part1_crime_data.shp")
p1crime$Latitude[is.na(p1crime$Latitude)] <- 0
p1crime$Longitude[is.na(p1crime$Longitude)] <- 0

usethis::use_data(p1crime, overwrite = TRUE)
