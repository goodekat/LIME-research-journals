## Purpose: Function for plotting LIME perturbations
## Created: 2018/02/13
## Last Edited: 2018/03/01

# Load necessary libraries
library(tidyverse)
library(wesanderson)
library(cowplot)

# Function for plotting the perturbations
plot_perturbs <- function(train, response, perturb, explain, test_case, 
                         resp_category = NULL, separate = TRUE){
  
  # Use the case selector function to obtain the training data (with response) and 
  # perturbations that correspond to the test case of interest, the features 
  # selected by LIME, and response category of interest
  case_data <- case_selector(train, response, perturb, explain, test_case, resp_category)
  
  # Obtain names of two most important variables chosen by lime for the
  # perturbation dataset
  Var1 <- names(case_data$sub_perturb)[2]
  Var2 <- names(case_data$sub_perturb)[3]
  
  # Plot of the perturbations for the two chosen variables colored by prediction
  # with alpha value based on weight
  perturb_plot <- ggplot(case_data$sub_perturb, aes_string(x = Var1, y = Var2)) + 
    geom_point(aes(color = Prediction, alpha = Weight)) +
    geom_point(data = case_data$sub_perturb[1,], 
               aes_string(x = Var1, y = Var2, color = "Prediction"), 
               size = 3, fill = "black", pch = 21) +
    scale_color_manual(values = wes_palette("Darjeeling")) +
    scale_fill_manual(values = wes_palette("Darjeeling")) +
    labs(x = Var1, y = Var2) +
    theme_bw()
  
  # Plot of raw data for the two chosen variables colored by response
  raw_plot <- ggplot(data = case_data$sub_train, aes_string(x = Var1, y = Var2)) +
    geom_point(aes(fill = response), color = "black", size = 3, pch = 21) + 
    geom_point(data = case_data$sub_perturb[1,], 
               aes_string(x = Var1, y = Var2, color = "Prediction"), 
               size = 3, fill = "black", pch = 21) +
    scale_color_manual(values = wes_palette("Darjeeling")) +
    scale_fill_manual(values = wes_palette("Darjeeling")) +
    labs(x = Var1, y = Var2) +
    theme_bw()
  
  # Plot of perturbations and raw data for the two chosen variables colored
  # by prediction and response, respectively
  both_plot <- ggplot(case_data$sub_perturb, aes_string(x = Var1, y = Var2)) + 
    geom_point(aes(color = Prediction, alpha = Weight)) +
    geom_point(data = case_data$sub_train, 
               aes_string(x = Var1, y = Var2, fill = "response"),
               color = "black", size = 3, pch = 21) +
    geom_point(data = case_data$sub_perturb[1,], 
               aes_string(x = Var1, y = Var2, color = "Prediction"), 
               size = 3, fill = "black", pch = 21) +
    scale_color_manual(values = wes_palette("Darjeeling")) +
    scale_fill_manual(values = wes_palette("Darjeeling")) +
    labs(x = Var1, y = Var2) +
    theme_bw()
  
  # Determine final plot to print based on whether the raw data and 
  # perturbations were selected to be plotted together or separately 
  if (separate == TRUE) {
    plot = plot_grid(perturb_plot, raw_plot, labels = c("Perturbations", "Raw Data"))
  } else {
    plot = both_plot
  }
  
  # Print the selected plot
  print(plot)
  
}
