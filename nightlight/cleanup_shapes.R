# Clean up shapefiles for USFlite repo

library(USF)
#setwd(USF path)

# load shapefiles. Project to 2263
data("nytract")
nytract <- nytract %>%
st_transform(nytract, crs = 2263)

saveRDS(nytract, "~/Clark/RA-ing/SummerInstitute/USFlite/nightlight/nytract.RDS")


# Geojson of NYC public housing developments
data("nycha")
nycha <- nycha %>%
  st_transform(., crs = 2263)

saveRDS(nycha, "~/Clark/RA-ing/SummerInstitute/USFlite/nightlight/nycha.RDS")


# Select Polo Grounds Towers for proof of concept
polo <- nycha %>% dplyr::filter(., developmen == "POLO GROUNDS TOWERS") %>%
  st_transform(., crs = 2263)

saveRDS(polo, "~/Clark/RA-ing/SummerInstitute/USFlite/nightlight/polo.RDS")


# Import population data with common attribute to shapefile, "BoroCT2020"
data("ny_pop")
ny_pop <- ny_pop

saveRDS(ny_pop, "~/Clark/RA-ing/SummerInstitute/USFlite/nightlight/ny_pop.RDS")


# Shapefile of NYC building footprints - source NYC open data - to heavy. Download directly from site
buildings <- geojson_sf("~/Clark/RA-ing/SummerInstitute/nightlight/data/Building_Footprints.geojson") %>%
  st_transform(., crs = 2263) %>% filter(., feat_code == 2100)
library(rgdal)
library(sf)
st_write(buildings, "~/Clark/RA-ing/SummerInstitute/nightlight/data/buildings.geojson")

download.file("https://www.dropbox.com/s/o1griqqa1biezpc/buildings.geojson?dl=1",
                           destfile = "~/USFlite/nightlight/buildings.geojson")
buildings <- geojson_sf("~/USFlite/nightlight/buildings.geojson")


# BLM protests at night
data("blm_csv_night")
blm_csv_night <- blm_csv_night
blm_pts_night <- st_as_sf(blm_csv_night, coords = c("Long", "Lat"),
                          crs = 4326) %>% st_transform(., crs = 2263)

saveRDS(blm_pts_night, "~/Clark/RA-ing/SummerInstitute/USFlite/nightlight/blm_pts_night.RDS")
