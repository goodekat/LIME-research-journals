## Purpose: Function for plotting probabilities vs. LIME perturbations
## Created: 2018/02/18
## Last Edited: 2018/02/28

# Load necessary libraries
library(tidyverse)
library(wesanderson)
library(cowplot)

# Function for plotting the probabilities
plot_probs <- function(train, response, perturb, explain, test_case, resp_category = NULL){
  
  # Use the case selector function to obtain the training data (with response) and 
  # perturbations that correspond to the test case of interest, the features 
  # selected by LIME, and response category of interest
  case_data <- case_selector(train, response, perturb, explain, 
                             test_case, resp_category)
  
  # Obtain names of the response variable and the wo most important variables chosen by 
  # LIME for the perturbation dataset
  Response <- names(case_data$sub_perturb)[1]
  ResponseSafe <- paste0("`",Response,"`")
  Var1 <- names(case_data$sub_perturb)[2]
  Var2 <- names(case_data$sub_perturb)[3]
  
  # Plot of probabilities vs feature 1 perturbations colored by prediction
  feature1 <- ggplot(case_data$sub_perturb, aes_string(x = Var1, y = ResponseSafe)) +
    geom_point(aes(alpha = Weight, color = Prediction)) +
    geom_point(data = case_data$sub_perturb[1,], 
                 aes_string(x = Var1, y = ResponseSafe, color = "Prediction"), 
                 size = 3, fill = "black", pch = 21) +
    scale_fill_manual(values = wes_palette("Darjeeling")) +
    scale_color_manual(values = wes_palette("Darjeeling")) + 
    labs(x = Var1, y = Response) +
    theme_bw()
  
  # Plot of probabilities vs feature 2 perturbations colored by prediction
  feature2 <- ggplot(case_data$sub_perturb, aes_string(x = Var2, y = ResponseSafe)) +
    geom_point(aes(color = Prediction, alpha = Weight)) +
    geom_point(data = case_data$sub_perturb[1,], 
               aes_string(x = Var2, y = ResponseSafe, color = "Prediction"), 
               size = 3, fill = "black", pch = 21) +
    scale_fill_manual(values = wes_palette("Darjeeling")) +
    scale_color_manual(values = wes_palette("Darjeeling")) + 
    labs(x = Var2, y = Response) +
    theme_bw()
  
  # Put the two plots in a grid and print
  print(plot_grid(feature1, feature2, labels = c("Feature 1", "Feature 2")))
  
}