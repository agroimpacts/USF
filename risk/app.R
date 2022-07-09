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

setwd(here("risk/"))
bk07crime <- readRDS("bk07crime.RDS")
rtm <- readRDS("rtm.RDS")
parcels <- readRDS("parcels.RDS")



ui <- fluidPage(
    titlePanel("Deconstructing risk for property crime in BK, 2007 - test"),

    sidebarLayout(
        sidebarPanel(
        h5("Risk locations are defined by XYZ. Not all places are equally
               risky through out the day."),
        verticalLayout("Risky locations for that hour of day",
                       tableOutput(outputId = "hist"))
        ),
        mainPanel(
            sliderInput("range", "Select an hour of the day to begin",
                        min = min(bk07crime$HourFormat),
                        max = max(bk07crime$HourFormat),
                        value = min(bk07crime$HourFormat),
                        step = 1,
                        animate = animationOptions(interval = 1000, loop = FALSE)),
            leafletOutput("map")
        )
    ))


server <- function(input, output) {

    hourofday <- reactive({
        h <- bk07crime %>% filter(HourFormat == input$range)
        return(h)
    })

    output$map <- renderLeaflet({
      #  hourofday() %>%
        leaflet() %>%
            addProviderTiles(providers$CartoDB.Positron) %>%
            setView(-73.95, 40.66, zoom = 11) #%>%
            # addPolygons(stroke = TRUE, fill = TRUE,
            #     color= NA, opacity = 5,
            #     weight = 7,
            #     fillOpacity = 6, fillColor = parcels$DECODES2007) %>%
            # addLayersControl(
            #     overlayGroups =  "Land Use",
            #     options = layersControlOptions(collapsed = FALSE))
    })

    observe({
        leafletProxy("map", data = hourofday()) %>%
            clearShapes() %>%
            addCircles(radius = 2, weight = 5, color = "#5310c4",
                       fillOpacity = 0.05, opacity = 0.17,
                       stroke = TRUE)

    })

    output$hist <- renderTable({

        rtm %>% filter(HourFormat == input$range) %>%
            filter(!PREM_TYP_DESC == "STREET") %>%
            filter(!PREM_TYP_DESC %in% NA) %>%
            filter(!PREM_TYP_DESC == "") %>%
            group_by(.$PREM_TYP_DESC) %>%
            count() %>% # frequency per group
            rename(., RTMfactors = ".$PREM_TYP_DESC", Count = "n") %>%
            as_tibble() %>% arrange(-Count)


    })

}

shinyApp(ui = ui, server = server)
