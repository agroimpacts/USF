## code to prepare `more_neighbhd` dataset goes here
more_neighbhd <- st_read("inst/data/baltimore/Neighborhoods.shp")
usethis::use_data(more_neighbhd, overwrite = TRUE)
