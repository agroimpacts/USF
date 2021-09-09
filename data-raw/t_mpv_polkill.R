## code to prepare `t_mpv_polkill` dataset goes here

data(mpv_polkill)

# rename columns
names(mpv_polkill)[7] <- "address" # former "Street Address of Incident"

# filter by State
t_mpv_polkill <- mpv_polkill %>%
  filter(State == "MD"| State == "IL" | State == "NY" | State == "CA" |
           State == "MI" | State == "MO")

# write xlsx doc to Geocode in Arc
# library(writexl)
# write_xlsx(t_mpv_polkill, "~/Clark/RA-ing/SummerInstitute/USF/inst/data/t_mpv_polkill.xlsx")

###### Attempt at geocoding in Rstudio
# it only works with exact addresses, not intersections
# source: https://towardsdatascience.com/geocoding-tableau-and-r-integration-c5b32dc0eda6
# Packages
# library(sf)
# library(tmap)
# library(tmaptools)
# library(dplyr)
#
# addr <- t_mpv_polkill$address
# addr <-addr[!is.na(addr)]
#
# geocoded_addressess <- geocode_OSM(addr)


# read Geocoded dbf(now csv) file
setwd("~/Clark/RA-ing/SummerInstitute/GIS")
library(readxl)
t_mpv_polkill <-
  read_excel("t_mpv_polkill_geocoded_edited.xlsx")

# clean up
library(dplyr)
colnames(t_mpv_polkill) <- sub("USER\\_", "", colnames(t_mpv_polkill))
t_mpv_polkill <- t_mpv_polkill[-1]

# set as spatial feature
t_mpv_polkill$Latitude[is.na(t_mpv_polkill$Latitude)] <- 0
t_mpv_polkill$Longitude[is.na(t_mpv_polkill$Longitude)] <- 0
t_mpv_polkill <- st_as_sf(t_mpv_polkill, coords = c("Longitude", "Latitude"),
                          crs = 4269)

usethis::use_data(t_mpv_polkill, overwrite = TRUE)
