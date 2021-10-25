## code to prepare `rmsdata` dataset goes here
library(here)
library(geospaar)
rmsdata <- st_read("~/Clark/RA-ing/SummerInstitute/USF/localdrive/rms_data.shp")

usethis::use_data(rmsdata, overwrite = TRUE)
