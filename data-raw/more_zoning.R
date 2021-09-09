## code to prepare `more_zoning` dataset goes here
more_zoning <- st_read("inst/data/baltimore/Zoning.shp")
usethis::use_data(more_zoning, overwrite = TRUE)
