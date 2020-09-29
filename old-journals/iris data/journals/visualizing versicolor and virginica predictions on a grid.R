## Purpose: Visualize predictions from the iris data for versicolor and virginica and
##          compare to LIME explanations
## Created: 2018/01/14
## Last Edited: 2018/01/14

# Load libraries
library(caret)
library(lime)
library(tidyverse)

# Split up iris data set into training and testing data
iris_test <- iris[c(58, 70, 106, 119, 124), 1:4]
iris_train <- iris[-c(58, 70, 106, 119, 124), 1:4]
iris_lab <- iris[[5]][-c(58, 70, 106, 119, 124)]

## --------------------------------------------------------------------------------
## Model with only 2 predictors
## --------------------------------------------------------------------------------

# Select only petal width and sepal width from the training data
iris_train_subset <- iris_train %>%
  select(Petal.Width, Sepal.Width)

# Select only petal width and sepal width from the testing data
iris_test_subset <- iris_test %>%
  select(Petal.Width, Sepal.Width)

# Fit a random forest to the subset data
rf_model_subset <- train(iris_train_subset, iris_lab, method = 'rf')

# Scatterplot of petal width versus sepal width colored by species with testing 
# points in black
ggplot(iris_train_subset, aes(x = Petal.Width, y = Sepal.Width)) + 
  geom_point(aes(color = iris_lab)) +
  geom_point(data = iris_test_subset, aes(x = Petal.Width, y = Sepal.Width))

# Create a sequence of values for the x axis
x_min <- min(iris_train$Petal.Width)
x_max <- max(iris_train$Petal.Width)
x_axis <- seq(from = x_min, to = x_max, by = 0.05)

# Create a sequence of values for the y axis
y_min <- min(iris_train$Sepal.Width)
y_max <- max(iris_train$Sepal.Width)
y_axis <- seq(from = y_min, to = y_max, by = 0.05)

# Create a grid of the x and y axis values
grid_subset <- expand.grid(x_axis, y_axis)

# Rename the data set and change the variable names
iris_grid_subset <- grid_subset %>%
  rename(Petal.Width = Var1, 
         Sepal.Width = Var2)

# Make predictions for all of the values in the grid 
predictions_subset <- predict(rf_model_subset, iris_grid_subset)

# Add predictions to dataset
iris_grid_subset$Pred <- predictions_subset

# Plot the prediction regions, the training data colored by species, 
# and the testing data in black
ggplot(iris_grid_subset, aes(x = Petal.Width, y = Sepal.Width)) +
  geom_tile(aes(fill = Pred), alpha = 0.4) +
  geom_point(data = iris_train_subset, aes(x = Petal.Width, y = Sepal.Width, color = iris_lab)) +
  geom_point(data = iris_test_subset, aes(x = Petal.Width, y = Sepal.Width))

# Run the lime function on the subset iris data and random forest model
lime_subset <- lime(iris_train_subset, rf_model_subset, bin_continuous = TRUE, n_bins = 4, quantile_bins = TRUE)

# Run the explain function for data frames on the subset iris data
explanation_subset <- explain(iris_test_subset, lime_subset, 
                              n_labels = 1, n_features = 2)

# Sometimes I get this error and then have to reinstall lime from github and the way the 
# code is written, I don't understand why this is happening:
# Error in UseMethod("explain") : 
# no applicable method for 'explain' applied to an object of class "data.frame"

# Plot the explanations
plot_features(explanation_subset)

## --------------------------------------------------------------------------------
## Model with all 4 predictors
## --------------------------------------------------------------------------------

# Random forest model run on the iris data
rf_model <- train(iris_train, iris_lab, method = 'rf')

# Plots of the training data colored by species with the testing data in black
ggplot(iris_train, aes(x = Petal.Width, y = Sepal.Width)) + 
  geom_point(aes(color = iris_lab)) +
  geom_point(data = iris_test, aes(x = Petal.Width, y = Sepal.Width))

ggplot(iris_train, aes(x = Petal.Width, y = Sepal.Length)) + 
  geom_point(aes(color = iris_lab)) +
  geom_point(data = iris_test, aes(x = Petal.Width, y = Sepal.Length))

ggplot(iris_train, aes(x = Petal.Length, y = Sepal.Width)) + 
  geom_point(aes(color = iris_lab)) +
  geom_point(data = iris_test, aes(x = Petal.Length, y = Sepal.Width))

