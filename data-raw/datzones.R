## code to prepare `datzones` dataset goes here
setwd("~/Clark/RA-ing/SummerInstitute/GIS/baltimore")
datzones <- st_read("dat_zones.shp")

usethis::use_data(datzones, overwrite = TRUE)
