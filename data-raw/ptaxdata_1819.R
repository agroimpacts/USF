## code to prepare `ptaxdata_1819` dataset goes here
excel_sheets(here("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/assessors/2020.7.10_SF_ASR_Secured_Roll_Data_2018-2019.xlsx"))

ptaxdata_1819 <- read_excel(
  here("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/assessors/2020.7.10_SF_ASR_Secured_Roll_Data_2018-2019.xlsx"),
  sheet = "Roll Data 2018-2019") %>% .[-c(1, 3:18)]

ptaxdata_1819[1] <-ptaxdata_1819[1] %>%
  mutate(across(where(is.character), str_remove_all, pattern = fixed(" ")))

usethis::use_data(ptaxdata_1819, overwrite = TRUE)
