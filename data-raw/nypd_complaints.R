## code to prepare `nypd_complaints` dataset goes here


nypd_complaints <- read.csv("inst/data/new_york/NYPD_Complaint.csv")


# Convert to Spatial Feature

nypd_complaints$Latitude[is.na(nypd_complaints$Latitude)] <- 0
nypd_complaints$Longitude[is.na(nypd_complaints$Longitude)] <- 0

nypd_complaints <- st_as_sf(nypd_complaints,
                         coords = c("Longitude", "Latitude"), crs = 4269)

usethis::use_data(nypd_complaints, overwrite = TRUE)
