## code to prepare `brooklyn_neigh` dataset goes here

# load KML
nyc_boundaries <- st_read(here("~/Clark/RA-ing/SummerInstitute/GIS/nyc/brooklyn_boundaries/nyc_neighborhoods_map.kml")) %>%
  as.data.frame(.) %>%
  st_as_sf() %>%
  st_transform(. , crs = st_crs(brooklyn)) %>%
  select(-Description)

# match coordinates
st_bbox(nyc_boundaries)
st_bbox(brooklyn)
st_crs(nyc_boundaries) <- st_crs(brooklyn)

# clip
brooklyn_neigh <- nyc_boundaries[brooklyn, ]
brooklyn_neigh <- st_intersection(x = brooklyn_neigh, y = brooklyn)

# plot
plot(brooklyn$geometry, col = "grey")
plot(brooklyn_neigh$geometry, add = TRUE)


# create shapefile
brooklyn_neigh <- brooklyn_neigh %>% st_as_sf()
brooklyn_neigh <- st_collection_extract(brooklyn_neigh, "POLYGON")
st_write(brooklyn_neigh, "~/Clark/RA-ing/SummerInstitute/USF/localdrive/shapes/bk_neigh/brooklyn_neigh.shp") # edit boundaries in ArcPro

# reload edited shape

brooklyn_neigh <- st_read("~/Clark/RA-ing/SummerInstitute/USF/localdrive/shapes/bk_neigh/brooklyn_neigh.shp")

usethis::use_data(brooklyn_neigh, overwrite = TRUE)
