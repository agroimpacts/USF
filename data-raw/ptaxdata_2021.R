## code to prepare `ptaxdata_2021` dataset goes here
ptaxdata_2021 <- read_excel(
  here("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/assessors/2021.7.28_SF_ASR_Secured_Roll_Data_2020-2021.xlsx"),
  sheet = "Roll Data 2020-2021") %>% .[-c(1, 3:18)]

ptaxdata_2021[1] <-ptaxdata_2021[1] %>%
  mutate(across(where(is.character), str_remove_all, pattern = fixed(" ")))
usethis::use_data(ptaxdata_2021, overwrite = TRUE)
