## code to prepare `ct_encounters` dataset goes here
library(dplyr)
data(t_encounters)

ct_encounters <- t_encounters %>% filter(city_death == "San Francisco" |
                         city_death == "Chicago" | city_death == "Baltimore" |
                           city_death == "New York" | city_death == "Detroit" |
                           city_death == "Kansas City")

usethis::use_data(ct_encounters, overwrite = TRUE)
