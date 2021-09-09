## code to prepare `t_mpv_polkilbm` dataset goes here

data(mpv_polkilbm)
colnames(mpv_polkilbm)

t_mpv_polkilbm <- mpv_polkilbm %>%
  filter(City == "Baltimore"| City == "Chicago" | City == "New York City" | City == "San Francisco" |
           City == "Detroit" | City == "Kansas City Missouri")

usethis::use_data(t_mpv_polkilbm, overwrite = TRUE)
