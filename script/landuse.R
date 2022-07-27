#### SHINY DASHBOARD ####

# Housing Justice

# parcel data has been pre processed in a different script.
# See nyc_brooklyn_historicLU.R for more details.
#
# parcel data includes land use codes and assessed value for years 2007 and 2020
#
# data sources: PLUTO and MAP PLUTO.
# spatial join 2020 parcels w/pluto 2007 data in ArcPro. One to one.
# 2007 data: buildingsbk07.shp
# 2020 data: MapPluto data
#
# Preprocessed data: 'bkbuildingsparcels'
# clean data for leaflet

library(USF)
data("bkbuildingsparcels")
parcels <- bkbuildingsparcels
colnames(parcels)
names(parcels)[1] <- "LU_2020"
names(parcels)[2] <- "AssessLand2020"
names(parcels)[3] <- "AssessTot2020"
names(parcels)[9] <- "LU_2007"
names(parcels)[13] <- "AssessLand2007"
names(parcels)[14] <- "AssessTot2007"
names(parcels)[15] <- "DECODES2007"


# match LU_2020 to DECODES2020

parcels$LU_2020 <- as.integer(parcels$LU_2020)
lu_codes <- readLines("~/Clark/RA-ing/SummerInstitute/GIS/nyc/nyc_pluto_07c/LU_07.txt")
lu_codes <- str_split_fixed(lu_codes, " {1,}", 2) %>% data.frame(.)
lu_codes <- lu_codes[-c(13:36), ]
lu_codes <- lu_codes[-c(1), ]
names(lu_codes) <- c("CODES", "DECODES2020")
lu_codes$CODES <- lu_codes$CODES %>% as.integer()
parcels <- full_join(x = parcels, y = lu_codes, by = c("LU_2020" = "CODES")) %>%
  st_as_sf(., coords = c("Longitude", "Latitude"), crs = 2263) %>% st_transform(., crs = 4326)

# Brooklyn boundaries
brooklyn <- st_read("~/Clark/RA-ing/SummerInstitute/GIS/nyc/Borough Boundaries/boroughboundary.shp") %>%
   filter(boro_name == "Brooklyn") #%>%
  # st_transform(. , crs = st_crs(parcels))

# load brooklyn neighborhood boundary
data("brooklyn_neigh")
brooklyn_neigh <- brooklyn_neigh %>%
  st_transform(. , crs = st_crs(parcels))

# match coordinates
 st_bbox(brooklyn_neigh)
# st_bbox(brooklyn)
# st_bbox(parcels)
# st_crs(brooklyn_neigh)
# st_crs(brooklyn)

brooklyn_neigh <- brooklyn_neigh %>%
  st_transform(. , crs = st_crs(parcels))

# plot
plot(brooklyn$geometry, col = "grey")
plot(brooklyn_neigh$geometry, add = TRUE)

parcels <- st_join(parcels, brooklyn_neigh, left = TRUE)
# leaflet -The Leaflet package expects all point, line, and shape data to
# be specified in latitude and longitude using WGS 84 (a.k.a. EPSG:4326)
#parcels <- st_transform(parcels, crs = 4326)
st_crs(parcels)
colnames(parcels)
names(parcels)[20] <- "NHood"
#names(parcels)[16] <- "Tract"
saveRDS(parcels, "~/Clark/RA-ing/SummerInstitute/USF/housing-justice/parcels.RDS")


#### Test Assessed Value ####

library(leaflet)

# Test Williamsburg
q <- parcels %>% filter(NHood == "Williamsburg")

# quantile breaks
#install.packages("classInt")
library(classInt)
breaks_qt <- classIntervals(q$AssessLand2007, n = 5, style = "quantile")
br <- breaks_qt$brks
qpal <-  colorQuantile("Reds", q$AssessLand2007, n = 5)

# testing Assessed Land Value
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


#### testing land use ####
factpal <- colorFactor(topo.colors(12), parcels$DECODES2007) # legend v.1
factpal2 <- colorFactor(palette = "Spectral", parcels$DECODES2020) # legend v.1

mapq_interactive <- leaflet(q) %>% # openmaps background not showing up
  addPolygons(stroke = TRUE, fill = TRUE,
              color= NA, opacity = 5,
              weight = 7,
              fillOpacity = 6, fillColor = factpal2(q$DECODES2020),
              popup = paste("Use: ", q$DECODES2020, "<br>")
  ) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addLegend(pal = factpal2, values = q$DECODES2020,
            title = "Land Use",
            opacity = 0.7)

saveRDS(q, "~/R/USF/housing-justice/q.RDS")

# loading times
# not on repo but in shiny deployment
parcels2 <- saveRDS(parcels, "~/Clark/RA-ing/SummerInstitute/USF/housing-justice/parcels2.RDS",
                    compress = FALSE )
