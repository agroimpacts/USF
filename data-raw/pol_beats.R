## code to prepare `pol_beats` dataset goes here
pol_beats <- st_read("inst/data/chicago/pol_beats.shp")
usethis::use_data(pol_beats, overwrite = TRUE)
