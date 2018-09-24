## R Code for LIME Bullet Paper
## Purpose: creating images lime images
## Last updated: 2018/09/24

# Load libraries 
library(lime)
library(tidyverse)

## -----------------------------------------------------------------------
## Create the function for saving the figures
## -----------------------------------------------------------------------

# Function for creating and saving a lime plot_features plot for a specified case
plot_features_function <- function(case_number, explain, test_explain){
 
  # INPUTS:
  #   case_number - case number to create the plot for
  #   explain - a lime explain object
  #   test_explain - a dataframe of the joined test data and lime explain object
  
  # Subset the test_explain data frame to only case one row from the case of interest
  test_explain_sub <- test_explain %>% 
    filter(case == case_number) %>% 
    slice(1)
  
  # Create and save the image
  plot_features(explain %>% filter(case == case_number))
  ggsave(file = test_explain_sub$figure_file_location)
  
}

## -----------------------------------------------------------------------
## Load and prepare data
## -----------------------------------------------------------------------

# Read in the explanation object
hamby224_explain <- readRDS("./data/hamby224_explain.rds")

# Read in the combined test data and explanation object
hamby224_test_explain <- readRDS("./data/hamby224_test_explain.rds")

# Add a variable for the figure file location for each case
hamby224_test_explain <- hamby224_test_explain %>%
  mutate(figure_file_location = paste0("./figures/", study, "_testset", set, "_b", bullet1, 
                                       "_b", bullet2, "_land", land1, "_land", land2, ".png"))

# Save the updated version of the test_explain data
saveRDS(hamby224_test_explain, "./data/hamby224_test_explain.rds")

## -----------------------------------------------------------------------
## Create and save the images
## -----------------------------------------------------------------------

# Apply the plot_features_function to all of the cases in the Hamby 224 dataset
purrr::map(.x = 1:max(as.numeric(hamby224_test_explain$case)),
           .f = plot_features_function,
           explain = hamby224_explain,
           test_explain = hamby224_test_explain)
