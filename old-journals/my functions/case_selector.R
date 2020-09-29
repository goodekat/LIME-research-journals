## Purpose: Function for selecting training data and explanations for 
##          a specified test case
## Created: 2018/02/13
## Last Edited: 2018/02/13

# Load necessary libraries
library(tidyverse)

# Function for selecting training data and explanations for a specific test case
case_selector <- function(train, response, perturb, explain, test_case, 
                          resp_category = NULL){
  
  # Select only the rows of features for the test case of interest
  sub_explain <- explain %>% 
    filter(case == test_case, label == resp_category)
  
  # Select variables chosen by LIME from the training data
  sub_train <- train %>%
    select(sub_explain$feature)
  
  # Add the response variable to the sub_train data frame
  sub_train$response <- response
  
  # Subset the perturbations based on the testing point and grab selected 
  # features, predictions, weights, and prediction probability
  sub_perturb <- perturb %>%
    filter(Test_Case == test_case) %>%
    select(resp_category, sub_explain$feature, Prediction, Weight)
  
  # Put the sub training and perturbation data is a list to return
  return(list(sub_train = sub_train, sub_perturb = sub_perturb))
  
}
