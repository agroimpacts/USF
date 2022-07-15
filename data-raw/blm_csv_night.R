## code to prepare `blm_csv_night` dataset goes here
#NYC BLM Protest Points 2012-2022 - end 2021

blm_csv_night <- read.csv("C://CLARK//GEOSPAAR//floodlightblm//data//blmprotestpts.csv")

usethis::use_data(blm_csv_night, overwrite = TRUE)
