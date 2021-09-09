## code to prepare `t_encounters` dataset goes here
data(encounters)

# change name of columns
names(encounters)[11] <- "city_death" # former "location of death (city)
names(encounters)[15] <- "address" # former "Full Address"
names(encounters)[16] <- "Latitude" # former "Latitude"
names(encounters)[17] <- "Longitude" # former "Longitude"

# filter by state
t_encounters <- encounters %>%
  filter(State == "MD"| State == "IL" | State == "NY" | State == "CA" |
           State == "MI" | State == "MO")


# Convert to Spatial Feature

t_encounters$Latitude[is.na(t_encounters$Latitude)] <- 0
t_encounters$Longitude[is.na(t_encounters$Longitude)] <- 0

t_encounters <- st_as_sf(t_encounters,
                            coords = c("Longitude", "Latitude"), crs = 4269)

usethis::use_data(t_encounters, overwrite = TRUE)
