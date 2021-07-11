## code to prepare `mpv_killbypd` dataset goes here

library(readxl)
# read excel sheets
excel_sheets("MPVDatasetDownload.xlsx")

# specify worksheet 2 "2013-2020 Killings by PD"

mpv_killbypd <- read_excel("MPVDatasetDownload.xlsx",
                           sheet = "2013-2020 Killings by PD" )

usethis::use_data(mpv_killbypd, overwrite = TRUE)
