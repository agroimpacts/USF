#### SHINY DASHBOARD ####

# RISK - property crime 2007

brooklyn <- st_read("~/Clark/RA-ing/SummerInstitute/GIS/nyc/Borough Boundaries/boroughboundary.shp") %>%
  filter(boro_name == "Brooklyn") %>%
  st_transform(. , crs = st_crs(4326))

# Create spatial feature
# load NYC historic crime data
nychcrime <- read.csv("~/Clark/RA-ing/SummerInstitute/GIS/nyc/NYPD_Complaint_Data_Historic.csv") %>%
  filter(!Latitude %in% NA | !Longitude %in% NA) %>% # remove NA values
  as.data.frame(.) %>%
  st_as_sf(., coords = c("Longitude", "Latitude"), crs = 4326) %>% # to match brooklyn
  rename(., c( "Full_Date" = "CMPLNT_FR_DT", "Time" ="CMPLNT_FR_TM")) # rename columns

# make sure both features have the same projection
st_crs(nychcrime)
st_crs(brooklyn)

# create a feature for all Brooklyn crimes for 2007
bk07crime <- nychcrime %>% filter(BORO_NM == "BROOKLYN") %>% # extract Brooklyn data
  separate(Full_Date, into = c("Month", "Day", "Year"), # separate field Full_Date into new columns
           sep = "/", remove = FALSE) %>%
  filter(Year == "2007") %>% # extract 2007 data
  filter((grepl("ARSON|BURGLARY|THEFT|VANDALISM", PD_DESC)))
bk07crime <- bk07crime[brooklyn, ]
bk07crime <- bk07crime[-c(3:4, 7:13, 14:18, 21:31,34:36)]

# heatmap
bk07crime <- bk07crime %>% # filter propcrime
  mutate(timestamp = paste(Full_Date, Time)) %>%
  mutate(date1 = strptime(.$timestamp, format = "%m/%d/%Y %H:%M:%S")) %>%
  mutate(DayFormat = weekdays(date1)) %>%
  mutate(DayFormatText = as.character(DayFormat)) %>%
  mutate(HourFormat = hour(date1))

# propcrime + neighborhood join
bk07crime <- st_join(bk07crime, comms_bk, left = TRUE)

saveRDS(bk07crime, "~/Clark/RA-ing/SummerInstitute/USF/risk/bk07crime.RDS")


leaflet(bk07crime) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
    addCircles(radius = 2, weight = 1, color = "#545050",
             fillOpacity = 0.3, stroke = TRUE)

# histo for risky locations for that hour of the day
# assume its for 3pm

rtm <- bk07crime # create new variable
st_geometry(rtm) <- NULL # drop geometry to make processing easier
saveRDS(rtm, "~/Clark/RA-ing/SummerInstitute/USF/risk/rtm.RDS")



rtm %>% filter(HourFormat == "15") %>% filter(!PREM_TYP_DESC == "STREET") %>%
group_by(.$PREM_TYP_DESC) %>%
   count() %>% # frequency per group
   rename(., RTM_factors = ".$PREM_TYP_DESC", Count = "n") %>%
  as_tibble() %>% arrange(-Count)


leaflet(bk07crime) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addCircles(radius = 2, weight = 1, color = "#545050",
             fillOpacity = 0.3, stroke = TRUE)
