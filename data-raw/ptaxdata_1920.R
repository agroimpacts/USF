## code to prepare `ptaxdata_1920` dataset goes here
ptaxdata_1920 <- read_excel(
  here("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/assessors/2020.7.10_SF_ASR_Secured_Roll_Data_2019-2020.xlsx"),
  sheet = "Roll Data 2019-2020") %>% .[-c(1, 3:18)]

ptaxdata_1920[1] <-ptaxdata_1920[1] %>%
  mutate(across(where(is.character), str_remove_all, pattern = fixed(" ")))
usethis::use_data(ptaxdata_1920, overwrite = TRUE)
