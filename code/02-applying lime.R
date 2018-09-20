## R Code for LIME Bullet Paper
## Purpose: applying lime to the hamby 224 bullet data
## Last updated: 2018/09/20

# Load libraries
library(bulletr)
library(lime)
library(randomForest)

## -----------------------------------------------------------------------
## Loading Data
## -----------------------------------------------------------------------

# Load in the training data (Hamby Data 173 and 252)
hamby173and252_train <- read.csv("./data/hamby173and252_train.csv")

# Load in the testing data (Hamby 224 sets 1 and 11)
hamby224_test <- read.csv("./data/hamby224_test.csv")

## -----------------------------------------------------------------------
## Applying LIME
## -----------------------------------------------------------------------

# Apply the lime function from the lime package (with a seed set)
# Note that the as_classifier must be added since rtrees is from the
# randomForest package and not fit using caret or one of the other 
# available models specified in the lime package. Additionally, the
# randomForest package must be loaded in order to run the functions
# from the lime package. (I should check on exactly how this works.)
set.seed(84902)
hamby224_lime <- lime(x = hamby173and252_train %>% select(rf_features),
                      model = as_classifier(rtrees))

# Save the lime object
saveRDS(hamby224_lime, "./data/hamby224_lime.rds")

# Apply the explain function from the lime package (with a seed set)
set.seed(84902)
hamby224_explain <- lime::explain(hamby224_test %>% select(rf_features), 
                                  hamby224_lime, 
                                  n_labels = 1, 
                                  n_features = 3)

# Save the explain object
saveRDS(hamby224_explain, "./data/hamby224_explain.rds")

## -----------------------------------------------------------------------
## Joining Test Data with Explain Object
## -----------------------------------------------------------------------

# Add a case variable to the test data
hamby224_test <- hamby224_test %>%
  mutate(case = as.character(1:dim(hamby224_test)[1])) %>%
  select(case, study:samesource)

# Obtain features used when fitting the rtrees random forest
rf_features <- rownames(rtrees$importance)

# Join the data and the explanations and edit and add additional variables
hamby224_test_explain <- full_join(hamby224_test, hamby224_explain, by = "case") %>%
  mutate(case = factor(case),
         set = factor(set),
         bullet1 = factor(bullet1),
         bullet2 = factor(bullet2),
         land1 = factor(land1),
         land2 = factor(land2)) %>%
  mutate(mypred = rep(predict(rtrees, hamby224_test %>% select(rf_features), 
                              type = "prob")[,2], each = 3)) %>%
  select(case:rfscore, mypred, samesource:prediction)

# The structure of the joined data
str(hamby224_test_explain %>% select(-c(prediction, data)))

# Export the combined data
saveRDS(hamby224_test_explain, "./data/hamby224_test_explain.rds")
