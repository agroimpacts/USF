## code to prepare `buildings` dataset goes here
#NYC data
library(tidyverse)
library(sf)
library(sp)
data(nytract) #pre-load from USf package
ny_crs <- st_crs(nytract)
buildings <- st_read("C://CLARK//GEOSPAAR//floodlightblm//data//buildings_p.shp") %>%
  st_transform(ny_crs)

usethis::use_data(buildings, overwrite = TRUE)
