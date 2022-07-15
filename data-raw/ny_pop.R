## code to prepare `ny_pop` dataset goes here
ny_pop <- read.csv("C://CLARK//GEOSPAAR//floodlightblm//data//nyct2020_pop.csv")

usethis::use_data(ny_pop, overwrite = TRUE)
