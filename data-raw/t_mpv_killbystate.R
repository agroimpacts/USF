## code to prepare `t_mpv_killbystate` dataset goes here

data(mpv_killbystate)

# change name


## clean up
names(mpv_killbystate)[2] <- "State_Abbv"

t_mpv_killbystate <- mpv_killbystate %>%
  filter(State_Abbv == "MD"| State_Abbv == "IL" | State_Abbv == "NY" |
           State_Abbv == "CA" | State_Abbv == "MI" | State_Abbv == "MO")

usethis::use_data(t_mpv_killbystate, overwrite = TRUE)
