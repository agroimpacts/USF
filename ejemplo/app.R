#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
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

parcels <- readRDS("parcels.RDS")
#parcels <- readRDS("q.RDS") #Williamsburg test
bk_priority <- readRDS("bk_priority.RDS")
brooklyn_neigh <- readRDS("brooklyn_neigh.RDS")


ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = "Housing Justice"),
  dashboardSidebar(
    h5("
        Land Value is based on the Assessor's appraisal for the city of NY.
           Data source: PLUTO", align = "center"),
    h5("
        Income is based on acs5 census data for 2009.
        Aggregate data per census tract.", align = "center"),
    h5("
        Risky locations are the outputs of an RTM analysis based on
           historic crime data for NYC.", align = "center"),
    width = 350,
    sidebarMenu(
      menuItem(selectInput("variable", "Select a variable",
                           choices = c("Select", "Land Use",
                                       "Assessed Land Value",
                                       "Median Household Income"))),
      menuItem(
        "Data Sources"
      )
    ),
    menuSubItem("PLUTO data", href = "https://www1.nyc.gov/site/planning/data-maps/open-data/dwn-pluto-mappluto.page"),
    menuSubItem("Historic crime data", href = "https://data.cityofnewyork.us/Public-Safety/NYPD-Complaint-Data-Historic/qgea-i56i")
  ),
  dashboardBody(
    tags$head(tags$style(HTML('
      .main-header .logo {
        font-family: "Arial", serif;
        font-weight: bold;
        font-size: 24px;
      }
    '))),
    fluidPage(
     leafletOutput("map2", height = "700px"))
      )
  )





server <- function(input, output) {

  landlayer <- reactive({
    x <- if (input$variable == "Land Use") {
      parcels %>% select(DECODES2007, DECODES2020, geometry)
    } else if (input$variable == "Assessed Land Value") {
      parcels %>% select(AssessLand2007, AssessLand2020, geometry)
    } else if (input$variable == "Median Household Income") {
      parcels %>% select(estimate2019, estimate2009, geometry)
    }
    return(x)
  })


  output$map2 <- renderLeaflet({

    # functions to format the legend 2007
    library(classInt)
    breaks_qt1 <- classIntervals(parcels$AssessLand2007, n = 5, style = "quantile")
    br <- breaks_qt1$brks
    rpal <-  colorQuantile("Reds", parcels$AssessLand2007, n = 5)
    breaks_qt2 <- classIntervals(parcels$estimate2009, n = 7, style = "quantile")
    br <- breaks_qt2$brks
    gpal <-  colorQuantile("Greens", parcels$estimate2009, n = 7)
    factpal2 <- colorFactor(palette = "RdYlBu", parcels$DECODES2007)

     # basemap
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      setView(-73.93, 40.68, zoom = 12)  #%>% # Zoom issue
      #setView(lng = xy()[1], lat = xy()[2], zoom = 10) %>% #Lyndon's rec + my edits
      # addLayersControl(position = "topleft",
      #                  overlayGroups = c("Land Value", "Household Income",
      #                                    "Risky locations", "Land Use"),
      #                  options = layersControlOptions(collapsed = FALSE)
      # ) %>%
      # hideGroup(c("Household Income",
      #             "Risky locations", "Land Use")) %>%
      # addLegend(values = ~AssessLand2020, colors = brewer.pal(5, "Reds"),
      #           labels = paste0("up to $",
      #                           prettyNum(format(breaks_qt1$brks[-1],
      #                                            digits = 7),
      #                                     big.mark = ",")),
      #           title = "Assessed Land Value, 2020", opacity = 0.7
      # ) %>%
      # addLegend(values = ~estimate2019, colors = brewer.pal(7, "Greens"),
      #           labels = paste0("up to $",
      #                           prettyNum(format(breaks_qt2$brks[-1],
      #                                            digits = 2 ),
      #                                     big.mark = ",")),
      #           title = "Median Household Income, 2019", opacity = 0.7
      # ) %>%
      # addLegend(pal = factpal2, values = parcels$DECODES2020,
      #           title = "Land Use",
      #           opacity = 0.7)
  })

  # layer 1: assessed land value
  observe({

    leafletProxy("map2", data = landlayer()) %>%
      #setView(lng = xy()[1], lat = xy()[2], zoom = 10) %>% #Lyndon's rec + my edits
      #setView(lng = xy()[1,1], lat = xy()[1,2], zoom = 10) %>%
      addPolygons(group = "Assessed Land Value",
                  stroke = TRUE, fill = TRUE,
                  color= NA, opacity = 5,
                  weight = 7,
                  fillOpacity = 6, fillColor = ~rpal(landlayer()$AssessLand2007),
                  popup = paste("Value: $",
                                prettyNum(format(landlayer()$AssessLand2020),
                                          big.mark = ","), "<br>")
      )
  })

  observe({

    leafletProxy("map2", data = landlayer()$AssessLand2007) %>%
      #setView(lng = xy()[1], lat = xy()[2], zoom = 10) %>% #Lyndon's rec + my edits
      #setView(lng = xy()[1,1], lat = xy()[1,2], zoom = 10) %>%
      addPolygons(group = "Assessed Land Value",
                  stroke = TRUE, fill = TRUE,
                  color= NA, opacity = 5,
                  weight = 7,
                  fillOpacity = 6, fillColor = ~rpal(parcels$AssessLand2007),
                  popup = paste("Value: $",
                                prettyNum(format(parcels$AssessLand2007),
                                          big.mark = ","), "<br>")
      )
  })
#
#   # layer 2: household income
#   observe({
#
#     leafletProxy("map2", data = parcels$estimate2019) %>%
#       #setView(lng = xy()[1], lat = xy()[2], zoom = 10) %>% #Lyndon's rec + my edits
#       addPolygons(group = "Household Income",
#                   stroke = TRUE, fill = TRUE,
#                   color= NA, opacity = 5,
#                   weight = 7,
#                   fillOpacity = 6, fillColor = ~gpal(parcels$estimate2019),
#                   popup = paste("Value: $",
#                                 prettyNum(format(parcels$estimate2019),
#                                           big.mark = ","), "<br>"))
#   })
#
#   #layer 3: Risky locations
#   # observe({
#   #
#   #   leafletProxy("map", data = priority()) %>%
#   #     #setView(lng = xy()[1], lat = xy()[2], zoom = 10) %>% #Lyndon's rec + my edits
#   #     addPolygons(group = "Risky locations", stroke = TRUE, fill = TRUE,
#   #                 opacity = 5,
#   #                 weight = 7,
#   #                 color = NA,
#   #                 fillOpacity = 6, fillColor = priority()$Name.y)
#   # })
#   #
#   #layer 4: Land Use
#   observe({
#
#     leafletProxy("map2", data = parcels$DECODES2020) %>%
#       #setView(lng = xy()[1], lat = xy()[2], zoom = 10) %>% #Lyndon's rec + my edits
#       addPolygons(group = "Land Use",
#                   stroke = TRUE, fill = TRUE,
#                   color= NA, opacity = 5,
#                   weight = 7,
#                   fillOpacity = 6, fillColor = factpal2(parcels$DECODES2020),
#                   popup = paste("Land Use Type: ", parcels$DECODES2020, "<br>"))
#   })


}






shinyApp(ui = ui, server = server)
