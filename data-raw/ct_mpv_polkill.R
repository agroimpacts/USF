## code to prepare `ct_mpv_polkill` dataset goes here

ct_mpv_polkill <- t_mpv_polkill %>% filter(City == "San Francisco" |
                                             City == "Chicago" |
                                             City == "Baltimore" |
                                             City == "New York" |
                                             City == "Detroit" |
                                             City == "Kansas City")

usethis::use_data(ct_mpv_polkill, overwrite = TRUE)
