## code to prepare `parceldata` dataset goes here

setwd("~/Clark/RA-ing/SummerInstitute/GIS/chicago")

parceldata <- read.csv("Archive_-_Cook_County_Assessor_s_Residential_Assessments.csv")

usethis::use_data(parceldata, overwrite = TRUE)