ggplot(iris_train, aes(x = Petal.Length, y = Sepal.Length)) + 
  geom_point(aes(color = iris_lab)) +
  geom_point(data = iris_test, aes(x = Petal.Length, y = Sepal.Length))

# Create a sequence of values for PW
PW_min <- min(iris_train$Petal.Width)
PW_max <- max(iris_train$Petal.Width)
PW_axis <- seq(from = PW_min, to = PW_max, by = 0.5)

# Create a sequence of values for SW
SW_min <- min(iris_train$Sepal.Width)
SW_max <- max(iris_train$Sepal.Width)
SW_axis <- seq(from = SW_min, to = SW_max, by = 0.5)

# Create a sequence of values for PL
PL_min <- min(iris_train$Petal.Length)
PL_max <- max(iris_train$Petal.Length)
PL_axis <- seq(from = PL_min, to = PL_max, by = 0.5)

# Create a sequence of values for SL
SL_min <- min(iris_train$Sepal.Length)
SL_max <- max(iris_train$Sepal.Length)
SL_axis <- seq(from = SL_min, to = SL_max, by = 0.5)

# Create a grid of the x and y axis values
grid <- expand.grid(PW_axis, SW_axis, PL_axis, SL_axis)

# Rename dataset and variables
iris_grid <- grid %>%
  rename(Petal.Width = Var1, 
         Sepal.Width = Var2,
         Petal.Length = Var3,
         Sepal.Length = Var4)

# Make predictions at all points in the grid
predictions <- predict(rf_model, iris_grid)

# Add the predictions to the dataset
iris_grid$Pred <- predictions

# Run the lime function on the iris data and random forest model
lime <- lime(iris_train, rf_model, bin_continuous = TRUE, n_bins = 4, quantile_bins = TRUE)

# Run the explain function for data frames on the iris data
explanation <- explain(iris_test, lime, n_labels = 1, n_features = 2)

# Plot the explanations
plot_features(explanation)

# Plot of prediction grid for sepal length vs petal length overlayed with training data 
# colored by species and testing data in black
ggplot(iris_grid, aes(x = Petal.Length, y = Sepal.Length)) +
  geom_jitter(aes(color = Pred), width = 0.15, height = 0.15, alpha = 0.3) +
  geom_point(data = iris_train, aes(x = Petal.Length, y = Sepal.Length, color = iris_lab), size = 3) +
  geom_point(data = iris_test, aes(x = Petal.Length, y = Sepal.Length), size = 3)

# Plot of prediction grid for sepal width vs petal length overlayed with training data 
# colored by species and testing data in black
ggplot(iris_grid, aes(x = Petal.Length, y = Sepal.Width)) +
  geom_jitter(aes(color = Pred), width = 0.15, height = 0.15, alpha = 0.3) +
  geom_point(data = iris_train, aes(x = Petal.Length, y = Sepal.Width, color = iris_lab), size = 3) +
  geom_point(data = iris_test, aes(x = Petal.Length, y = Sepal.Width), size = 3)

# Plot of prediction grid for petal width vs petal length overlayed with training data 
# colored by species and testing data in black
ggplot(iris_grid, aes(x = Petal.Length, y = Petal.Width)) +
  geom_jitter(aes(color = Pred), width = 0.15, height = 0.15, alpha = 0.3) +
  geom_point(data = iris_train, aes(x = Petal.Length, y = Petal.Width, color = iris_lab), size = 3) +
  geom_point(data = iris_test, aes(x = Petal.Length, y = Petal.Width), size = 3)

# Plot of prediction grid for sepal length vs petal width overlayed with training data 
# colored by species and testing data in black
ggplot(iris_grid, aes(x = Petal.Width, y = Sepal.Length)) +
  geom_jitter(aes(color = Pred), width = 0.15, height = 0.15, alpha = 0.3) +
  geom_point(data = iris_train, aes(x = Petal.Width, y = Sepal.Length, color = iris_lab), size = 3) +
  geom_point(data = iris_test, aes(x = Petal.Width, y = Sepal.Length), size = 3)

# Plot of prediction grid for sepal width vs petal width overlayed with training data 
# colored by species and testing data in black
ggplot(iris_grid, aes(x = Petal.Width, y = Sepal.Width)) +
  geom_jitter(aes(color = Pred), width = 0.15, height = 0.15, alpha = 0.3) +
  geom_point(data = iris_train, aes(x = Petal.Width, y = Sepal.Width, color = iris_lab), size = 3) +
  geom_point(data = iris_test, aes(x = Petal.Width, y = Sepal.Width), size = 3)
