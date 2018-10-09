library(tidyverse)
hamby224_test_explain <- readRDS("../data/hamby224_test_explain.rds")

hamby224_test_explain$feature_desc <- 
  factor(hamby224_test_explain$feature_desc)

hamby224_test_explain$feature <- 
  factor(hamby224_test_explain$feature)

hamby224_test_explain$feature_number <- readr::parse_number(hamby224_test_explain$feature_desc)
hamby224_test_explain$strictly_less <- FALSE
hamby224_test_explain$strictly_less[grep("< ", hamby224_test_explain$feature_desc)] <- TRUE

hamby224_test_explain <- hamby224_test_explain %>%
  mutate(
    feature_desc = reorder(feature_desc, strictly_less),
    feature_desc = reorder(feature_desc, feature_number),
    feature_desc = reorder(feature_desc, as.numeric(feature))
  )
  
hamby224_test_explain %>%
  ggplot(aes(x = feature_desc)) + geom_bar() +
  coord_flip()

 
saveRDS(hamby224_test_explain, file="../data/hamby224_test_explain.rds")
