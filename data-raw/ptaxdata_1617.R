## code to prepare `ptaxdata_1617` dataset goes here
excel_sheets(here("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/assessors/2019.8.12__SF_ASR_Secured_Roll_Data_2016-2017_0.xlsx"))

ptaxdata_1617 <- read_excel(
  here("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/assessors/2019.8.12__SF_ASR_Secured_Roll_Data_2016-2017_0.xlsx"),
  sheet = "Roll Data 2016-2017") %>% .[-c(1, 2, 4:18)]

ptaxdata_1617[1] <-ptaxdata_1617[1] %>%
  mutate(across(where(is.character), str_remove_all, pattern = fixed(" ")))
usethis::use_data(ptaxdata_1617, overwrite = TRUE)
