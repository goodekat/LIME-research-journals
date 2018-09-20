## R Code for LIME Bullet Paper
## Purpose: creating images lime images
## Last updated: 2018/09/20

# Load libraries 
library(lime)

# Read in the explanation object
hamby224_explain <- readRDS("./data/hamby224_explain.rds")

# Read in the combined test data and explanation object
hamby224_test_explain <- readRDS("./data/hamby224_test_explain.rds")

png("./figures/hamby244_testset1_b1_b1_land1_land1.png")
plot_features(hamby224_explain[1:3,])
dev.off()
