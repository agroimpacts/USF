## code to prepare `nytract` dataset goes here
library(sp)
library(sf)
library(here)

# source of nyctract:
# code to extract
# downloaded in a particular file (home)

nytract <- st_read("~/Clark/RA-ing/SummerInstitute/nightlight/data/nyct2020.shp")

usethis::use_data(nytract, overwrite = TRUE)
