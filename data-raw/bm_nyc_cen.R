## code to prepare `bm_nyc_cen` dataset goes here
#NYC data - Nighttime Lights (2012-2022 -end 2021)
library(raster)
library(here)
bm_nyc_cen <- raster("~/Clark/RA-ing/SummerInstitute/nightlight/data/bm_nyc_cen.grd")
usethis::use_data(bm_nyc_cen, overwrite = TRUE)
