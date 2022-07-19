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
#setwd(here("housing-justice/"))
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
    dashboardHeader(title = "Housing Justice"),
    dashboardSidebar(
        sidebarMenu(
            menuItem(selectInput("hood", "Select a neighborhood",
                                 choices = c("Select", unique(parcels$Hood)))
            )
            )
        ),
    dashboardBody(
        fluidRow(
            tabBox(
                id = "tabset1",
                tabPanel("2007", leafletOutput("map", height = "800px", width = "1000px")),
                tabPanel("2020", "placeholder for 2020 data")
            )
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
        w <- parcels %>% filter(Hood == input$hood)
        return(w)
        })

    priority <- reactive({
        w <- bk_priority %>% filter(Name.y == input$hood)
        return(w)
    })

    xy <- reactive({
        w <- st_coordinates(st_centroid(parcels %>% filter(Hood == input$hood)))
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

    # function for label

   #factpal <- colorFactor(topo.colors(12), parcels$DECODES2007)
    factpal2 <- colorFactor(palette = "RdYlBu", parcels$DECODES2007) # legend v.1



# output maps
    output$map <- renderLeaflet({


        leaflet() %>%
            addProviderTiles(providers$CartoDB.Positron) %>%
            setView(-73.93, 40.68, zoom = 11)  %>% # Zoom issue
            #setView(lng = xy()[1,1], lat = xy()[1,2], zoom = 14) %>% #Lyndon's rec + my edits
            addLayersControl(position = "bottomleft",
                overlayGroups = c("Land Value", "Household Income",
                                  "Risky locations", "Land Use"),
                options = layersControlOptions(collapsed = FALSE)
            ) %>%
            addLegend(values = ~AssessLand2007, colors = brewer.pal(5, "Reds"),
                      labels = paste0("up to ", format(breaks_qt1$brks[-1], digits = 2)),
                      title = "Assessed Land Value, 2007", opacity = 0.7
            ) %>%
            addLegend(values = ~estimate, colors = brewer.pal(7, "Greens"),
                      labels = paste0("up to $", format(breaks_qt2$brks[-1], digits = 2)),
                      title = "Median Household Income, 2009", opacity = 0.7
            ) %>%
            addLegend(pal = factpal2, values = parcels$DECODES2007,
                      title = "Land Use",
                      opacity = 0.7)
        })


    observe({

        leafletProxy("map", data = neighborhood()) %>%
           # setView(xy['X'], xy['Y'], zoom = 10) %>%
           # setView(lng = xy()[1,1], lat = xy()[1,2], zoom = 10) %>%
            addPolygons(group = "Land Value",
                        stroke = TRUE, fill = TRUE,
                        color= NA, opacity = 5,
                        weight = 7,
                        fillOpacity = 6, fillColor = ~rpal(neighborhood()$AssessLand2007),
                        popup = paste("Value: ", neighborhood()$AssessLand2007, "<br>")
            )
        })


    observe({

        leafletProxy("map", data = neighborhood()) %>%
           # setView(lng = xy()[1,1], lat = xy()[1,2], zoom = 10) %>%
                    addPolygons(group = "Household Income",
                    stroke = TRUE, fill = TRUE,
                    color= NA, opacity = 5,
                    weight = 7,
                    fillOpacity = 6, fillColor = ~gpal(neighborhood()$estimate),
                    popup = paste("Value: ", neighborhood()$estimate, "<br>")
        )
    })


    observe({

        leafletProxy("map", data = priority()) %>%
            addPolygons(group = "Risky locations", stroke = TRUE, fill = TRUE,
                        opacity = 5,
                        weight = 7,
                        color = NA,
                        fillOpacity = 6, fillColor = priority()$Name.y)
    })


    observe({

        # function for label

        factpal <- colorFactor(topo.colors(12), parcels$DECODES2007)

        # map
        leafletProxy("map", data = neighborhood()) %>%
            addPolygons(group = "Land Use",
                        stroke = TRUE, fill = TRUE,
                        color= NA, opacity = 5,
                        weight = 7,
                        fillOpacity = 6, fillColor = factpal2(neighborhood()$DECODES2007),
                        popup = paste("Land Use: ", neighborhood()$DECODES2007, "<br>")) #%>%
            #Commented this out to remove the extra "Land Use Types" in legend
            # addLegend(values = ~DECODES2007,
            #           pal = factpal,
            #           #labels = group_by(neighborhood()$DECODES2007),
            #           title = "Land Use types", opacity = 0.7)
    })

}






shinyApp(ui = ui, server = server)
