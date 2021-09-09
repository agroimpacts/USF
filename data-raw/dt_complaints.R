## code to prepare `dt_complaints` dataset goes here

dt_complaints <- read.csv("~/Clark/RA-ing/SummerInstitute/GIS/detroit/DPD_Citizen_Complaints.csv")

usethis::use_data(dt_complaints, overwrite = TRUE)
