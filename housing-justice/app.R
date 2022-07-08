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
#names(providers)
setwd(here("housing-justice/"))
parcels <- readRDS("parcels.RDS")
bk_priority <- readRDS("bk_priority.RDS")
#income_2009 <- readRDS("income_2009.RDS")

ui <- fluidPage(
    # Application title
    titlePanel("Housing Justice, 2007 - test"),
    # Sidebar with data input
    sidebarLayout(
        sidebarPanel(
        h5("Lorem ipsum dolor sit amet, consectetur adipiscing elit,
           sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.


           + Land Value is based on the Assessor's appraisal for the city of NY.
           Data source: PLUTO.


           + Income is based on acs5 census data for 2009.
           Aggregate data per census tract.


           + Policing: either stop and frisk, or rtm file/priority places."),

    selectInput("hood",
                "Select a neighborhood",
                choices = c("Select", unique(parcels$Hood))),
# selectInput("landuse",
#             "Select a type of land use",
#                choices = c("Select", unique(parcels$DECODES2007)))
),
                    # Specifies what to put in the main panel
        mainPanel(
            tabsetPanel(
            tabPanel("Land Value", leafletOutput("landvalue")),
            tabPanel("Household income", leafletOutput("income")),
            tabPanel("Policing/police violence", leafletOutput("risk"))
        )
    )
)
)

server <- function(input, output) {



    output$landvalue <- renderLeaflet({

        neighborhood <- reactive({ # reacts to user input/choice
            w <- parcels %>% filter(Hood == input$hood) #select(., contains(input$year))#
            return(w)
        })

    library(classInt)
    breaks_qt <- classIntervals(parcels$AssessLand2007, n = 5, style = "quantile")
    br <- breaks_qt$brks
    qpal <-  colorQuantile("Reds", parcels$AssessLand2007, n = 5)
    neighborhood() %>%
 #       filter(DECODES2007 == input$landuse)%>%
        leaflet() %>%
        addProviderTiles(providers$CartoDB.Positron) %>%
        setView(-73.95, 40.7, zoom = 10) %>%
        addPolygons(stroke = TRUE, fill = TRUE,
                    color= NA, opacity = 5,
                    weight = 7,
                    fillOpacity = 6, fillColor = ~qpal(neighborhood()$AssessLand2007),
                    popup = paste("Value: ", neighborhood()$AssessLand2007, "<br>"),
        ) %>%
        addProviderTiles(providers$CartoDB.Positron) %>%
        addLegend(values = ~AssessLand2007, colors = brewer.pal(5, "Reds"),
                  labels = paste0("up to ", format(breaks_qt$brks[-1], digits = 2)),
                  title = "Assessed Land Value, 2007"
        )
    })

    output$income <- renderLeaflet({

        neighborhood <- reactive({ # reacts to user input/choice
            w <- parcels %>% filter(Hood == input$hood) #select(., contains(input$year))#
            return(w)
        })

    library(classInt)
    breaks_qt <- classIntervals(parcels$estimate, n = 7, style = "quantile")
    br <- breaks_qt$brks
    qpal <-  colorQuantile("Greens", parcels$estimate, n = 7)
    neighborhood() %>%
    #    filter(DECODES2007 == input$landuse)%>%
        leaflet() %>%
        addProviderTiles(providers$CartoDB.Positron) %>%
        setView(-73.95, 40.7, zoom = 10) %>%
        addPolygons(stroke = TRUE, fill = TRUE,
                    color= NA, opacity = 5,
                    weight = 7,
                    fillOpacity = 6, fillColor = ~qpal(neighborhood()$estimate),
                    popup = paste("Value: ", neighborhood()$estimate, "<br>"),
        ) %>%
        addLegend(values = ~estimate, colors = brewer.pal(7, "Greens"),
                  labels = paste0("up to ", format(breaks_qt$brks[-1], digits = 2)),
                  title = "Median Household Income, 2009"
        )
    })

    output$risk <- renderLeaflet({

        neighborhood <- reactive({ # reacts to user input/choice
            w <- bk_priority %>% filter(Name.y == input$hood) #select(., contains(input$year))#
            return(w)
        })
        neighborhood() %>%
            leaflet() %>%
            addProviderTiles(providers$CartoDB.Positron) %>%
            setView(-73.95, 40.7, zoom = 10) %>%
                   addPolygons(stroke = TRUE, fill = TRUE,
                        color= NA, opacity = 5,
                        weight = 7,
                        fillOpacity = 6, fillColor = neighborhood()$Name.y,
            ) %>%
            addProviderTiles(providers$CartoDB.Positron)
    })



}


shinyApp(ui = ui, server = server)
