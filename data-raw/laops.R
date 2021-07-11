## code to prepare `laops` dataset goes here
library(readr)
setwd("~/Clark/RA-ing/SummerInstitute/openpolincingstanford")
laops <- readRDS("~/Clark/RA-ing/SummerInstitute/openpolincingstanford/los_angeles_2020_04_01.rds")
usethis::use_data(laops, overwrite = TRUE)
