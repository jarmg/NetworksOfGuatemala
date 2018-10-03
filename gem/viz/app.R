library(shiny)

source("gem_stats.r")
data <- load_data()

unique(data$EDUC_LEVEL)

ui <- fluidPage(
  titlePanel("Hello world"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId='bins',
                  label = "Number of bins:",
                  min=1,
                  max=500,
                  value=10),
    checkboxGroupInput(inputId = 'educ', 
                       label= "Highest Education Level",
                       choices = sort(unique(data$EDUC_LEVEL)))
    ),
    mainPanel(
      plotOutput(outputId = 'distPlot')
    )
  )
)


server <- function(input, output) {
  output$distPlot <- renderPlot({
    bins <- seq(min(0), max(1000), length.out = input$bins + 1)
    cell_payments_by_eth(data, input$bins, input$educ)
   
     
    #hist(x, breaks = bins, col = '#75AADB', border = 'white',
     #    xlab = "Waiting time to next eruption",
      #   main = "Histogram of wait times")
  })
}

shinyApp(ui = ui, server = server)
