library(shiny)

source("gem_stats.r")
data <- load_data()

ui <- fluidPage(
  titlePanel("Hello world"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId='bins',
                  label = "Number of bins:",
                  min=1,
                  max=500,
                  value=10)
    ),
    mainPanel(
      plotOutput(outputId = 'distPlot')
    )
  )
)



server <- function(input, output) {
  head(data)
  data$PAY_CELL)
  output$distPlot <- renderPlot({
    bins <- seq(min(0), max(1000), length.out = input$bins + 1)
    cell_payments_by_eth(data, input$bins)
   
     
    #hist(x, breaks = bins, col = '#75AADB', border = 'white',
     #    xlab = "Waiting time to next eruption",
      #   main = "Histogram of wait times")
  })
}

shinyApp(ui = ui, server = server)
