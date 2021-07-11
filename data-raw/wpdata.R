## code to prepare `wpdata` dataset goes here
library(readr)
setwd("~/Clark/RA-ing/SummerInstitute/data-police-shootings")
wpdata <- read_csv("fatal-police-shootings-data.csv")
usethis::use_data(wpdata, overwrite = TRUE)

