## code to prepare `ptaxdata_1718` dataset goes here
ptaxdata_1718 <- read_excel(
  here("~/Clark/RA-ing/SummerInstitute/GIS/sanfran/assessors/2019.8.12__SF_ASR_Secured_Roll_Data_2017-2018.xlsx"),
  sheet = "Roll Data 2017-2018")%>% .[-c(1, 2, 4:18)]

ptaxdata_1718[1] <-ptaxdata_1718[1] %>%
  mutate(across(where(is.character), str_remove_all, pattern = fixed(" ")))
usethis::use_data(ptaxdata_1718, overwrite = TRUE)
