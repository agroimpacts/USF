
# load boundary shapefile
# Source:https://data.cityofnewyork.us/City-Government/Borough-Boundaries/tqmj-j8zm
brooklyn <- st_read("~/Clark/RA-ing/SummerInstitute/GIS/nyc/Borough Boundaries/boroughboundary.shp") %>%
  filter(boro_name == "Brooklyn")
# st_write(brooklyn, here("localdrive/rtm_test/nyc/brooklyn.shp")) # shapefile in arc


# load historic crime data (complaints)
# Source: https://data.cityofnewyork.us/Public-Safety/NYPD-Complaint-Data-Historic/qgea-i56i
nychcrime <- read.csv("~/Clark/RA-ing/SummerInstitute/GIS/nyc/NYPD_Complaint_Data_Historic.csv") %>%
  filter(!Latitude %in% NA | !Longitude %in% NA) %>%
  as.data.frame(.) %>%
  st_as_sf(., coords = c("Longitude", "Latitude"), crs = 9001) %>% # changed 2260 to 9001 to match brooklyn
  rename(., c( "Full_Date" = "CMPLNT_FR_DT", "Time" ="CMPLNT_FR_TM")) # rename columns

# make sure both are in the same projection
st_crs(nychcrime) <- st_crs(brooklyn)

##### 2019 #####

bk19crime <- nychcrime %>% filter(BORO_NM == "BROOKLYN") %>%
  separate(Full_Date, into = c("Month", "Day", "Year"),
           sep = "/", remove = FALSE) %>%
  filter(Year == "2019")

# create property crime variable
bk19crime <- bk19crime %>% filter((grepl("ARSON|BURGLARY|THEFT|VANDALISM",
                                             PD_DESC)))


# rtm locations for 2019

bk19crime %>% group_by(.$PREM_TYP_DESC) %>% count() %>% arrange(-n)

heatmap07 <- bk19crime %>% # for temporal heat map
  mutate(timestamp = paste(Full_Date, Time)) %>%
  mutate(date1 = strptime(.$timestamp, format = "%m/%d/%Y %H:%M:%S")) %>%
  mutate(DayFormat = weekdays(date1)) %>%
  mutate(DayFormatText = as.character(DayFormat)) %>%
  mutate(HourFormat = hour(date1))


heatmap07 %>% group_by(.$PREM_TYP_DESC) %>% count() %>% arrange(-n)



bk19crime <- heatmap07 %>% filter(HourFormat == "15") %>% st_as_sf()
class(bk19crime)

bk19crime <- bk07crime[-c(2:18, 20:36)]

# shapefile for RTM software
st_write(bk19crime, "~/Clark/RA-ing/SummerInstitute/USF/localdrive/shapes/2allbk19crime.shp")






#### 2007 ####

bk07crime <- nychcrime %>% filter(BORO_NM == "BROOKLYN") %>%
  separate(Full_Date, into = c("Month", "Day", "Year"),
           sep = "/", remove = FALSE) %>%
  filter(Year == "2007")

# create property crime variable
bk07crime <- bk07crime %>% filter((grepl("ARSON|BURGLARY|THEFT|VANDALISM",
                                         PD_DESC)))


# rtm locations for 2019

bk07crime %>% group_by(.$PREM_TYP_DESC) %>% count() %>% arrange(-n)
