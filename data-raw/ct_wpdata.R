## code to prepare `ct_wpdata` dataset goes here
data(t_wpdata)
library(dplyr)

ct_wpdata <- t_wpdata %>% filter(city == "San Francisco" | city == "Chicago" |
                                   city == "Chicago" | city == "Baltimore" |
                                   city == "New York" | city == "Detroit" |
                                   city == "Kansas City")

usethis::use_data(ct_wpdata, overwrite = TRUE)
