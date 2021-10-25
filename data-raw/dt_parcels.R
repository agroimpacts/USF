## code to prepare `dt_parcels` dataset goes here
library(here)
library(sp)

dt_parcels <- st_read(here("~/Clark/RA-ing/SummerInstitute/r_data_raw/USF/inst/data/detroit/Parcels.shp"))
usethis::use_data(dt_parcels, overwrite = TRUE)
