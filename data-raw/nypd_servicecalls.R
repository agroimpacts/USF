## code to prepare `nypd_servicecalls` dataset goes here

nypd_servicecalls <- read.csv("inst/data/new_york/NYPD_CallsService.csv")

# Convert to Spatial Feature

nypd_servicecalls$Latitude[is.na(nypd_servicecalls$Latitude)] <- 0
nypd_servicecalls$Longitude[is.na(nypd_servicecalls$Longitude)] <- 0

nypd_servicecalls <- st_as_sf(nypd_servicecalls,
                            coords = c("Longitude", "Latitude"), crs = 4269)

usethis::use_data(nypd_servicecalls, overwrite = TRUE)
