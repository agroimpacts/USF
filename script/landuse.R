#### SHINY DASHBOARD ####

# Housing Justice
# land use - For 2007, 2020: assessed value of land + lu_codes.
# 'bldg_desc_sp'. See: nyc_brooklyn_historicLU.R
# spatial join 2020 parcels w/pluto 2007 data in ArcPro. One to one.
# load new shapefile, 'bkbuildingsparcels'
# clean data and create leaflet


parcels2020 <- st_read("~/Clark/RA-ing/SummerInstitute/GIS/nyc/NYC_2020_Tax_Parcels_SHP_2106/Kings_2020_Tax_Parcels_SHP_2106.shp")

parcels <- st_read("localdrive/shapes/bkbuildingsparcels.shp")
#colnames(parcels)
names(parcels)[17] <- "LAND_AV2020"
names(parcels)[18] <- "TOTAL_AV2020"
names(parcels)[19] <- "FULL_MV2020"
names(parcels)[34] <- "BLDG_DESC2020"
names(parcels)[75] <- "BldgClass2007"
names(parcels)[76] <- "LandUse2007"
names(parcels)[80] <- "AssessLand2007"
names(parcels)[81] <- "AssessTot2007"
names(parcels)[82] <- "DECODES2007"
parcels <- parcels[c(17:19, 34, 75, 76, 80:82)]


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

parcels <- st_join(parcels, brooklyn_neigh, left = TRUE)
# leaflet -The Leaflet package expects all point, line, and shape data to
# be specified in latitude and longitude using WGS 84 (a.k.a. EPSG:4326)
parcels <- st_transform(parcels, crs = 4326)
st_crs(parcels)
colnames(parcels)
names(parcels)[10] <- "Hood"
names(parcels)[16] <- "Tract"
saveRDS(parcels, "~/Clark/RA-ing/SummerInstitute/USF/housing-justice/parcels.RDS")
# library(tmap)
# tmap_mode("view")
# tm_shape(brooklyn) +
#   tm_polygons(col = NA)  +
#   tm_shape(parcels) +
#   tm_polygons(col = "AssessLand2007", border.lwd = NA, n = 5)  +
#   tm_layout(legend.outside = TRUE) +
#   tm_basemap(server = "OpenStreetMap", alpha = 0.7)

library(leaflet)

# qpal <-  colorBin("Reds", parcels$AssessLand2007, bins = 5)
# map_interactive <- leaflet(w) %>% # openmaps background not showing up
#   addPolygons(stroke = TRUE, fill = TRUE,
#               color= NA, opacity = 5,
#               # set the stroke width in pixels
#               weight = 7,
#               # set the fill opacity
#               fillOpacity = 6, fillColor = ~qpal(w$AssessLand2007),
#               highlightOptions = highlightOptions(weight = 5,
#                                                   fillOpacity = 1,
#                                                   color = "black",
#                                                   opacity = 1,
#                                                   bringToFront = TRUE)) %>%
#   addProviderTiles(providers$CartoDB.Positron) %>%
#   addLegend(values = ~AssessLand2007, pal = qpal,title = "Assessed Land Value, 2007")

q <- parcels %>% filter(Name == "Williamsburg")
# quantile breaks
#install.packages("classInt")
library(classInt)
breaks_qt <- classIntervals(q$AssessLand2007, n = 5, style = "quantile")
br <- breaks_qt$brks
qpal <-  colorQuantile("Reds", q$AssessLand2007, n = 5)
mapq_interactive <- leaflet(q) %>% # openmaps background not showing up
  addPolygons(stroke = TRUE, fill = TRUE,
              color= NA, opacity = 5,
              # set the stroke width in pixels
              weight = 7,
              # set the fill opacity
              fillOpacity = 6, fillColor = ~qpal(q$AssessLand2007),
              popup = paste("Value: ", q$AssessLand2007, "<br>"),
            # highlightOptions = highlightOptions(color = "black",
            #                                     weight = 2,
            #                                     bringToFront = TRUE)
              ) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addLegend(values = ~AssessLand2007, colors = brewer.pal(5, "Reds"),
            # labFormat = function(type, cuts, p) {
            #   n = length(cuts)
            #   p = paste0(round(p * 100), '%')
            #   cuts = paste0(formatC(cuts[-n]), " - ", formatC(cuts[-1]))},
            labels = paste0("up to ", format(breaks_qt$brks[-1], digits = 2)),
            title = "Assessed Land Value, 2007"
)

#saveWidget(map_interactive, "bk_assessland_2007_map.html")
