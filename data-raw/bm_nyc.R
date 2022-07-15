## code to prepare `bm_nyc` dataset goes here
#NYC Grid from Black Marble
library(raster)
bm_nyc <- stack("C://CLARK//GEOSPAAR//floodlightblm//data//bm_nyc.grd")
usethis::use_data(bm_nyc, overwrite = TRUE)
