## code to prepare `nycha` dataset goes here
library(geojsonsf)

nycha <- geojson_sf("C://CLARK//GEOSPAAR//floodlightblm//data//nycha.geojson")

usethis::use_data(nycha, overwrite = TRUE)
