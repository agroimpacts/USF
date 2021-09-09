## code to prepare `more_arrests` dataset goes here
library(sf)

arrests <- st_read("inst/data/baltimore/arrests.shp")

more_arrests <- arrests %>% st_as_sf()
usethis::use_data(more_arrests, overwrite = TRUE)
