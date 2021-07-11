## code to prepare `dd1033_CA` dataset goes here
setwd("~/Clark/RA-ing/SummerInstitute/ACLUM-Public-Datasets")
excel_sheets("Department of Defense 1033 Program/DISP_AllStatesAndTerritories.xlsx")

dd1033_CA <- read_excel("Department of Defense 1033 Program/DISP_AllStatesAndTerritories.xlsx",
                          sheet = "California")
names(dd1033_CA)[7] <- "AcqVal"
usethis::use_data(dd1033_CA, overwrite = TRUE)
