## code to prepare `chicago_2020parcel` dataset goes here
#Source: https://hub-cookcountyil.opendata.arcgis.com/datasets/577d80fcbf0441a780ecdfd9e1b6b5c2_22/explore
library(sf)
setwd("~/Clark/RA-ing/SummerInstitute/GIS")
system(unzip(
    "~/test_case/chicago/Historical_Parcels-2020.zip",
    files = "Historical_Parcels_-_2020.shp",
    exdir = "chicago/Parcels"))
chicago_2020parcel <- st_read("~/chicago/Historical_Parcels_-_2020.shp")
usethis::use_data(chicago_2020parcel, overwrite = TRUE)
