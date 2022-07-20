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
#names(providers)
setwd(here("housing-justice/"))
parcels <- readRDS("parcels.RDS")
bk_priority <- readRDS("bk_priority.RDS")

## regular dashboard

# ui <- fluidPage(
#     titlePanel("Housing Justice, 2007 - test"),
#     sidebarLayout(
#         sidebarPanel(
#         h5("Lorem ipsum dolor sit amet, consectetur adipiscing elit,
#            sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
#
#
#            + Land Value is based on the Assessor's appraisal for the city of NY.
#            Data source: PLUTO.
#
#
#            + Income is based on acs5 census data for 2009.
#            Aggregate data per census tract.
#
#
#            + Policing: either stop and frisk, or rtm file/priority places."),
#
#     selectInput("hood",
#                 "Select a neighborhood",
#                 choices = c("Select", unique(parcels$Hood)))
#         ),
#     mainPanel(leafletOutput("map", height = "600px", width = "700px"))
#         )
#  )

## using shinydashboard

ui <- dashboardPage(
    skin = "purple",
    dashboardHeader(title = "Housing Justice"),
    dashboardSidebar(
        h5("
        Land Value is based on the Assessor's appraisal for the city of NY.
           Data source: PLUTO "),
        h5("
        Income is based on acs5 census data for 2009.
        Aggregate data per census tract."),
        h5("
        Risky locations are the outputs of an RTM analysis based on
           historic crime data for NYC."),
        width = 350,
        sidebarMenu(
            menuItem(selectInput("nhood", "Select a neighborhood",
                                 choices = c("Select", unique(parcels$NHood)))
            ),
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
            tabBox(
                width = 500,
                id = "tabset1",
                tabPanel("2007", background = "maroon", leafletOutput("map", height = "700px")), #, height = "700px", width = "700px"
                tabPanel("2020", "placeholder for 2020 data")
             )#,
            # box("text, something about housing,
            #       + Land Value is based on the Assessor's appraisal for the city of NY. Data source: PLUTO")
            #,
            # tabBox(
            #     title = "2020 data",
            #     id = "tabset2",
            #     tabPanel("2020", leafletOutput("map", height = "800px", width = "1000px"))
            )
            #,
          #box(leafletOutput("map", height = "800px", width = "1000px"))
          )
    )




server <- function(input, output) {

# reactive functions - defined by user input
    neighborhood <- reactive({
        w <- parcels %>% filter(NHood == input$nhood)
        return(w)
        })

    priority <- reactive({
        w <- bk_priority %>% filter(Name.y == input$nhood)
        return(w)
    })

    xy <- reactive({
       # w <- st_coordinates(st_centroid(parcels %>% filter(Hood == input$nhood)))
        w <- st_bbox(parcels %>% filter(NHood == input$nhood))
        return(w)
    })

# functions to format the legend
    library(classInt)
    breaks_qt1 <- classIntervals(parcels$AssessLand2007, n = 5, style = "quantile")
    br <- breaks_qt1$brks
    rpal <-  colorQuantile("Reds", parcels$AssessLand2007, n = 5)
    breaks_qt2 <- classIntervals(parcels$estimate, n = 7, style = "quantile")
    br <- breaks_qt2$brks
    gpal <-  colorQuantile("Greens", parcels$estimate, n = 7)
    factpal2 <- colorFactor(palette = "RdYlBu", parcels$DECODES2007)


# output maps
    output$map <- renderLeaflet({

    # basemap
        leaflet() %>%
            addProviderTiles(providers$CartoDB.Positron) %>%
            setView(-73.93, 40.68, zoom = 12)  %>% # Zoom issue
            #setView(lng = xy()[1], lat = xy()[2], zoom = 10) %>% #Lyndon's rec + my edits
            addLayersControl(position = "bottomleft",
                overlayGroups = c("Land Value", "Household Income",
                                  "Risky locations", "Land Use"),
                options = layersControlOptions(collapsed = FALSE)
            ) %>%
            addLegend(values = ~AssessLand2007, colors = brewer.pal(5, "Reds"),
                      labels = paste0("up to $",
                                      prettyNum(format(breaks_qt1$brks[-1],
                                                       digits = 7),
                                                big.mark = ",")),
                      title = "Assessed Land Value, 2007", opacity = 0.7
            ) %>%
            addLegend(values = ~estimate, colors = brewer.pal(7, "Greens"),
                      labels = paste0("up to $",
                                      prettyNum(format(breaks_qt2$brks[-1],
                                                       digits = 2 ),
                                                big.mark = ",")),
                      title = "Median Household Income, 2009", opacity = 0.7
            ) %>%
            addLegend(pal = factpal2, values = parcels$DECODES2007,
                      title = "Land Use",
                      opacity = 0.7)
        })

    # layer 1: assessed land value
    observe({

        leafletProxy("map", data = neighborhood()) %>%
            #setView(lng = xy()[1], lat = xy()[2], zoom = 10) %>% #Lyndon's rec + my edits
            #setView(lng = xy()[1,1], lat = xy()[1,2], zoom = 10) %>%
            addPolygons(group = "Land Value",
                        stroke = TRUE, fill = TRUE,
                        color= NA, opacity = 5,
                        weight = 7,
                        fillOpacity = 6, fillColor = ~rpal(neighborhood()$AssessLand2007),
                        popup = paste("Value: $",
                                      prettyNum(format(neighborhood()$AssessLand2007),
                                                big.mark = ","), "<br>")
            )
        })

    # layer 2: household income
    observe({

        leafletProxy("map", data = neighborhood()) %>%
            #setView(lng = xy()[1], lat = xy()[2], zoom = 10) %>% #Lyndon's rec + my edits
            addPolygons(group = "Household Income",
                    stroke = TRUE, fill = TRUE,
                    color= NA, opacity = 5,
                    weight = 7,
                    fillOpacity = 6, fillColor = ~gpal(neighborhood()$estimate),
                    popup = paste("Value: $",
                                  prettyNum(format(neighborhood()$estimate),
                                                        big.mark = ","), "<br>"))
    })

    #layer 3: Risky locations
    observe({

        leafletProxy("map", data = priority()) %>%
            #setView(lng = xy()[1], lat = xy()[2], zoom = 10) %>% #Lyndon's rec + my edits
                        addPolygons(group = "Risky locations", stroke = TRUE, fill = TRUE,
                        opacity = 5,
                        weight = 7,
                        color = NA,
                        fillOpacity = 6, fillColor = priority()$Name.y)
    })

    #layer 4: Land Use
    observe({

        leafletProxy("map", data = neighborhood()) %>%
            #setView(lng = xy()[1], lat = xy()[2], zoom = 10) %>% #Lyndon's rec + my edits
                        addPolygons(group = "Land Use",
                        stroke = TRUE, fill = TRUE,
                        color= NA, opacity = 5,
                        weight = 7,
                        fillOpacity = 6, fillColor = factpal2(neighborhood()$DECODES2007),
                        popup = paste("Land Use: ", neighborhood()$DECODES2007, "<br>"))
    })

}






shinyApp(ui = ui, server = server)
