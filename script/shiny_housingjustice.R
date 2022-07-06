#census data - household income

antes que nada, preload data on USF

# Shiny dashboard
# Source: https://www.youtube.com/watch?v=41jmGq7ALMY&ab_channel=Appsilon

library(shiny)
#install.packages("shinydashboard")
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Housing Justice - test"),
  dashboardSidebar(), # on the left
  dashboardBody(
    box(plotOutput("map_1"), width = 8) # add box to dashboard
  )
)

server <- function(input, output){
  output$map_1 <- renderPlot({
    # plot function
  })
}

shinyApp(ui, server)
