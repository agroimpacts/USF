## code to prepare `ptaxdata_0809` dataset goes here
ptaxdata_0809 <- read_excel(
  here("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/assessors/2019.8.20__SF_ASR_Secured_Roll_Data_2009-2010.xlsx"),
  sheet = "Roll Data 2009-2010") %>% .[-c(1, 2, 4:18)]

ptaxdata_0809[1] <-ptaxdata_0809[1] %>%
  mutate(across(where(is.character), str_remove_all, pattern = fixed(" ")))
usethis::use_data(ptaxdata_0809, overwrite = TRUE)
