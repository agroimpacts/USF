## code to prepare `mpv` dataset goes here
library(readxl)
setwd("~/Clark/RA-ing/SummerInstitute/policeviolence")
mpv <- read_excel("MPVDatasetDownload.xlsx")
# read_excel sheets
#excel_sheets("MPVDatasetDownload.xlsx")

usethis::use_data(mpv, overwrite = TRUE)
