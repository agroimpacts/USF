## code to prepare `zhvi_bottomtier` dataset goes here
library(readr)
setwd("~/Clark/RA-ing/SummerInstitute/Zillow")
zhvi_bottomtier <- read_csv("Metro_zhvi_uc_sfrcondo_tier_0.0_0.33_sm_sa_mon.csv")
usethis::use_data(zhvi_bottomtier, overwrite = TRUE)
