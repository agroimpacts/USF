## code to prepare `more_nijgrants` dataset goes here
library(dplyr)
setwd("C:/Users/pilii/Documents/Clark/RA-ing/SummerInstitute/")
more_nijgrants <- read.csv("NIJ_Baltimore/more_nijgrants.csv")

names(more_nijgrants)[3] <-  "Solicitor"
names(more_nijgrants)[1] <- "Fiscal_Y"
usethis::use_data(more_nijgrants, overwrite = TRUE)
