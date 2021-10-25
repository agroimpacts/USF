## code to prepare `sf_pdbudget` dataset goes here
sf_pdbudget <- read.csv("~/Clark/RA-ing/SummerInstitute/budget/sf_policebudget.csv")
names(sf_pdbudget)[1] <- "City"
usethis::use_data(sf_pdbudget, overwrite = TRUE)
