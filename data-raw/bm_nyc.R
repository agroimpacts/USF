## code to prepare `bm_nyc` dataset goes here
#NYC Grid from Black Marble
library(raster)
library(here)
bm_nyc <- raster("~/Clark/RA-ing/SummerInstitute/nightlight/data/bm_nyc.grd")
usethis::use_data(bm_nyc, overwrite = TRUE)
