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
library(sp)
library(sf)
library(shinydashboard)
library(here)
library(leaflet)
library(RColorBrewer)
library(leaflet.extras)

setwd(here("risk/"))
bk07crime <- readRDS("bk07crime.RDS")
rtm <- readRDS("rtm.RDS")
bk_priority <- readRDS("bk_priority.RDS")
bk07heat <- readRDS("bk07heat.RDS")
bk07table <- readRDS("bk07table.RDS")


# ui <- fluidPage(
#     titlePanel("Deconstructing risk for property crime in BK, 2007 - test"),
#
#     sidebarLayout(
#         sidebarPanel(
#         h5("Risk locations are defined by XYZ. Not all places are equally
#                risky through out the day."),
#         verticalLayout("Risky locations for that hour of day",
#                        tableOutput(outputId = "hist"))
#         ),
#         mainPanel(
#           fluidRow(sliderInput("range", "Select an hour of the day to begin",
#                                min = min(bk07crime$HourFormat),
#                                max = max(bk07crime$HourFormat),
#                                value = min(bk07crime$HourFormat),
#                                step = 1,
#                                animate = animationOptions(interval = 1000, loop = FALSE)),
#                    leafletOutput("map")),
#           fluidRow(" Heat Maps"),
#
#           fluidRow(
#             splitLayout((leafletOutput("map2")),
#                         "heatmap table placeholder"))
#           )
#
#         )
#     )


# Using shinydashboard

ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = "Deconstructing risk",
                  titleWidth = 350),
  dashboardSidebar(
    h5("This dashboard shows data for Brooklyn, 2007. Source: NYC Open Data"),
    h5("According to the National Institute of Justice,
        property crime contemplates:
          + burglary

          - theft

          - vandalism

          - arson."),
    h5("Based on this classification, we created a property crime variable using
        Historic crime dataset for NYC."),
    h5("Risk locations are defined by XYZ. Not all places are equally
       risky through out the day"),
    width = 350,
    menuItem(sliderInput("range", "Select an hour of the day to begin",
                         min = min(bk07crime$HourFormat),
                         max = max(bk07crime$HourFormat),
                         value = min(bk07crime$HourFormat),
                         step = 1,
                         animate = animationOptions(interval = 1000, loop = FALSE))
    ),
    menuSubItem("Data Sources"),
    menuSubItem(
      "Historic crime data",
      href = "https://data.cityofnewyork.us/Public-Safety/NYPD-Complaint-Data-Historic/qgea-i56i"
    )
  ),
  dashboardBody(
    tags$head(tags$style(HTML('
      .main-header .logo {
        font-family: "Arial", serif;
        font-weight: bold;
        font-size: 24px;
      }
    '))),
    fluidRow(
      box(leafletOutput("map")),
      box(tableOutput(outputId = "hist"))
    ),
    fluidRow(
      box(leafletOutput("map2")),
      box (plotOutput(outputId = "heatable"), height = 450)
    )
  )
)




server <- function(input, output) {

    hourofday <- reactive({
        h <- bk07crime %>% filter(HourFormat == input$range)
        return(h)
    })

    heat <- reactive({
      h <- bk07heat %>% filter(HourFormat == input$range)
      return(h)
    })


    output$map <- renderLeaflet({
        leaflet() %>%
            addProviderTiles(providers$CartoDB.Positron) %>%
            setView(-73.95, 40.66, zoom = 11) %>%
        addLayersControl(position = "bottomleft",
            overlayGroups = c("Risky locations"),
            options = layersControlOptions(collapsed = FALSE)
            )
      })

    observe({
        leafletProxy("map", data = hourofday()) %>%
            clearShapes() %>%
            addCircles(radius = 2, weight = 5, color = "#5310c4",
                       fillOpacity = 0.05, opacity = 0.17,
                       stroke = TRUE)

    })


    observe({

      leafletProxy("map", data = bk_priority) %>%
        addPolygons(group = "Risky locations", stroke = TRUE, fill = TRUE,
                    opacity = 5,
                    weight = 7,
                    color = NA,
                    fillOpacity = 6, fillColor = bk_priority)
    })

    output$map2 <- renderLeaflet({
      # heat() %>%
      leaflet() %>%
        addProviderTiles(providers$CartoDB.Positron) %>%
        setView(-73.95, 40.66, zoom = 11)
     })

    observe({
      leafletProxy("map2", data = heat()) %>%
        addHeatmap(
          lng = ~long, lat = ~lat, intensity = 2,
          blur = 20, max = 0.05, radius = 5,
         # gradient = "RdPu"
        )


    })



    output$hist <- renderTable({

        rtm %>% filter(HourFormat == input$range) %>%
            filter(!PREM_TYP_DESC == "STREET") %>%
            filter(!PREM_TYP_DESC %in% NA) %>%
            filter(!PREM_TYP_DESC == "") %>%
            group_by(.$PREM_TYP_DESC) %>%
            count() %>% # frequency per group
            rename(., RTMfactors = ".$PREM_TYP_DESC", Count = "n") %>%
            as_tibble() %>% arrange(-Count) %>% slice(1:12)


    })


    output$heatable <- renderPlot({
      col <- colorRampPalette(brewer.pal(9, "YlOrRd"))(256)
      bk07table %>% as.matrix() %>%
      heatmap(., col = col, Rowv = NA, Colv = NA)
    })

}

shinyApp(ui = ui, server = server)
