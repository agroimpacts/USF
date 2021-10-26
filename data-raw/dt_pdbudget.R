## code to prepare `dt_pdbudget` dataset goes here
library(here)
dt_pdbudget <- read.csv(here("~/Clark/RA-ing/SummerInstitute/GIS/detroit/funding/budget.csv"))
names(dt_pdbudget)[1] <- "City"
usethis::use_data(dt_pdbudget, overwrite = TRUE)
