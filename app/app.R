## Shiny app for visualizing the LIME explanations for the bullet comparisons

# Load libraries
library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(plotly)
library(cowplot)
library(gridExtra)

## ------------------------------------------------------------------------------------
## Data Steps
## ------------------------------------------------------------------------------------

# Input data
hamby224_test <- read.csv("../data/hamby224_test.csv")
hamby224_test_explain <- readRDS("../data/hamby224_test_explain.rds")
hamby224_bins <- readRDS("../data/hamby224_bins.rds")
hamby224_lime_inputs <- readRDS("../data/hamby224_lime_inputs.rds")

## ------------------------------------------------------------------------------------
## Functions
## ------------------------------------------------------------------------------------

# Function for creating a table with the bin information relating to specified features
bin_table <- function(features, case, bin_cuts){
  
  # Subset the bin cuts table to the selected feature
  selected_bin_cuts <- bin_cuts[[case]] %>% 
    filter(Feature %in% features) %>%
    mutate(Feature = factor(Feature, levels = features)) %>%
    arrange(Feature)
  
  # Return the bin dataframe
  return(selected_bin_cuts)
  
}

## ------------------------------------------------------------------------------------
## UI Setup
## ------------------------------------------------------------------------------------

# Layout of the app
ui <- fluidPage(
  
  # Application title
  titlePanel("LIME Explanations for Bullet Matching"),
  
  # fluidRow(column(width = 12,
  #                 checkboxInput("limeoptions", "Show LIME Input Options", value = FALSE))),
  
  # Row for input options
  fluidRow(column(width = 6,
                  fluidRow(column(width = 6,
                                  selectInput("set", 
                                              label = "Select a Hamby 224 dataset", 
                                              choices = c("Set 1", "Set 11")),
                                  conditionalPanel(
                                    condition = "input.density == 'Bins'",
                                    selectInput('bintype',
                                                label = "Select the bin type for LIME", 
                                                choices =  c("Equally Spaced Bins",
                                                             "Quantile Bins"),
                                                selected = "Equally Spaced Bins"))),
                           column(width = 6,
                                  selectInput("density", 
                                              label = "Select density estimation method for LIME", 
                                              choices = c("Bins", "Kernel Density", "Normal Approximation"),
                                              selected = "Bins"),
                                  conditionalPanel(
                                    condition = "input.density == 'Bins'",
                                    selectInput("nbins", 
                                                label = "Select the number of bins for LIME", 
                                                choices = 2:6,
                                                selected = 3)))),
                  plotlyOutput("tileplot")),
          
           column(width = 6,
                  plotOutput("featureplot", height = 550, width = 600),
                  tableOutput("bintable")))
   
)

## ------------------------------------------------------------------------------------
## Server Setup
## ------------------------------------------------------------------------------------

