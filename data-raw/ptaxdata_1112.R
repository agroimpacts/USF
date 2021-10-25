## code to prepare `ptaxdata_1112` dataset goes here
excel_sheets(here("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/assessors/2019.11.5__SF_ASR_Secured_Roll_Data_2011-2012.xlsx"))

ptaxdata_1112 <- read_excel(
  here("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/assessors/2019.11.5__SF_ASR_Secured_Roll_Data_2011-2012.xlsx"),
  sheet = "Roll Data 2011-2012") %>% .[-c(1, 2, 4:18)]

ptaxdata_1112[1] <-ptaxdata_1112[1] %>%
  mutate(across(where(is.character), str_remove_all, pattern = fixed(" ")))
usethis::use_data(ptaxdata_1112, overwrite = TRUE)
