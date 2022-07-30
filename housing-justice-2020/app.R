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

parcels <- readRDS("parcels2.RDS")
#bk_priority <- readRDS("bk_priority.RDS") # replace with 2019 data
brooklyn_neigh <- readRDS("brooklyn_neigh.RDS")


ui <- dashboardPage(
    skin = "black",
    dashboardHeader(title = "Housing Justice for 2020", titleWidth = 350),
    dashboardSidebar(
        h5("
        Land Value is based on the Assessor's appraisal for the city of NY.
           Data source: PLUTO", align = "left"),
        h5("
        Income is based on acs5 census data for 2019.
        Aggregate data per census tract.", align = "left"),
        h5("
        Risky locations are the outputs of an RTM analysis based on
           historic crime data for NYC.", align = "left"),
        width = 350,
        sidebarMenu(
            menuItem(selectInput("nhood", "Select a neighborhood",
                                 choices = c("Select", sort(unique(parcels$NHood))))
            ),
            menuItem(
                "Data Sources"
            )
        ),
        menuSubItem("PLUTO data",
                    href = "https://www1.nyc.gov/site/planning/data-maps/open-data/dwn-pluto-mappluto.page"),
        menuSubItem("Historic crime data",
                    href = "https://data.cityofnewyork.us/Public-Safety/NYPD-Complaint-Data-Historic/qgea-i56i")
    ),
    dashboardBody(
        tags$head(tags$style(HTML('
      .main-header .logo {
        font-family: "Arial", serif;
        font-weight: bold;
        font-size: 24px;
      }
    '))),
        fillPage(
            leafletOutput("map", width = "900px", height = "600px"))
    )
)




server <- function(input, output) {

    # reactive functions - defined by user input
    neighborhood <- reactive({
        w <- parcels %>% filter(NHood == input$nhood)
        return(w)
    })


    # functions to format the legend 2007
    library(classInt)
    breaks_qt1 <- classIntervals(parcels$AssessLand2007, n = 5, style = "quantile")
    br <- breaks_qt1$brks
    rpal <-  colorQuantile("Reds", parcels$AssessLand2007, n = 5)
    breaks_qt2 <- classIntervals(parcels$estimate2009, n = 7, style = "quantile")
    br <- breaks_qt2$brks
    gpal <-  colorQuantile("Greens", parcels$estimate2009, n = 7)
    factpal2 <- colorFactor(palette = "RdYlBu", parcels$DECODES2007)



    output$map <- renderLeaflet({

        # basemap
        leaflet(brooklyn_neigh) %>%
            addPolygons(color = "grey", weight = 1, smoothFactor = 0.5,
                        opacity = 0.4, fillOpacity = 0.03, fillColor = "#f0ede9",
                        popup = paste(brooklyn_neigh$Name)) %>%
            addProviderTiles(providers$CartoDB.Positron) %>%
            setView(-73.93, 40.60, zoom = 11)  %>%
            addLayersControl(position = "topleft",
                             overlayGroups = c("Priority Risky Locations",
                                               "Land Use",
                                               "Land Value",
                                               "Household Income"),
                             options = layersControlOptions(collapsed = FALSE)) %>%
            hideGroup(c("Land Value",
                        "Household Income"))  %>%
            addLegend(values = ~AssessLand2007, colors = brewer.pal(5, "Reds"),
                      labels = paste0("up to $",
                                      prettyNum(format(breaks_qt1$brks[-1],
                                                       digits = 7),
                                                big.mark = ",")),
                      title = "Assessed Land Value, 2020", opacity = 0.7) %>%
            addLegend(values = ~estimate2009, colors = brewer.pal(7, "Greens"),
                      labels = paste0("up to $",
                                      prettyNum(format(breaks_qt2$brks[-1],
                                                       digits = 2 ),
                                                big.mark = ",")),
                      title = "Median Household Income, 2019", opacity = 0.7) %>%
            addLegend(pal = factpal2, values = parcels$DECODES2007,
                      title = "Land Use",
                      opacity = 0.7) #  %>%
            # addPolygons(data = bk_priority, group = "Priority Risky Locations",
            #             stroke = TRUE, fill = TRUE,
            #             opacity = 5,
            #             weight = 7,
            #             color = NA,
            #             fillOpacity = 6, fillColor = bk_priority)
    })


    # layer 1: assessed land value
    observe({

      leafletProxy("map", data = neighborhood()) %>%
        addPolygons(group = "Land Value",
                    stroke = TRUE, fill = TRUE,
                    color= NA, opacity = 5,
                    weight = 7,
                    fillOpacity = 6,
                    fillColor = ~rpal(neighborhood()$AssessLand2020),
                    popup = paste("Value: $",
                                  prettyNum(format(neighborhood()$AssessLand2020),
                                            big.mark = ","), "<br>"))
    })


    # layer 2: household income
    observe({

      leafletProxy("map", data = neighborhood()) %>%
        addPolygons(group = "Household Income",
                    stroke = TRUE, fill = TRUE,
                    color= NA, opacity = 5,
                    weight = 7,
                    fillOpacity = 6,
                    fillColor = ~gpal(neighborhood()$estimate2019),
                    popup = paste("Value: $",
                                  prettyNum(format(neighborhood()$estimate2019),
                                            big.mark = ","), "<br>"))
    })


    # #layer 3: Risky locations
    # # observe({
    # #
    # #   leafletProxy("map", data = priority()) %>%
    # #     #setView(lng = xy()[1], lat = xy()[2], zoom = 10) %>% #Lyndon's rec + my edits
    # #     addPolygons(group = "Risky locations", stroke = TRUE, fill = TRUE,
    # #                 opacity = 5,
    # #                 weight = 7,
    # #                 color = NA,
    # #                 fillOpacity = 6, fillColor = priority()$Name.y)
    # # })


    #layer 4: Land Use
    observe({
      leafletProxy("map", data = neighborhood()) %>%
        addPolygons(group = "Land Use",
                    stroke = TRUE, fill = TRUE,
                    color= NA, opacity = 5,
                    weight = 7,
                    fillOpacity = 6,
                    fillColor = factpal2(neighborhood()$DECODES2020),
                    popup = paste("Land Use Type: ",
                                  neighborhood()$DECODES2020, "<br>"))
    })


}






shinyApp(ui = ui, server = server)
