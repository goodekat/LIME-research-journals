## R Code for LIME Bullet Paper
## Purpose: cleaning the Hamby 224 data
## Last updated: 2018/09/20

# Load libraries
library(tidyverse)
library(bulletr)

# Load in the Hamby 224 datasets
hamby224_set1 <- readRDS("./data/h224-set1-features.rds")
hamby224_set11 <- readRDS("./data/h224-set11-features.rds")

# Obtain features used when fitting the rtrees random forest
rf_features <- rownames(rtrees$importance)

# Clean the Hamby 224 set 1 data
hamby224_set1_cleaned <- hamby224_set1 %>%
  select(-bullet_score, -land1, -land2, -aligned, -striae, -features) %>%
  rename(bullet1 = bulletA,
         bullet2 = bulletB, 
         land1 = landA,
         land2 = landB) %>%
  mutate(study = factor("Hamby_224"), 
         set = factor("1"),
         bullet1 = factor(bullet1),
         bullet2 = factor(bullet2),
         land1 = factor(land1),
         land2 = factor(land2)) %>%
  select(study, set, bullet1:land2, rf_features, rfscore, samesource)

# Clean the Hamby 224 set 11 data
hamby224_set11_cleaned <- hamby224_set11 %>%
  select(-bullet_score, -land1, -land2, -aligned, -striae, -features) %>%
  rename(bullet1 = bulletA,
         bullet2 = bulletB, 
         land1 = landA,
         land2 = landB) %>%
  mutate(study = factor("Hamby_224"), 
         set = factor("2"),
         bullet1 = recode(factor(bullet1), 
                          "Bullet 1" = "1", 
                          "Bullet 2" = "2", 
                          "Bullet I" = "I"),
         bullet2 = recode(factor(bullet2), 
                          "Bullet 1" = "1", 
                          "Bullet 2" = "2", 
                          "Bullet I" = "I"),
         land1 = recode(factor(land1), 
                        "Land 1" = "1", "Land 2" = "2", "Land 3" = "3", 
                        "Land 4" = "4", "Land 5" = "5", "Land 6" = "6"),
         land2 = recode(factor(land2), 
                        "Land 1" = "1", "Land 2" = "2", "Land 3" = "3", 
                        "Land 4" = "4", "Land 5" = "5", "Land 6" = "6")) %>%
  select(study, set, bullet1:land2, rf_features, rfscore, samesource)

# Join the two cleaned Hamby 224 sets into one testing set
hamby224_test <- suppressWarnings(bind_rows(hamby224_set1_cleaned, hamby224_set11_cleaned))

# Export the test data as a .csv file
write.csv(hamby224_test, "./data/hamby224_test.csv", row.names = FALSE)


