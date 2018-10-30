## Shiny app for visualizing the LIME explanations for the bullet comparisons

# Load libraries
library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(plotly)
library(lime)
library(cowplot)
library(grDevices)

## ------------------------------------------------------------------------------------
## Data steps
## ------------------------------------------------------------------------------------

# Input data
hamby224_test_explain <- readRDS("../data/hamby224_test_explain.rds")

# Create a dataset with all combinations of lands and bullets comparisons for each set
combinations1 <- data.frame(set = factor(1),
                    expand.grid(land1 = factor(1:6),
                                land2 = factor(1:6),
                                bullet1 = factor(c("1", "2", "Q")),
                                bullet2 = factor(c("1", "2", "Q"))))
combinations11 <- data.frame(set = factor(11),
                    expand.grid(land1 = factor(1:6),
                                land2 = factor(1:6), 
                                bullet1 = factor(c("1", "2", "I")),
                                bullet2 = factor(c("1", "2", "I"))))
combinations <- rbind(combinations1, combinations11)

# Join the combinations and the data so that all combinations have a row in the data
hamby224_test_explain_NAs <<- left_join(combinations, hamby224_test_explain,
                                       by = c("set", "land1", "land2", "bullet1", "bullet2")) %>%
  mutate(bullet1 = forcats::fct_recode(bullet1, "Known 1" = "1", "Known 2" = "2", 
                                       "Questioned" = "Q", "Questioned" = "I"),
         bullet2 = forcats::fct_recode(bullet2, "Known 1" = "1", "Known 2" = "2", 
                                       "Questioned" = "Q", "Questioned" = "I"),
         rfscore = round(rfscore, 3),
         feature_magnitude = feature_weight * feature_value)

## ------------------------------------------------------------------------------------
## UI setup
## ------------------------------------------------------------------------------------

ui <- fluidPage(
   
   # Application title
   titlePanel("LIME Explanations for Bullet Matching"),
   
   fluidRow(column(3, selectInput("testset", 
                        label = "Select a Hamby 224 dataset", 
                        choices = c("Set 1", "Set 11")))),

   fluidRow(column(6, plotlyOutput("tileplot")),
            column(6, plotOutput("featureplot")))
   
  )

## ------------------------------------------------------------------------------------
## Server setup
## ------------------------------------------------------------------------------------

server <- function(input, output) {
  
  # Create the tile plot
  output$tileplot <- renderPlotly({
    
    # Grab the number of the chosen test set
    chosen_set = unlist(strsplit(input$testset, split = " "))[2]
    
    # Create a tile plot of the random forest predictions for all land comparisons
    plot <- hamby224_test_explain_NAs %>%
      filter(set == chosen_set,
             !(bullet1 == "Questioned" & bullet2 == "Known 1"),
             !(bullet1 == "Questioned" & bullet2 == "Known 2"),
             !(bullet1 == "Known 2" & bullet2 == "Known 1")) %>%
      select(case, bullet1, bullet2, land1, land2, rfscore) %>%
      distinct() %>%
      ggplot(aes(x = land1, y = land2, label = bullet1, label2 = bullet2,
                 text = paste('Bullets Compared: ', bullet1, "- Land ", land1, "vs", bullet2, "- Land", land2,
                              '\nRandom Forest Score: ', ifelse(is.na(rfscore), "Missing due to tank rash", rfscore)))) +
      geom_tile(aes(fill = rfscore)) +
      facet_grid(bullet2 ~ bullet1, scales = "free") +
      theme_minimal() +
      scale_fill_gradient2(low = "darkgrey", high = "darkorange", midpoint = 0.5) +
      labs(x = "Land 1", y = "Land 2", fill = "RF Score", 
           title = paste0("Hamby 224 Data (", input$testset, ")"))
    
    ggplotly(plot, source = "tileplot", width = 700, height = 550, tooltip = "text")
    
  })
  
  # Obtain the xlimits
  xlimit1 <- max(abs(hamby224_test_explain_NAs$feature_weight), na.rm = TRUE)
  xlimit2 <- max(abs(hamby224_test_explain_NAs$feature_magnitude), na.rm = TRUE)
  
  # Create my own feature plot
  output$featureplot <- renderPlot({
    
    # Obtain the click data
    click_data <<- event_data("plotly_click", source = "tileplot")
    
    if(length(click_data) > 0){
      
      if(!is.na(click_data$z)){
        
        # Obtain the number of the chosen test set
        chosen_set <<- unlist(strsplit(input$testset, split = " "))[2]
      
        # Create a dataset with the connection between the curveNumbers and the bullet facets
        bullet_locations <- data.frame(set = rep(c("1", "11"), each = 6),
                                       curveNumber = rep(0:5, 2),
                                       bullet1 = c("Known 1", "Known 1", "Known 2", "Known 1", "Known 2", "Questioned"),
                                       bullet2 = c("Known 1", "Known 2", "Known 2", "Questioned", "Questioned", "Questioned"))
        
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
          mutate(feature = reorder(feature, abs(as.numeric(feature_weight))),
                 evidence = factor(if_else(feature_weight >= 0, "Supports Same Source", "Supports Different Source"), 
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
        feature_plot <- ggplot(selected_comparison, aes(x = feature, y = abs(feature_weight))) +
          geom_col(aes(fill = evidence)) +
          ylim(0, xlimit1) +
          coord_flip() +
          theme_minimal() +
          theme(legend.position = "none") +
          labs(y = "Feature Magnitude (Absolute Value of Ridge Regression Coefficient)", x = "Feature", fill = "") +
          scale_fill_manual(values = c("Supports Same Source" = "darkorange", "Supports Different Source" = "darkgrey"),
                            drop = FALSE)
        
        # p2 <- ggplot(selected_comparison, aes(x = feature_desc, y = feature_magnitude)) + 
        #   geom_col(aes(fill = evidence)) +
        #   ylim(-xlimit2, xlimit2) +
        #   coord_flip() + 
        #   theme_minimal() +
        #   theme(legend.position = "none") +
        #   labs(y = "Feature Magnitude", x = "Feature Bin", fill = "") +
        #   scale_fill_manual(values = c("Supports Same Source" = "darkorange", "Supports Different Source" = "darkgrey"),
        #                     drop = FALSE)
        
        # Create a title
        title <- ggdraw() + draw_label("Top Three Features Chosen by LIME for the Selected Prediction",
                                       hjust = 0,
                                       x = 0,
                                       fontface = "bold")
        
        # Create a subtitle
        subtitle <- ggdraw() + draw_label(paste("Study: ", labels$study, " Set ", labels$set,
                                                "\nBullets Compared: ", labels$bullet1, " - Land ", labels$land1, " vs ", labels$bullet2, " - Land ", labels$land2,
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
        # p <- plot_grid(p1, p2, ncol = 1)
        # plot_grid(title, subtitle, p, legend, ncol = 1, rel_heights = c(0.1, 0.4, 1))
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
