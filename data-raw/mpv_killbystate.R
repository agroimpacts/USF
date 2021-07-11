## code to prepare `mpv_killbystate` dataset goes here
library(readxl)
# read excel sheets
excel_sheets("MPVDatasetDownload.xlsx")
# specify worksheet 3 "2013-2020 Killings by State"

mpv_killbystate <- read_excel("MPVDatasetDownload.xlsx",
                              sheet = "2013-2020 Killings by State")
usethis::use_data(mpv_killbystate, overwrite = TRUE)
