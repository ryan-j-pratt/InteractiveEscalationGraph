#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(tidyverse)
library(shiny)
library(rjson)
library(blsAPI)

# Load data ----

## Note: APIkey.R must be initialized first (creates variable APIkey with unique BLS registration key)

payload <- list(
  'seriesid'=c('PCU336411336411','PCU336510336510','PCU336110336110','PCU336611336611'),
  'startyear'=2002,
  'endyear'=2022,
  'annualaverage'=TRUE,
  'registrationKey'=APIkey
)
response <- blsAPI(payload,2)
json <- fromJSON(response)

planesdf <- apiDF(json$Results$series[[1]]$data)
trainsdf <- apiDF(json$Results$series[[2]]$data)
automobilesdf <- apiDF(json$Results$series[[3]]$data)
shipsdf <- apiDF(json$Results$series[[4]]$data)

# ui ----

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# server ----

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
