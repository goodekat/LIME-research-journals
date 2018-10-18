## The beginning of a Shiny app for visualizing the LIME explanations

# Load libraries
library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(lime)

## ------------------------------------------------------------------------------------
## Data steps
## ------------------------------------------------------------------------------------

# Input data
hamby224_test_explain <<- readRDS("../data/hamby224_test_explain.rds")

# Create a dataset with all combinations of lands and bullets comparisons for each set
combs1 <- data.frame(set = factor(1),
                    expand.grid(land1 = factor(1:6),
                                land2 = factor(1:6),
                                bullet1 = factor(c("1", "2", "Q")),
                                bullet2 = factor(c("1", "2", "Q"))))
combs11 <- data.frame(set = factor(11),
                    expand.grid(land1 = factor(1:6),
                                land2 = factor(1:6), 
                                bullet1 = factor(c("1", "2", "I")),
                                bullet2 = factor(c("1", "2", "I"))))
combs <- rbind(combs1, combs11)

# Join the combinations and the data so that all combinations have a row in the data
hamby224_test_explain_NAs <<- left_join(combs, hamby224_test_explain,
                                       by = c("set", "land1", "land2", "bullet1", "bullet2"))

## ------------------------------------------------------------------------------------
## UI setup
## ------------------------------------------------------------------------------------

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("LIME Explanations for Bullet Matching"),
   
   fluidRow(column(3, selectInput("testset", 
                        label = "Select a Hamby 224 dataset", 
                        choices = c("Set 1", "Set 11")))),
   
   # fluidRow(column(3, selectInput("testset", 
   #                                label = "Select a Hamby 224 test dataset", 
   #                                choices = c("Set 1", "Set 11"))),
   #          column(3, verbatimTextOutput("click"))),
   
   fluidRow(column(6, plotlyOutput("tileplot")),
            column(6, plotOutput("featureplot")))
   
  )

## ------------------------------------------------------------------------------------
## Server setup
## ------------------------------------------------------------------------------------

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Create the tile plot
  output$tileplot <- renderPlotly({
    
    # Grab the number of the chosen test set
    chosen_set = unlist(strsplit(input$testset, split = " "))[2]
    
    # Create a tile plot of the random forest predictions for all land comparisons
    plot <- hamby224_test_explain_NAs %>%
      filter(set == chosen_set) %>%
      select(case, bullet1, bullet2, land1, land2, rfscore) %>%
      distinct() %>%
      ggplot(aes(x = land1, y = land2, label = bullet1, label2 = bullet2)) +
      geom_tile(aes(fill = rfscore)) +
      facet_grid(bullet1 ~ bullet2) +
      theme_bw() +
      scale_fill_gradient2(low = "grey", high = "orange", midpoint = 0.5) +
      labs(x = "Land 1", y = "Land 2", fill = "RF Score", 
           title = paste0("Hamby 224 Data (", input$testset, ")"))
    
    ggplotly(plot, source = "tileplot", width = 700, height = 550)
    
  })
  
  # # Print the values of the event data
  # output$click <- renderPrint({
  #   
  #   # Obtain the click data
  #   click_data <- event_data("plotly_click", source = "tileplot")
  #   
  #   # Print selected comparison
  #   if(length(click_data) > 0) click_data else "nothing selected"
  # 
  # })
  
  # Create my own feature plot
  output$featureplot <- renderPlot({
    
    # Obtain the click data
    click_data <<- event_data("plotly_click", source = "tileplot")
    
    if(length(click_data) > 0){
      
      # Obtain the number of the chosen test set
      chosen_set = unlist(strsplit(input$testset, split = " "))[2]
      
      # Create a dataset with the connection between the curveNumbers and the bullet facets
      bullet_locations <- data.frame(set = rep(c("1", "11"), each = 9),
                                     curveNumber = rep(0:8, 2),
                                     bullet1 = c(rep(c("1", "2", "Q"), 3), 
                                                 rep(c("1", "2", "I"), 3)),
                                     bullet2 = c(rep(c("1", "2", "Q"), each = 3), 
                                                 rep(c("1", "2", "I"), each = 3)))
      
      # Create a dataset with the location of cell that was clicked
      location <- data.frame(land1 = click_data$x, 
                             land2 = click_data$y,
                             bullet_locations %>% 
                               filter(set == chosen_set, 
                                      curveNumber == click_data$curveNumber))
      
      # Create a dataset with the feature information for the selected comparison
      selected_comparison <- hamby224_test_explain_NAs %>%
        filter(set == chosen_set, 
               land1 == location$land1, 
               land2 == location$land2,
               bullet1 == location$bullet1,
               bullet2 == location$bullet2) %>%
        slice(1:3) %>%
        mutate(feature_desc = reorder(feature_desc, as.numeric(feature_weight)),
               evidence = if_else(feature_weight >= 0, "Supports", "Contradicts"))
      
      labels <- selected_comparison %>% 
        slice(1) %>%
        select(study, set, bullet1, bullet2, land1, land2)
      
      ggplot(selected_comparison, aes(x = feature_desc, y = feature_weight)) + 
        geom_col(aes(fill = evidence)) + 
        coord_flip() + 
        theme_minimal() +
        theme(legend.position = "bottom") +
        labs(y = "Feature Weight", x = "Feature Bin", fill = "Evidence:",
             title = paste0("Lime Explanation for \n", 
                            "   Study: ", labels$study, "\n",
                            "   Set: ", labels$set, "\n",
                            "   1st Bullet: ", labels$bullet1, "\n",
                            "   Second Bullet: ", labels$bullet2, "\n",
                            "   First Land: ", labels$land1, "\n",
                            "   Second Land: ", labels$land2, "\n"))
      
    } else{
      
      # Print a black plot
      ggplot() + geom_blank() + theme_classic()
      
    }
    
  }, height = 500, width = 600)
    
}

## ------------------------------------------------------------------------------------
## Run the application
## ------------------------------------------------------------------------------------

# Run the application 
shinyApp(ui = ui, server = server)
