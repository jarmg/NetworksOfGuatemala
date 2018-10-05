library(shiny)

source("/home/jared/Guatemala/NetworksOfGuatemala/gem/gem_stats.R")
gemData <- load_data()

unique(gemData$EDUC_LEVEL)

ui <- fluidPage(
  div(
    img(src = 'ufm_logo.png', height = 100)
  ),
  sidebarLayout(
    sidebarPanel(
    checkboxGroupInput(inputId = 'eth', 
                       label= "Ethnicity of respondent",
                       choices = sort(unique(gemData$ETHNICITY)),
                       selected = c('Indígena (Maya)', 
                                 'No indígena (ladino)')
                       ),
    checkboxGroupInput(inputId = 'edu', 
                       label= "Education level of respondent",
                       choices = sort(unique(gemData$EDUC_LEVEL)),
                       selected = c(1, 5, 9),
                       inline = TRUE
    ),
    sliderInput('range',
                label = "Choose a monthly payment range",
                min = 0, max = 1000, value = c(0,1000))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Ethnicity", plotOutput(outputId = 'ethPlot')),
        tabPanel("Education", plotOutput(outputId = 'eduPlot'))
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
}

shinyApp(ui = ui, server = server)
