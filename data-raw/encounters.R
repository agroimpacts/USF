## code to prepare `encounters` dataset goes here
library(readr)
setwd("~/Clark/RA-ing/SummerInstitute/fatal_encounters")
encounters <- read_csv("fe_data.csv")

usethis::use_data(encounters, overwrite = TRUE)

