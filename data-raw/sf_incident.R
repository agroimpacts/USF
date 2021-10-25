## code to prepare `sf_incident` dataset goes here
library(here)
library(sp)
sf_incident <- st_read(here("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/Police Department Incident Reports_ 2018 to Present/geo_export_4f55bd45-1b85-4d17-955a-73a401af9732.shp"))
usethis::use_data(sf_incident, overwrite = TRUE)
