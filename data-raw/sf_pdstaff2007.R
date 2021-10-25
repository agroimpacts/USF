## code to prepare `sf_pdstaff2007` dataset goes here
sf_pdstaff2007 <- read.csv("~/Clark/RA-ing/SummerInstitute/budget/sf_policestaffing2007.csv")
names(sf_pdstaff2007)[1] <- "PD.District"
usethis::use_data(sf_pdstaff2007, overwrite = TRUE)
