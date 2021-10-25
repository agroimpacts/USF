## code to prepare `ptaxdata_1213` dataset goes here
ptaxdata_1213 <- read_excel(
  here("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/assessors/2019.8.20__SF_ASR_Secured_Roll_Data_2012-2013.xlsx"),
  sheet = "Roll Data 2012-2013") %>% .[-c(1, 2, 4:18)]

ptaxdata_1213[1] <-ptaxdata_1213[1] %>%
  mutate(across(where(is.character), str_remove_all, pattern = fixed(" ")))
usethis::use_data(ptaxdata_1213, overwrite = TRUE)
