## code to prepare `urban_dev` dataset goes here
setwd("~/Clark/RA-ing/SummerInstitute/GIS/kansas_city")

urban_dev <- read.csv("~/Clark/RA-ing/SummerInstitute/GIS/kansas_city/urban_redevelopment.csv")

urban_dev <- st_as_sf(urban_dev,
                      coords = c("Longitude", "Latitude"), crs = 4269)
usethis::use_data(urban_dev, overwrite = TRUE)
