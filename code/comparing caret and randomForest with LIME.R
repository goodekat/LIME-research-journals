# Code for comparing the output from LIME when the model is 
# fit with caret and randomForest
# Last Updated: 2018/11/13

## Set up -----------------------------------------------------------------------------

# Load libraries
library(caret)
library(lime)
library(randomForest)

# Split up the data set
iris_test <- iris[1:5, 1:4]
iris_train <- iris[-(1:5), 1:4]
iris_lab <- iris[[5]][-(1:5)]

## LIME with caret --------------------------------------------------------------------

# Create Random Forest model on iris data
caret_model <- train(iris_train, iris_lab, method = 'rf')

# Create an explainer object
caret_explainer <- lime(iris_train, caret_model)

# Explain new observation
caret_explanation <- explain(iris_test, caret_explainer, n_labels = 1, n_features = 4)

# The output is provided in a consistent tabular format and includes the
# output from the model.
head(caret_explanation)

## LIME with randomForest -------------------------------------------------------------

rf_model <- randomForest(iris_train, iris_lab)

# Create an explainer object
rf_explainer <- lime(iris_train, model = as_classifier(rf_model))

# Explain new observation
rf_explanation <- explain(iris_test, rf_explainer, n_labels = 1, n_features = 4)

# The output is provided in a consistent tabular format and includes the
# output from the model.
head(rf_explanation)

## Comparisons -----------------------------------------------------------------------

# Grab the numeric caret explanation variables of interest
caret_numeric <- caret_explanation %>%
  select(model_r2, model_intercept, model_prediction, feature_value, feature_weight) %>%
  gather(key = "variable", value = "caret_value")

# Grab the numeric randomForest explanation variables of interest
rf_numeric <- rf_explanation %>%
  select(model_r2, model_intercept, model_prediction, feature_value, feature_weight) %>%
  gather(key = "variable", value = "rf_value")

# Join the two
lime_numeric <- caret_numeric %>%
  mutate(rf_value = rf_numeric$rf_value, 
         variable = factor(variable))

# Look at the MSEs for the variables
lime_numeric %>%
  group_by(variable) %>%
  summarise(MSE = sum((caret_value - rf_value)^2) / dim(lime_numeric)[1])

# Scatterplots of the randomForest versus caret variable values
ggplot(lime_numeric, aes(x = caret_value, y = rf_value)) + 
  geom_point() + 
  facet_wrap( ~ variable, scales = "free")
