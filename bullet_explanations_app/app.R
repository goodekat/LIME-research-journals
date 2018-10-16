## The beginning of a Shiny app for visualizing the LIME explanations

# Load libraries
library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(lime)

# Input data
hamby224_test_explain <- readRDS("../data/hamby224_test_explain.rds")

# tiny1 <- data.frame(expand.grid(land1 = factor(1:6),
#                                land2 = factor(1:6), 
#                                bullet1 = factor(c("1", "2", "Q")),
#                                bullet2 = factor(c("1", "2", "Q"))))
# 
# tiny2 <- data.frame(expand.grid(land1 = factor(1:6),
#                                land2 = factor(1:6), 
#                                bullet1 = factor(c("1", "2", "I")),
#                                bullet2 = factor(c("1", "2", "I"))))
# 
# tiny <- rbind(tiny1, tiny2)
# 
# hamby224_test_explain <- left_join(tiny, hamby224_test_explain, by = c("land1", "land2", "bullet1", "bullet2"))

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
                verbatimTextOutput("click"),
                plotOutput("featureplot"),
                plotOutput("myfeatureplot")
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
    plot <- hamby224_test_explain %>%
      filter(set == chosen) %>%
      select(case, bullet1:land2, rfscore) %>%
      distinct() %>%
      mutate(rfscore = replace(rfscore, is.na(rfscore), -1)) %>%
      ggplot(aes(x = land1, y = land2, label = bullet1, label2 = bullet2, key = case)) +
      geom_tile(aes(fill = rfscore)) +
      facet_grid(bullet1 ~ bullet2) +
      theme_bw() +
      scale_fill_gradient2(low = "grey", high = "orange", midpoint = 0.5) +
      labs(x = "Land 1", y = "Land 2", fill = "RF Score", 
           title = paste0("Hamby 224 Data (", input$testset, ")"))
    
    ggplotly(plot, source = "tileplot")
    
  })

  output$click <- renderPrint({
    d <- event_data("plotly_click", source = "tileplot")
    if (is.null(d)) "nothing there" else d
  })
    
  # Create the feature plot
  output$featureplot <- renderPlot({
    
    s <<- event_data("plotly_click", source = "tileplot") 
    
    vars <- c(s[["x"]], s[["y"]])
    names(vars) <- c("land1", "land2")
    d <<- data.frame(land1 = vars[["land1"]], land2 = vars[["land2"]], case = s$key)
    
    # Grab the number of the chosen test set
    chosen = unlist(strsplit(input$testset, split = " "))[2]

    # Create the LIME features plot
    plot_features(hamby224_test_explain %>% filter(set == chosen, case == s$curveNumber))

  })
  
  # output$selection <- renderPrint({
  #   s <- event_data("plotly_click")
  #   cat("You selected: \n\n")
  #   data.frame(s)
  # })
  
  # Create my own feature plot
  output$myfeatureplot <- renderPlot({
    
    s <- event_data("plotly_click", source = "tileplot")
    
    # Grab the number of the chosen test set
    chosen = unlist(strsplit(input$testset, split = " "))[2]
    
    try <- hamby224_test_explain %>%
      filter(set == chosen) %>%
      slice(1:3) %>%
      mutate(feature_desc = reorder(feature_desc, as.numeric(feature_weight)),
             evidence = if_else(feature_weight >= 0, "Supports", "Contradicts"))
    
    tryinfo <- try %>% 
      slice(1) %>%
      select(study, set, bullet1, bullet2, land1, land2)
    
    ggplot(try, aes(x = feature_desc, y = feature_weight)) + 
      geom_col(aes(fill = evidence)) + 
      coord_flip() + 
      theme_minimal() +
      theme(legend.position = "bottom") +
      labs(x = "Feature Weight", y = "Feature Bin", fill = "Evidence:",
           title = paste0("Lime Explanation for \n", 
                          "   Study: ", tryinfo$study, "\n",
                          "   Set: ", tryinfo$set, "\n",
                          "   1st Bullet: ", tryinfo$bullet1, "\n",
                          "   Second Bullet: ", tryinfo$bullet2, "\n",
                          "   First Land: ", tryinfo$land1, "\n",
                          "   Second Land: ", tryinfo$land2, "\n"))
    
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
