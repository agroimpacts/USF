## code to prepare `t_wpdata` dataset goes here
## t_wpdata includes all points within states, it has not been filtered by city

library(tidyverse)
library(sp)
library(sf)
library(rgdal)
library(USF)
data(wpdata)
t_wpdata <- wpdata %>% filter(state == "MD"| state == "IL" | state == "NY" |
                                state == "CA" | state == "MI" | state == "MO")

# drop is_geocoding_exact column
t_wpdata <-t_wpdata[-17]

# remove outlier
t_wpdata <- t_wpdata %>% filter(!id == "6382")

# set as spatial feature
t_wpdata$latitude[is.na(t_wpdata$latitude)] <- 0
t_wpdata$longitude[is.na(t_wpdata$longitude)] <- 0
t_wpdata <- st_as_sf(t_wpdata, coords = c("longitude", "latitude"), crs = 4269)

usethis::use_data(t_wpdata, overwrite = TRUE)
