## code to prepare `sf_pdistricts` dataset goes here
library(here)
sf_pdistricts <- st_read(here("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/Current Police Districts/geo_export_9bf54163-ba35-4dfa-953f-b7357987d6f9.shp"))
usethis::use_data(sf_pdistricts, overwrite = TRUE)
