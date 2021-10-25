## code to prepare `pgll` dataset goes here
library(here)
library(sp)

pgll <- st_read("~/Clark/RA-ing/SummerInstitute/r_data_raw/USF/inst/data/detroit/pgll.shp")
usethis::use_data(pgll, overwrite = TRUE)
