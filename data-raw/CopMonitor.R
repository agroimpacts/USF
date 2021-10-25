## code to prepare `CopMonitor` dataset goes here
library(here)
CopMonitor <- read.csv(here("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/CopMonitor Public Records.csv"))
names(CopMonitor)[1] <- "Name"
usethis::use_data(CopMonitor, overwrite = TRUE)
