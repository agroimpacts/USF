## code to prepare `bm_nyc_cen` dataset goes here
#NYC data - Nighttime Lights (2012-2022 -end 2021)
library(raster)
bm_nyc_cen <- stack("C://CLARK//GEOSPAAR//floodlightblm//data//bm_nyc_cen.grd")
usethis::use_data(bm_nyc_cen, overwrite = TRUE)
