## code to prepare `nyc_complaints` dataset goes here

setwd("~/Clark/RA-ing/SummerInstitute/USF")
nyc_complaints <- read.csv("inst/data/new_york/NYCLU_Complaint.csv")

nyc_complaints <- nyc_complaints %>%
  separate(IncidentPrecinct, into = c("PCT", "Precinct"), sep = " ")
nyc_complaints <- nyc_complaints[-30]
nyc_complaints$Precinct <- str_remove(nyc_complaints$Precinct, "^0+")
nyc_complaints$Precinct <- as.numeric(nyc_complaints$Precinct)

usethis::use_data(nyc_complaints, overwrite = TRUE)