# Create the plots to include in the app
server <- function(input, output) {
  
  # Tile plot output --------------------------------------------------------------------
  
  # Set a reactive value for putting a mark on the heatmap after a click 
  tileplot_mark <- reactiveValues(location = NULL)
  
  # Create the tile plot
  output$tileplot <- renderPlotly({
      
      # Create a tile plot of the random forest predictions
      plot <- hamby224_test %>%
        filter(set == paste("Set", unlist(strsplit(input$set, split = " "))[2])) %>%
        mutate(rfscore = round(rfscore, 3)) %>%
        ggplot(aes(x = land1, y = land2, label = bullet1, label2 = bullet2,
                   text = paste('Bullets Compared: ', bullet1, "-", land1, 
                                "vs", bullet2, "-", land2,
                                '\nRandom Forest Score: ', 
                                ifelse(is.na(rfscore), "Missing due to tank rash", rfscore)))) +
        geom_tile(aes(fill = rfscore)) +
        facet_grid(bullet2 ~ bullet1, scales = "free") +
        theme_minimal() +
        scale_fill_gradient2(low = "darkgrey", high = "darkorange", midpoint = 0.5, limits = c(0, 1)) +
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
          
      } 
      
      # Make the plot interactive
      ggplotly(plot, source = "tileplot", width = 700, height = 550, tooltip = "text") %>%
        style(hoverinfo = "skip", traces = 7) %>% 
        config(displayModeBar = FALSE)
  
  })
  
  # Feature plot output -----------------------------------------------------------------
  
  # Create a dataset with the connection between the curveNumbers and the bullet facets
  bullet_locations <- data.frame(curveNumber = 0:5,
                                 bullet1 = c("Known 1", "Known 1", "Known 2", 
                                             "Known 1", "Known 2", "Questioned"),
                                 bullet2 = c("Known 1", "Known 2", "Known 2", 
                                             "Questioned", "Questioned", "Questioned"))
  
  # Set an x-axis limit for feature plot
  xlimit <- max(abs(hamby224_test_explain$feature_weight), na.rm = TRUE)
  
  # Create my own feature plot
  output$featureplot <- renderPlot({
    
    # Obtain the click data
    click_data <- event_data("plotly_click", source = "tileplot")
    
    # Create the feature plot if there is click data
    if(length(click_data)){
      
      # Create the feature plot if the rfscore is not NA
      if(!is.na(click_data$z)){

        # Create a dataset with the location of cell that was clicked
        location <- data.frame(land1 = paste("Land", click_data$x), 
                               land2 = paste("Land", click_data$y),
                               bullet_locations %>% 
                                 filter(curveNumber == click_data$curveNumber))
        
        # Save the locations to use for the reactive mark on the tileplot
        tileplot_mark$location <- location
        
        # Grab the chosen input options
        chosen_set <- paste("Set", unlist(strsplit(input$set, split = " "))[2])
        if (input$density == "Kernel Density") {
          chosen_bins <- FALSE
          chosen_estimator <- TRUE
          chosen_bintype <- TRUE
          chosen_nbins <- 4
        } else if (input$density == "Normal Approximation") {
          chosen_bins <- FALSE
          chosen_estimator <- FALSE
          chosen_bintype <- TRUE
          chosen_nbins <- 4
        } else {
          chosen_bins <- TRUE
          chosen_estimator <- TRUE
          chosen_bintype <- ifelse(input$bintype == "Quantile Bins", TRUE, FALSE)
          chosen_nbins <- input$nbins
        }
        
        # Create a dataset with the feature information for the selected comparison
        selected_comparison <- hamby224_test_explain %>%
          filter(set == chosen_set,
                 bin_continuous == chosen_bins,
                 quantile_bins == chosen_bintype,
                 nbins == chosen_nbins,
                 use_density == chosen_estimator,
                 land1 == as.character(location$land1),
                 land2 == as.character(location$land2),
                 bullet1 == location$bullet1,
                 bullet2 == location$bullet2) %>%
          mutate(feature = reorder(feature, abs(as.numeric(feature_weight))),
                 feature_bin = reorder(feature_bin, abs(as.numeric(feature_weight))),
                 evidence = factor(if_else(feature_weight >= 0, 
                                           "Supports Same Source", "Supports Different Source"), 
                  levels = c("Supports Different Source", "Supports Same Source")))
         
        # Select the x-axis for the feature plot based on the density estimation selection
        if (chosen_bins == TRUE) {
          xaxis <- "feature_bin"
        } else {
          xaxis <- "feature"
        }
        
        # Create the feature plot (x axis based on binning or not)
        feature_plot <- ggplot(selected_comparison, aes_string(x = xaxis)) + 
          geom_col(aes(fill = evidence, y = abs(feature_weight))) +
          ylim(0, xlimit) +
          coord_flip() +
          theme_minimal() +
          theme(legend.position = "none") +
          labs(y = "Feature Effect Size", x = "Feature", fill = "") +
          scale_fill_manual(values = c("Supports Same Source" = "darkorange", 
                                       "Supports Different Source" = "darkgrey"),
                            drop = FALSE)
        
        # Create a title
        title <- ggdraw() + draw_label("Top Three Features Chosen by LIME for the Selected Prediction",
                                       hjust = 0,
                                       x = 0,
                                       fontface = "bold")
        
        # Create a data frame with the appropriate labels to use in the subtitle
        labels <- selected_comparison %>% 
          slice(1) %>%
          select(study, set, bullet1, bullet2, land1, land2, 
                 rfscore, model_r2, model_prediction, model_intercept)
        
        # Create a subtitle
        subtitle <- ggdraw() + 
          draw_label(paste("Study: ", labels$study, labels$set,
                           "\nBullets Compared: ", labels$bullet1, "-", labels$land1, " vs ", labels$bullet2, "-", labels$land2,
                           "\nRandom Forest Probability of a Match: ", round(labels$rfscore, 3),
                           "\nSimple Model Probability of a Match: ", round(labels$model_prediction, 3),
                           "\nSimple Model R2: ", round(labels$model_r2, 3),
                           "\nSimple Model Intercept: ", round(labels$model_intercept, 3)),
                     hjust = 0,
                     x = 0)
        
        # Create a legend
        legend <- get_legend(feature_plot + theme(legend.position = "bottom"))
        
        # Create a grid of plotting components
        plot_grid(title, subtitle, feature_plot, legend, ncol = 1, 
                  rel_heights = c(0.05, 0.2, 0.6, 0.1))
        
        
      } else{
        
        # Print a black plot
        ggplot() + geom_blank() + theme_classic()
        
      }
      
    } else{
      
      # Print a black plot
      ggplot() + geom_blank() + theme_classic()
      
    }
    
  })
  
  # Bin table output --------------------------------------------------------------------
  output$bintable <- renderTable({
    
    # Obtain the click data
    click_data <- event_data("plotly_click", source = "tileplot")
    
    if(length(click_data)){
      
      if(!is.na(click_data$z)){
            
        # Grab the chosen input options
        chosen_set <- paste("Set", unlist(strsplit(input$set, split = " "))[2])
        if (input$density == "Kernel Density") {
          chosen_bins <- FALSE
          chosen_estimator <- TRUE
          chosen_bintype <- TRUE
          chosen_nbins <- 4
        } else if (input$density == "Normal Approximation") {
          chosen_bins <- FALSE
          chosen_estimator <- FALSE
          chosen_bintype <- TRUE
          chosen_nbins <- 4
        } else {
          chosen_bins <- TRUE
          chosen_estimator <- TRUE
          chosen_bintype <- ifelse(input$bintype == "Quantile Bins", TRUE, FALSE)
          chosen_nbins <- input$nbins
        }
        
        # Create a dataset with the location of cell that was clicked
        location <- data.frame(land1 = paste("Land", click_data$x), 
                               land2 = paste("Land", click_data$y),
                               bullet_locations %>% 
                                 filter(curveNumber == click_data$curveNumber))
    
        # Create a dataset with the feature information for the selected comparison
        selected_features <- hamby224_test_explain %>%
          filter(set == chosen_set,
                 bin_continuous == chosen_bins,
                 quantile_bins == chosen_bintype,
                 nbins == chosen_nbins,
                 use_density == chosen_estimator,
                 land1 == as.character(location$land1),
                 land2 == as.character(location$land2),
                 bullet1 == location$bullet1,
                 bullet2 == location$bullet2) %>%
          arrange(desc(abs(feature_weight))) %>%
          select(feature, feature_weight, feature_value)
        
        # Determine the case based on the number of bins
        case <- hamby224_lime_inputs %>%
          filter(bin_continuous == chosen_bins,
                 quantile_bins == chosen_bintype,
                 nbins == chosen_nbins,
                 use_density == chosen_estimator) %>%
          pull(case)
        
        # Create a table with the observed data and bins if necessary
        if (chosen_bins == TRUE){
          bin_table(features = selected_features$feature, 
                    case = case,
                    bin_cuts = hamby224_bins) %>%
            mutate("Observed Value" = selected_features$feature_value) %>%
            select(Feature, "Observed Value", "Lower Bin":"Upper Bin")
        } else {
          data.frame(Features = selected_features$feature,
                     "Observed Value" = selected_features$feature_value)
        } 
        
      }
      
    }
    
  }, align = "r", spacing = "xs")
    
}

## ------------------------------------------------------------------------------------
## Run the application
## ------------------------------------------------------------------------------------

# Run the application 
shinyApp(ui = ui, server = server)
