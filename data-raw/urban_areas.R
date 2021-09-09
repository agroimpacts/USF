## code to prepare `urban_areas` dataset goes here
library(sf)
library(dplyr)
setwd("~/Clark/RA-ing/SummerInstitute/GIS")
download.file("https://www2.census.gov/geo/tiger/TIGER2020/UAC/tl_2020_us_uac10.zip",
destfile ="~/Clark/RA-ing/SummerInstitute/GIS/tl_2020_us_uac10.zip")
system(unzip("tl_2020_us_uac10.zip",
             exdir ="SHP"))
US_urban_areas <- st_read("SHP/tl_2020_us_uac10.shp")



metropolan division
https://www2.census.gov/geo/tiger/TIGER2020/METDIV/tl_2020_us_metdiv.zip

download.file("https://www2.census.gov/geo/tiger/TIGER2020/METDIV/tl_2020_us_metdiv.zip",
              destfile ="~/Clark/RA-ing/SummerInstitute/GIS/tl_2020_us_metdiv.zip")
system(unzip("tl_2020_us_metdiv.zip",
             exdir ="SHP"))
US_metro <- st_read("SHP/tl_2020_us_metdiv.shp")
# case studies

urban_areas <- US_urban_areas %>% filter(NAME10 == "Chicago, IL--IN" |
                                           NAME10 == "Baltimore, MD" |
                                           NAME10 == "New York City, NY"|
                                           NAME10 == "Detroit, MI"|
                                           NAME10 == "Kansas City, MO")

US_urban_areas %>% filter(Name10 == "Chigago, IL")

usethis::use_data(urban_areas, overwrite = TRUE)
