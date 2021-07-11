## code to prepare `mpv_polkill` dataset goes here

library(readxl)
setwd("~/Clark/RA-ing/SummerInstitute/policeviolence")
# read excel sheets
excel_sheets("MPVDatasetDownload.xlsx")

# specify worksheet 1 "2013-2020 Police Killings"

mpv_polkill <- read_excel("MPVDatasetDownload.xlsx",
                          sheet = "2013-2020 Police Killings")
names(mpv_polkill)[27] <- "Geography"

usethis::use_data(mpv_polkill, overwrite = TRUE)
