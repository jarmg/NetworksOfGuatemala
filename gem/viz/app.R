library(shiny)
library(shinythemes)


source("/home/jared/Guatemala/NetworksOfGuatemala/gem/gem_stats.R")
gemData <- load.gem.data()

ui <- fluidPage(theme = shinytheme("united"),
  div(
    img(src = 'ufm_logo.png', height = 100)
  ),
  sidebarLayout(
    sidebarPanel (
      conditionalPanel(
        condition = "input.tabPanel == 'Ethnicity'",
        checkboxGroupInput(inputId = 'eth',
                           label= "Ethnicity of respondent",
                           choices = levels(gemData$ethnicity),
                           selected = levels(gemData$ethnicity)[2:3]
        )
      ),
      conditionalPanel(
        condition = "input.tabPanel == 'Education'",
        checkboxGroupInput(inputId = 'edu',
                           label= "Education level of respondent",
                           choices = sort(unique(gemData$educLevel)),
                           selected = c(1, 5, 9),
                           inline = TRUE
        )
      ),
      sliderInput('range',
                  label = "Choose a monthly payment range",
                  min = 0, max = 1000, value = c(0,1000))
      ),
      mainPanel(
        tabsetPanel(id = 'tabPanel',
          tabPanel("Ethnicity", plotOutput(outputId = 'ethPlot')),
          tabPanel("Education", plotOutput(outputId = 'eduPlot')),
          tabPanel("Startup Analysis", verbatimTextOutput(outputId = 'regOutput'))
        )
      )
    )
  )

server <- function(input, output) {
  output$ethPlot <- renderPlot({
    cell_payments_by_eth(gemData, input$eth, input$range)
  })
  output$eduPlot <- renderPlot({
    cell_payments_by_edu(gemData, input$edu, input$range)
  })
  output$regOutput <- renderPrint({
    summary(run.model.startBiz())
  })
}

shinyApp(ui = ui, server = server)
