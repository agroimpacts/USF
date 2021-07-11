## code to prepare `mdh_lasd` dataset goes here
library(readr)
setwd("~/Clark/RA-ing/SummerInstitute/milliondollarhoods")
mdh_lasd <- read.csv("LASD2012_2017Ranking.csv") %>%
  rename(daysjail = days.in.jail, Pop2010 = X2010.Population, id = ï..id)

mdh_lasd$cost <- gsub(",", "", mdh_lapd$cost)
mdh_lasd$cost <- as.numeric(gsub("\\$", "", mdh_lasd$cost))

mdh_lasd$daysjail <- gsub(",", "", mdh_lasd$daysjail) %>% as.numeric()

mdh_lasd$arrests <- gsub(",", "", mdh_lasd$arrests) %>% as.numeric()

mdh_lasd$Pop2010 <- gsub(",", "", mdh_lasd$Pop2010) %>% as.numeric()
usethis::use_data(mdh_lasd, overwrite = TRUE)
