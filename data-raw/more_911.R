## code to prepare `more_911` dataset goes here

calls2020 <- read.csv("~/Clark/RA-ing/SummerInstitute/GIS/baltimore/911_Calls_For_Service_2020.csv")
calls2019 <- read.csv("~/Clark/RA-ing/SummerInstitute/GIS/baltimore/911_Calls_For_Service_2019.csv")
calls2018 <- read.csv("~/Clark/RA-ing/SummerInstitute/GIS/baltimore/911_Calls_For_Service_2018.csv")
calls2017 <- read.csv("~/Clark/RA-ing/SummerInstitute/GIS/baltimore/911_Calls_For_Service_2017.csv")

more_911 <- rbind(calls2020, calls2019, calls2018, calls2017)

usethis::use_data(more_911, overwrite = TRUE)
