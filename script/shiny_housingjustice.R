# Shiny dashboard
# Source 1. Basic Shiny language: https://www.youtube.com/watch?v=41jmGq7ALMY&ab_channel=Appsilon
# Source 2. Maps and Shiny: https://www.youtube.com/watch?v=eIpiL6y1oQQ&ab_channel=RockEDUScienceOutreach

# Set up
# create new directory for app
# have all maps created in advance. These will go in the server section.
# create leaflet maps of things we need to answer the question on housing justice

# data needs, 2007
# land use - For 2007: assessed value of land + lu_codes. 'bldg_desc_sp'. See: nyc_brooklyn_historicLU.R
# neighborhood change - capital investments? census, income information
# police presence - stop and frisk, or RTM



# Skeleton
library(shiny)
#install.packages("shinydashboard")
library(shinydashboard)
library(leaflet)

ui <- fluidPage(

  # Application title
  titlePanel("Housing Justice, 2007 - test"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      # sliderInput("bins",
      #             "Number of bins:",
      #             min = 1,
      #             max = 50,
      #             value = 30),

    ),

    # Specifies what to put in the main panel
    mainPanel(
      leafletOutput("map")  # Put one line of code here
    )
  )
)

server <- function(input, output){
# output$distPlot <- renderPlot({
#    # generate bins based on input$bins from ui.R
#    x    <- faithful[, 2]
#    bins <- seq(min(x), max(x), length.out = input$bins + 1)
#
#    # draw the histogram with the specified number of bins
#    hist(x, breaks = bins, col = 'darkgray', border = 'white')
# })

output$map <- renderLeaflet({
  # Put three lines of leaflet code here
  qpal <-  colorBin("Reds", parcels$AssessLand2007, bins = 5)
    leaflet(parcels) %>%
    addPolygons(stroke = TRUE, opacity = 1, fillOpacity = 0.5, smoothFactor = 0.5,
                color= NA, fillColor = ~qpal(AssessLand2007),weight = 1) %>%
    addLegend(values = ~AssessLand2007, pal = qpal,title = "Assessed Land Value, 2007")
})
}

# server <- function(input, output){
#   output$map_1 <- renderTmap({
#     tmap_mode("view")
#     tm_shape(brooklyn) +
#       tm_polygons(col = NA)  +
#       tm_shape(parcels) +
#       tm_polygons(col = "AssessLand2007", n = 5)  +
#       tm_layout(legend.outside = TRUE) +
#       tm_basemap(server = "OpenStreetMap", alpha = 0.7)
#   })
# }



shinyApp(ui, server)
