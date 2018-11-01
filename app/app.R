## Shiny app for visualizing the LIME explanations for the bullet comparisons

# Load libraries
library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(plotly)
library(cowplot)

## ------------------------------------------------------------------------------------
## Data Steps
## ------------------------------------------------------------------------------------

# Input data
hamby224_test_explain <- readRDS("../data/hamby224_test_explain.rds") 

## ------------------------------------------------------------------------------------
## UI Setup
## ------------------------------------------------------------------------------------

# Layout of the app
ui <- fluidPage(
   
   # Application title
   titlePanel("LIME Explanations for Bullet Matching"),
   
   # Set selector
   fluidRow(column(3, selectInput("set", 
                        label = "Select a Hamby 224 dataset", 
                        choices = c("Set 1", "Set 11")))),

   # Panel for plots
   fluidRow(column(6, plotlyOutput("tileplot")),
            column(6, plotOutput("featureplot")))
   
)

## ------------------------------------------------------------------------------------
## Server Setup
## ------------------------------------------------------------------------------------

# Create the plots to include in the app
server <- function(input, output) {
  
  # Set a reactive value for putting a mark on the heatmap after a click
  tileplot_mark <- reactiveValues(location = NULL)
  
  # Create the tile plot
  output$tileplot <- renderPlotly({
    
    # Grab the number of the chosen set
    chosen_set <- paste("Set", unlist(strsplit(input$set, split = " "))[2])
    
    # Create a tile plot of the random forest predictions
    plot <- hamby224_test_explain %>%
      filter(set == chosen_set) %>%
      mutate(rfscore = round(rfscore, 3)) %>%
      select(case, bullet1, bullet2, land1, land2, rfscore) %>%
      distinct() %>%
      ggplot(aes(x = land1, y = land2, label = bullet1, label2 = bullet2,
                 text = paste('Bullets Compared: ', bullet1, "-", land1, 
                              "vs", bullet2, "-", land2,
                              '\nRandom Forest Score: ', 
                              ifelse(is.na(rfscore), "Missing due to tank rash", rfscore)))) +
      geom_tile(aes(fill = rfscore)) +
      facet_grid(bullet2 ~ bullet1, scales = "free") +
      theme_minimal() +
      scale_fill_gradient2(low = "darkgrey", high = "darkorange", midpoint = 0.5) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      labs(x = "", y = "", fill = "RF Score", 
           title = paste0("Hamby 224 Data (", input$set, ")")) 
      
    # If a tile has been clicked, add an 'x' to the tile
    if(length(tileplot_mark$location)){
      
      # Add the mark to the plot
      plot <- plot + geom_text(data = data.frame(land1 = as.character(tileplot_mark$location$land1), 
                                                 land2 = as.character(tileplot_mark$location$land2),
                                                 bullet1 = tileplot_mark$location$bullet1, 
                                                 bullet2 = tileplot_mark$location$bullet2, 
                                                 rfscore = NA), 
                       aes(label = "x"))
      
      # Make the plot interactive
      ggplotly(plot, source = "tileplot", width = 700, height = 550, tooltip = "text")
      
    } else {
      
      # Make the plot interactive
      ggplotly(plot, source = "tileplot", width = 700, height = 550, tooltip = "text")
    
      }
    
  })
  
  # Obtain the xlimits
  xlimit1 <- max(abs(hamby224_test_explain$feature_weight), na.rm = TRUE)
  
  # Create my own feature plot
  output$featureplot <- renderPlot({
    
    # Grab the number of the chosen set
    chosen_set <- paste("Set", unlist(strsplit(input$set, split = " "))[2])
    
    # Obtain the click data
    click_data <- event_data("plotly_click", source = "tileplot")
    
    # Create the feature plot if there is click data
    if(length(click_data)){
      
      # Create the feature plot if the rfscore is not NA
      if(!is.na(click_data$z)){
        
        # Create a dataset with the connection between the curveNumbers and the bullet facets
        bullet_locations <- data.frame(curveNumber = 0:5,
                                       bullet1 = c("Known 1", "Known 1", "Known 2", "Known 1", "Known 2", "Questioned"),
                                       bullet2 = c("Known 1", "Known 2", "Known 2", "Questioned", "Questioned", "Questioned"))
        
        # Create a dataset with the location of cell that was clicked
        location <- data.frame(land1 = paste("Land", click_data$x), 
                               land2 = paste("Land", click_data$y),
                               bullet_locations %>% filter(curveNumber == click_data$curveNumber))
        
        # Save the locations to use for the reactive mark on the tileplot
        tileplot_mark$location <- location
        
        # Create a dataset with the feature information for the selected comparison
        selected_comparison <- hamby224_test_explain %>%
          filter(set == chosen_set,
                 land1 == as.character(location$land1),
                 land2 == as.character(location$land2),
                 bullet1 == location$bullet1,
                 bullet2 == location$bullet2) %>%
          mutate(feature_bin = reorder(feature_bin, abs(as.numeric(feature_weight))),
                 evidence = factor(if_else(feature_weight <= 0, "Supports Same Source", "Supports Different Source"), 
                                   levels = c("Supports Different Source", "Supports Same Source")))
        
        # Create a data frame with the appropriate labels
        labels <- selected_comparison %>% 
          slice(1) %>%
          select(study, set, bullet1, bullet2, land1, land2, rfscore)
        
        # Grab the observed predictor values for the case of interest
        case_data <- selected_comparison %>%
          select(feature, feature_weight, feature_value) %>%
          mutate(feature_value = round(feature_value, 3),
                 feature = reorder(feature, -abs(as.numeric(feature_weight)))) %>%
          select(-feature_weight) %>%
          spread(key = feature, value = feature_value)
        
        # Create the feature plot
        feature_plot <- ggplot(selected_comparison, aes(x = feature_bin, y = abs(feature_weight))) +
          geom_col(aes(fill = evidence)) +
          ylim(0, xlimit1) +
          coord_flip() +
          theme_minimal() +
          theme(legend.position = "none") +
          labs(y = "Feature Magnitude (Absolute Value of Ridge Regression Coefficient)", x = "Feature", fill = "") +
          scale_fill_manual(values = c("Supports Same Source" = "darkorange", "Supports Different Source" = "darkgrey"),
                            drop = FALSE)
        
        # Create a title
        title <- ggdraw() + draw_label("Top Three Features Chosen by LIME for the Selected Prediction",
                                       hjust = 0,
                                       x = 0,
                                       fontface = "bold")
        
        # Create a subtitle
        subtitle <- ggdraw() + draw_label(paste("Study: ", labels$study, labels$set,
                                                "\nBullets Compared: ", labels$bullet1, "-", labels$land1, " vs ", labels$bullet2, "-", labels$land2,
                                                "\nRandom Forest Score: ", round(labels$rfscore, 3),
                                                "\n\nObserved Variable Values:", 
                                                "\n", names(case_data)[1], " = ", case_data[,1],
                                                "\n", names(case_data)[2], " = ", case_data[,2],
                                                "\n", names(case_data)[3], " = ", case_data[,3]),
                                           hjust = 0,
                                           x = 0)
        
        # Create a legend
        legend <- get_legend(feature_plot + theme(legend.position = "bottom"))
        
        # Create a grid of plotting components
        plot_grid(title, subtitle, feature_plot, legend, ncol = 1, rel_heights = c(0.1, 0.4, 1))
        
      } else{
        
        # Print a black plot
        ggplot() + geom_blank() + theme_classic()
        
      }
      
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
