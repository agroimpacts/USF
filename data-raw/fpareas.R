## code to prepare `fpareas` dataset goes here

setwd("~/Clark/RA-ing/SummerInstitute/GIS/baltimore")

fpareas <- st_read("beats.shp") %>% fpareas[-2]

usethis::use_data(fpareas, overwrite = TRUE)
