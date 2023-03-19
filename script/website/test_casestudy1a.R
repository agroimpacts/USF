
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

setwd("~/Clark/RA-ing/SummerInstitute/USF/housing-justice")
parcels2007 <- readRDS("parcels2.RDS")
#parcels <- readRDS("parcels.RDS")
#parcels <- readRDS("q.RDS") #Williamsburg test
bk_priority2007 <- readRDS("bk_priority.RDS")
brooklyn_neigh <- readRDS("brooklyn_neigh.RDS")

setwd("~/Clark/RA-ing/SummerInstitute/USF/housing-justice-2020")
parcels2020 <- readRDS("parcels2.RDS")
#bk_priority <- readRDS("bk_priority.RDS") # replace with 2019 data
brooklyn_neigh <- readRDS("brooklyn_neigh.RDS")
bk_priority2020 <- readRDS("bk_priority2020.RDS")


# merge Bk_priority for both years
bk_priority2007 <- bk_priority2007 %>% mutate(group = "1")
bk_priority2020 <- bk_priority2020 %>% mutate(group = "2")

testjoin <- st_join(bk_priority2007,bk_priority2020, left = T)
view(testjoin)



# Test Bk Priority risk two years
mapq_interactive <- leaflet() %>% # calls leaflet
    addProviderTiles(providers$CartoDB.Positron) %>% #base map
  addPolygons(data = bk_priority2007, # 2007 location (under layer)
              stroke = FALSE, fill = TRUE,
              opacity = 2,
              weight = 2,
              color = "##a39091", #light grey red
              fillOpacity = 2, fillColor = "#c97c77" ) %>%
addPolygons(data = bk_priority2020, # 2020 location (over layer)
            stroke = FALSE, fill = TRUE,
            color= "#f52516", # hot red
            opacity = 0.7,
            weight = 2, # set the stroke width in pixels,
            fillOpacity = 0.7, fillColor = "#f52516")
