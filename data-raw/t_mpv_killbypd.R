## code to prepare `t_mpv_killbypd` dataset goes here

data(mpv_killbypd)

# filter by State
t_mpv_killbypd <- mpv_killbypd %>%
  filter(State == "Maryland"| State == "Illinoins" | State == "New York" | State == "California" |
           State == "Michigan" | State == "Missurri")

usethis::use_data(t_mpv_killbypd, overwrite = TRUE)

