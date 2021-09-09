## code to prepare `chgo_zoning` dataset goes here
chgo_zoning <- st_read("inst/data/chicago/zoning.shp")
usethis::use_data(chgo_zoning, overwrite = TRUE)
