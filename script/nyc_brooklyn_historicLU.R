#### TEST HISTORIC LAND USE DATA FOR NEW YORK CITY ####


##### Property Valuation historical data #####
# this is only tax easement information, no land use
# historicPropnyc <- read.csv("~/Clark/RA-ing/SummerInstitute/GIS/nyc/Property_Valuation_and_Assessment_Data.csv")
# colnames(historicPropnyc)
# historicPropnyc$YEAR %>% unique() # data from 2010/11 to 2018/19
# historicPropnyc %>% head()
# Test 2010
# Propnyc2010 <- historicPropnyc %>% filter(YEAR == "2010/11")


##### PLUTO DATA #####

# download data in zip format.
# https://www1.nyc.gov/site/planning/data-maps/open-data/bytes-archive.page?sorts[year]=0

# BK07C for Brooklyn
pluto07 <- read.csv("~/Clark/RA-ing/SummerInstitute/GIS/nyc/nyc_pluto_07c/BK07C.csv")
colnames(pluto07)
lu_07 <- pluto07[c(14,24,25,27,28,50,52:53,68:69)]
lu_07$LandUse <- as.integer(lu_07$LandUse)
lu_codes <- readLines("~/Clark/RA-ing/SummerInstitute/GIS/nyc/nyc_pluto_07c/LU_07.txt")
lu_codes <- str_split_fixed(lu_codes, " {1,}", 2) %>% data.frame(.)
lu_codes <- lu_codes[-c(13:36), ]
lu_codes <- lu_codes[-c(1), ]
names(lu_codes) <- c("CODES", "DECODES")
lu_codes$CODES <- lu_codes$CODES %>% as.integer()
lu_07_desc <- full_join(x = lu_07, y = lu_codes, by = c("LandUse" = "CODES"))
lu_07_desc <- lu_07_desc %>%
  filter(!DECODES %in% NA) %>%
  as.data.frame(.)
bldg_class <- read.csv("~/Clark/RA-ing/SummerInstitute/GIS/nyc/nyc_pluto_07c/bldg_class_07.csv",
                       header=T, na.strings=c("","NA"))
bldg_class <- bldg_class[-c(4,5)]
bldg_class <- bldg_class %>%
  filter(!A %in% NA)
bldg_class <- bldg_class[-c(198, 163), ]
names(bldg_class)[1] <- "num_code"
names(bldg_class)[2] <- "group_code"
names(bldg_class)[3] <- "group_desc"
bldg_class[27, ]$num_code <- "D"
bldg_class[38, ]$num_code <- "E"
bldg_class <- bldg_class %>% mutate(bldgclass = paste(num_code, group_code))
bldg_class$bldgclass <- gsub(" ", "", bldg_class$bldgclass, fixed = TRUE)
bldg_desc <- full_join(x = lu_07_desc, y = bldg_class,
                       by = c("BldgClass" = "bldgclass"))%>% filter(!group_desc %in% NA)

# spatialize
brooklyn <- st_read("~/Clark/RA-ing/SummerInstitute/GIS/nyc/Borough Boundaries/boroughboundary.shp") %>%
  filter(boro_name == "Brooklyn")
bldg_desc_sp <- bldg_desc %>%
  filter(!XCoord %in% NA | !YCoord %in% NA) %>%
  as.data.frame(.) %>%
  st_as_sf(., coords = c("XCoord", "YCoord"), crs = 2908)
bldg_desc_sp <- st_transform(bldg_desc_sp, crs = st_crs(brooklyn)) # transform to same CRS
st_crs(bldg_desc_sp) <- st_crs(brooklyn)
st_bbox(bldg_desc_sp)
st_bbox(brooklyn)
bldg_desc_sp <- bldg_desc_sp[brooklyn, ] %>% st_as_sf()
# plot(brooklyn$geometry, main = "Land Use in BK 2007", col = "light grey")
# plot(bldg_desc_sp$geometry, col = '#18767D', pch = 20, add = TRUE)


# bring back property lot data to merge with spatial information
st_write(bldg_desc_sp, "localdrive/shapes/buildingsbk07.shp")


### In Arc Pro ###

# read in MapPluto 2020v1 data
# Spatial Join one to one, buildingsbk07 to MapPluto data.
# Select only BK parcels. then do spatial join. Output: bk_pluto
# The spatial join bk_pluto with buildingsbk07 data.

bkbuildingsparcels <- st_read("localdrive/shapes/bkbuildingsparcels1.shp")
bkbuildingsparcels %>% colnames()

bkbuildingsparcels <- bkbuildingsparcels[-c(1:31, 33:59, 64:89, 92:93, 105:106)]

# create layer for type of land use
# setwd("~/Clark/RA-ing/SummerInstitute/USF/localdrive/shapes/BK2007")
# layers <- bldg_desc$group_desc
# bldg_layers <- lapply(layers, function(x) {
#   bldg <- bldg_desc_sp %>% filter(group_desc == x)
#   st_write(bldg, "BK_bldg07_%2s.shp", x)
#   })

