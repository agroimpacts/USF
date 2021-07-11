## code to prepare `mpv_polkilbm` dataset goes here
library(readxl)

# read excel sheets
excel_sheets("MPVDatasetDownload.xlsx")
# specify worksheet 4 "Police Killings of Black Men"
mpv_polkilbm <- read_excel("MPVDatasetDownload.xlsx",
                           sheet = "Police Killings of Black Men")

names(mpv_polkilbm)[4] <- "Black Male Population (2015 ACS)"

usethis::use_data(mpv_polkilbm, overwrite = TRUE)

