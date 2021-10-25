## code to prepare `sf_fedgrants` dataset goes here
library(here)
sf_fedgrants <- read.csv(here("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/sf_fedgrants.csv"))

names(sf_fedgrants)[1] <- "Amount"
usethis::use_data(sf_fedgrants, overwrite = TRUE)
