## code to prepare `ptaxdata_1314` dataset goes here
excel_sheets(here("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/assessors/2019.8.20__SF_ASR_Secured_Roll_Data_2013-2014.xlsx"))

ptaxdata_1314 <- read_excel(
  here("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/assessors/2019.8.20__SF_ASR_Secured_Roll_Data_2013-2014.xlsx"),
  sheet = "Roll Data 2013-2014") %>% .[-c(1, 2, 4:18)]

ptaxdata_1314[1] <-ptaxdata_1314[1] %>%
  mutate(across(where(is.character), str_remove_all, pattern = fixed(" ")))
usethis::use_data(ptaxdata_1314, overwrite = TRUE)
