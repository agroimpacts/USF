#### CASE STUDY 1A ####

# Test Lyndon's idea for how best to visualize RTM data.
# Create a layer:
# -	Land value 2007 (or, alternatively, 2020)
# -	Difference between 2020-2007 land value (or alternatively, 2007-2020)
# -	Risky locations 2007 (or 2020)
# -	Difference between risk locations 2020-2007 (or 2020-2007).


# Load libraries
library(shiny)
library(tidyverse)
library(leaflet)
library(htmlwidgets)
library(here)
library(classInt)
library(RColorBrewer)
library(sp)
library(sf)
library(shinydashboard)
library(readr)



# Load parcel data for both years from dashboard files
setwd("~/housing-justice")
parcels2007 <- readRDS("parcels2.RDS")
bk_priority2007 <- readRDS("bk_priority.RDS")

setwd("~/housing-justice-2020")
parcels2020 <- readRDS("parcels2.RDS")
bk_priority2020 <- readRDS("bk_priority2020.RDS")


# if else changes in land use

luchange <- parcels2007 %>%
  mutate(LUSEch = ifelse(LU_2020 == LU_2007, "No change", "Change"))


## EXPORT SHP ##

st_write(bk_priority2007, "~/Clark/RA-ing/SummerInstitute/USF/localdrive/shapes/website/bk_priority2007.shp" )
st_write(bk_priority2020, "~/Clark/RA-ing/SummerInstitute/USF/localdrive/shapes/website/bk_priority2020.shp" )
st_write(parcels2007, "~/Clark/RA-ing/SummerInstitute/USF/localdrive/shapes/website/parcels2007.shp" )
st_write(luchange, "~/Clark/RA-ing/SummerInstitute/USF/localdrive/shapes/website/luchange2.shp" )


# difference between 2020-2007 land value

parcels2007 <- parcels2007 %>% mutate(diffLV = .$AssessLand2020-.$AssessLand2007)

# difference between 2020-2007 HHI
parcels2007 <- parcels2007 %>% mutate(diffHHI = .$estimate2009-.$estimate2019)

# functions to format the legend
library(classInt)
breaks_qt1 <- classIntervals(parcels2007$AssessLand2007, n = 5, style = "quantile")
br <- breaks_qt1$brks
rpal <-  colorQuantile("Reds", parcels2007$AssessLand2007, n = 5)
dpal <-  colorQuantile("Blues", parcels2007$diffLV, n = 5)
breaks_qt2 <- classIntervals(parcels2007$estimate2009, n = 7, style = "quantile")
br <- breaks_qt2$brks
gpal <-  colorQuantile("Greens", parcels2007$estimate2009, n = 7)
dpal <-  colorQuantile("Greens", parcels2007$diffHHI, n = 7)
factpal2 <- colorFactor(palette = "RdYlBu", luchange$LUSEch)




# test land use
luchange <- luchange %>% filter(NHood == "Bed Stuy")
mapq_interactive <- leaflet() %>% # calls leaflet
  addProviderTiles(providers$CartoDB.Positron) %>% #base map
  addPolygons(data = luchange, stroke = TRUE, fill = TRUE,
              color= NA, opacity = 5,
              weight = 7,
              fillOpacity = 6, fillColor = factpal2(luchange$LUSEch))


# Test Bk Priority risk two years
mapq_interactive <- leaflet() %>% # calls leaflet
    addProviderTiles(providers$CartoDB.Positron) %>% #base map
  # # Land Value 2007
  # addPolygons(data = parcels2007, group = "Land Value",
  #             stroke = TRUE, fill = TRUE,
  #             color= NA, opacity = 5,
  #             weight = 7,
  #             fillOpacity = 6, fillColor = ~rpal(parcels2007$AssessLand2007),
  #             popup = paste("Value: $",
  #                           prettyNum(format(parcels2007$AssessLand2007),
  #                                     big.mark = ","), "<br>")) #%>%
  # Risk Locations
  addPolygons(data = bk_priority2007, # 2007 location (under layer)
              stroke = FALSE, fill = TRUE,
              opacity = 1,
              weight = 5,
              color = "#c6b1e0", #light grey purple
              fillOpacity = 1, fillColor = "#c6b1e0", group = "Risk 2007") %>%
  addPolygons(data = bk_priority2020, # 2020 location (over layer)
            stroke = FALSE, fill = TRUE,
            color= "#7402f5", # hot purple
            opacity = 0.8,
            weight = 5, # set the stroke width in pixels,
            fillOpacity = 0.8, fillColor = "#7402f5", group = "Risk 2020") %>%
  addLayersControl(position = "topright",
                   overlayGroups = c("Land Value", "Risk 2007", "Risk 2020"),
                   options = layersControlOptions(collapsed = FALSE))

mapq_interactive

# Test difference land value
# filter for Williamsburg, Redhook, Greenpoint, Bed Stuy, Gowanus, Carroll Gardens
testparcels <- parcels2007 %>% filter(NHood == "Bed Stuy")
mapq_interactive2 <- leaflet() %>% # calls leaflet
  addProviderTiles(providers$CartoDB.Positron) %>% #base map
  # Land Value
  addPolygons(data = testparcels, group = "Land Value",
              stroke = TRUE, fill = TRUE,
              color= NA, opacity = 5,
              weight = 7,
              fillOpacity = 6, fillColor = ~dpal(parcels2007$diffLV),
              popup = paste("Value: $",
                            prettyNum(format(parcels2007$diffLV),
                                      big.mark = ","), "<br>"))
mapq_interactive2


