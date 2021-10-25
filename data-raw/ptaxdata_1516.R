## code to prepare `ptaxdata_1516` dataset goes here
excel_sheets(here("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/assessors/2020.7.10_SF_ASR_Secured_Roll_Data_2015-2016.xlsx"))

ptaxdata_1516 <- read_excel(
  here("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/assessors/2020.7.10_SF_ASR_Secured_Roll_Data_2015-2016.xlsx"),
  sheet = "Roll Data 2015-2016") %>% .[-c(1, 2, 4:18)]

ptaxdata_1516[1] <-ptaxdata_1516[1] %>%
  mutate(across(where(is.character), str_remove_all, pattern = fixed(" ")))
usethis::use_data(ptaxdata_1516, overwrite = TRUE)
