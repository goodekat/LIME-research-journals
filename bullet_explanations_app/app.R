## The beginning of a Shiny app for visualizing the LIME explanations

# Load libraries
library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(lime)

# Input data
hamby224_test_explain <- readRDS("../data/hamby224_test_explain.rds")

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("LIME Explanations for Bullet Matching"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(h1("Test Datasets"),
          selectInput("testset", 
                      label = "Select a Hamby 224 test dataset", 
                      choices = c("Set 1", "Set 11"))
      ),
      
      # Show a plot of the generated distribution
      mainPanel(h1("Plots"),
                plotlyOutput("tileplot"),
                plotOutput("featureplot")
                )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Create the tile plot
  output$tileplot <- renderPlotly({
    
    # Grab the number of the chosen test set
    chosen = unlist(strsplit(input$testset, split = " "))[2]
    
    # Create a tile plot of the random forest predictions for all land comparisons
    hamby224_test_explain %>%
      filter(set == chosen) %>%
      select(case, bullet1:land2, rfscore) %>%
      distinct() %>%
      ggplot(aes(x = land1, y = land2)) +
      geom_tile(aes(fill = rfscore)) +
      facet_grid(bullet1 ~ bullet2) +
      theme_bw() +
      scale_fill_gradient2(low = "grey", high = "orange", midpoint = 0.5) +
      labs(x = "Land 1", y = "Land 2", fill = "RF Score", 
           title = paste0("Hamby 224 Data (", input$testset, ")"))
    
  })
  
  # Create the feature plot
  output$featureplot <- renderPlot({
    
    # Grab the number of the chosen test set
    chosen = unlist(strsplit(input$testset, split = " "))[2]

    # Create the LIME features plot
    plot_features(hamby224_test_explain %>% filter(set == chosen) %>% slice(1:3))

  })
    
}

# Run the application 
shinyApp(ui = ui, server = server)

# Example code (https://plot.ly/r/shinyapp-linked-click/)
# s <- event_data("plotly_click", source = "tileplot")
# if (length(s)) {
#   vars <- c(s[["x"]], s[["y"]])
#   d <- setNames(hamby224_test_explain[vars], c("x", "y"))
#   yhat <- fitted(lm(y ~ x, data = d))
#   plot_ly(d, x = ~x) %>%
#     add_markers(y = ~y) %>%
#     add_lines(y = ~yhat) %>%
#     layout(xaxis = list(title = s[["x"]]),
#            yaxis = list(title = s[["y"]]),
#            showlegend = FALSE)
# } else {
#   plotly_empty()
# }
