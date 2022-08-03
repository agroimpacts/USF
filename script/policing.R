#### SHINY DASHBOARD ####

# Housing Justice

# Brooklyn boundaries
brooklyn <- st_read("~/Clark/RA-ing/SummerInstitute/GIS/nyc/Borough Boundaries/boroughboundary.shp") %>%
  filter(boro_name == "Brooklyn") %>%
  st_transform(. , crs = st_crs(parcels))

# load KML
nyc_boundaries <- st_read(here("~/Clark/RA-ing/SummerInstitute/GIS/nyc/brooklyn_boundaries/nyc_neighborhoods_map.kml")) %>%
  as.data.frame(.) %>%
  st_as_sf() %>%
  st_transform(. , crs = st_crs(parcels)) %>%
  select(-Description)

# load KML
bk_priority<- st_read(here("~/Clark/RA-ing/SummerInstitute/USF/localdrive/rtm_test/results_bk2007/bk2007_PNG_KML/GoogleEarthKML_PriorityPlaces.kml")) %>%
  as.data.frame(.) %>%
  st_as_sf() %>%
  st_transform(. , crs = st_crs(parcels)) %>%
  select(-Description)

st_crs(bk_priority)
st_crs(parcels)
bk_priority <- st_transform(bk_priority, crs = 4326)
bk_priority <- st_join(bk_priority, nyc_boundaries, left = TRUE)


saveRDS(bk_priority, "~/Clark/RA-ing/SummerInstitute/USF/housing-justice/bk_priority.RDS")


## 2019 data
# load KML
bk_priority<- st_read(here("~/Clark/RA-ing/SummerInstitute/USF/localdrive/rtm_test/bk2019/PriorityPlaces.kml")) %>%
  as.data.frame(.) %>%
  st_as_sf() %>%
  st_transform(. , crs = st_crs(parcels)) %>%
  select(-Description)

st_crs(bk_priority)
st_crs(parcels)
bk_priority <- st_transform(bk_priority, crs = 4326)

saveRDS(bk_priority, "~/Clark/RA-ing/SummerInstitute/USF/housing-justice-2020/bk_priority2020.RDS")


# q <- parcels %>% filter(Name == "Williamsburg") %>%
#   filter(!estimate %in% NA)
# # quantile breaks
# #install.packages("classInt")
# library(classInt)
# breaks_qt <- classIntervals(q$estimate, n = 7, style = "quantile")
# br <- breaks_qt$brks
# qpal <-  colorQuantile("Greens", q$estimate, n = 7)
mapq_interactive <- leaflet(bk_priority) %>% # openmaps background not showing up
  addPolygons(stroke = TRUE, fill = TRUE,
              color= NA, opacity = 5,
              # set the stroke width in pixels
              weight = 7,
              # set the fill opacity
              fillOpacity = 6, fillColor = "Reds",
              #popup = paste("Value: ", q$estimate, "<br>"),
              # highlightOptions = highlightOptions(color = "black",
              #                                     weight = 2,
              #                                     bringToFront = TRUE)
  ) %>%
  addProviderTiles(providers$CartoDB.Positron) #%>%
  #addLegend(values = ~estimate, colors = brewer.pal(7, "Greens"),
            # labFormat = function(type, cuts, p) {
            #   n = length(cuts)
            #   p = paste0(round(p * 100), '%')
            #   cuts = paste0(formatC(cuts[-n]), " - ", formatC(cuts[-1]))},
            #labels = paste0("up to ", format(breaks_qt$brks[-1], digits = 2)),
            #title = "Median Household Income, 2009"


