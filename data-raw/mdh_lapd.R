## code to prepare `mdh_lapd` dataset goes here
library(readr)
library(dplyr)
setwd("~/Clark/RA-ing/SummerInstitute/milliondollarhoods")
mdh_lapd <- read.csv("LAPD2012_2017Ranking.csv") %>%
  rename(daysjail = days.in.jail, Pop2010 = X2010.Population, id = ï..id)

mdh_lapd$cost <- gsub(",", "", mdh_lapd$cost)
mdh_lapd$cost <- as.numeric(gsub("\\$", "", mdh_lapd$cost))

mdh_lapd$daysjail <- gsub(",", "", mdh_lapd$daysjail) %>% as.numeric()

mdh_lapd$arrests <- gsub(",", "", mdh_lapd$arrests) %>% as.numeric()

mdh_lapd$Pop2010 <- gsub(",", "", mdh_lapd$Pop2010) %>% as.numeric()

usethis::use_data(mdh_lapd, overwrite = TRUE)
