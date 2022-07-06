# Shiny dashboard
# Source 1. Basic Shiny language: https://www.youtube.com/watch?v=41jmGq7ALMY&ab_channel=Appsilon
# Source 2. Maps and Shiny: https://www.youtube.com/watch?v=eIpiL6y1oQQ&ab_channel=RockEDUScienceOutreach

# Preparation: have all maps created in advance. These will go in the server section.
# create new directory for app

# Skeleton
library(shiny)
#install.packages("shinydashboard")
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Housing Justice - test"),
  dashboardSidebar(), # on the left
  dashboardBody(
    box(plotOutput("map_1"), width = 8), # add box to dashboard
    box(
      selectInput("features", "Features:",
                  c("DayFormat", "HourFormat")), width = 4
    )
  )
)

server <- function(input, output){
  output$map_1 <- renderPlot({
    ggplot() +
      geom_point(data = heatmap07, aes(x = long, y = lat), alpha = .05) # plot function. if statit
    # ggplot() +
    #   geom_point(data = heatmap07[[input$Features]], aes(x = long, y = lat), alpha = .05) # plot function. interactive
    })
}

shinyApp(ui, server)
