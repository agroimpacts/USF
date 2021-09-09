## code to prepare `more_parcels` dataset goes here
library(sf)

more_parcels <- st_read("inst/data/baltimore/Parcel.shp")
usethis::use_data(more_parcels, overwrite = TRUE)
