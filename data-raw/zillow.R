## code to prepare `zillow` dataset goes here
library(readr)
setwd("~/Clark/RA-ing/SummerInstitute/Zillow")
zillow <- read_csv("Metro_zhvi_uc_sfrcondo_tier_0.67_1.0_sm_sa_mon.csv")
usethis::use_data(zillow, overwrite = TRUE)
