## code to prepare `dt_911` dataset goes here
dt_911 <- st_read("inst/data/detroit/911_calls.shp")
usethis::use_data(dt_911, overwrite = TRUE)
