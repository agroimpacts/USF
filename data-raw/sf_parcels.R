## code to prepare `sf_parcels` dataset goes here
library(here)
library(sp)
sf_parcels <- st_read("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/Parcels/Parcels/sanfranparcel.shp")
names(sf_parcels)[1] <- "RP1PRCLID"

usethis::use_data(sf_parcels, overwrite = TRUE)
