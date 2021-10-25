## code to prepare `ptaxdata_1415` dataset goes here
excel_sheets(here("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/assessors/2019.8.20__SF_ASR_Secured_Roll_Data_2014-2015.xlsx"))

ptaxdata_1415 <- read_excel(
  here("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/assessors/2019.8.20__SF_ASR_Secured_Roll_Data_2014-2015.xlsx"),
  sheet = "2014-2015") %>% .[-c(1, 2, 4:23)]

ptaxdata_1415[1] <-ptaxdata_1415[1] %>%
  mutate(across(where(is.character), str_remove_all, pattern = fixed(" ")))
usethis::use_data(ptaxdata_1415, overwrite = TRUE)
