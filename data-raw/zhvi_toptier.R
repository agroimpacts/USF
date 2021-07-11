## code to prepare `zhvi_toptier` dataset goes here
library(readr)
setwd("~/Clark/RA-ing/SummerInstitute/Zillow")
zhvi_toptier <- read_csv("Metro_zhvi_uc_sfrcondo_tier_0.67_1.0_sm_sa_mon.csv")
usethis::use_data(zhvi_toptier, overwrite = TRUE)
