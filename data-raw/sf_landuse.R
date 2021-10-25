## code to prepare `sf_landuse` dataset goes here
library(here)
sf_landuse <- st_read(here("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/Land Use/geo_export_bfa75090-fc16-491b-939a-36adb7e3dbdf.shp"))
usethis::use_data(sf_landuse, overwrite = TRUE)
