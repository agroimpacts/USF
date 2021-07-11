## code to prepare `complaint_cot` dataset goes here
library(readr)
setwd("~/Clark/RA-ing/SummerInstitute/cityoftacoma")
complaint_cot <- read.csv("Complaint_Allegations_with_Findings.csv")
usethis::use_data(complaint_cot, overwrite = TRUE)
