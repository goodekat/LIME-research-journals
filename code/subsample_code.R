# Code saved for future use for the sampling data

# Create the data (with a set seed)
set.seed(20181128)
hamby173and252_train_sub <- hamby173and252_train %>%
  filter(samesource == FALSE) %>%
  slice(sample(1:length(hamby173and252_train$barrel1), 4500, replace = FALSE)) %>%
  bind_rows(hamby173and252_train %>% filter(samesource == TRUE))

# Save the subsampled data
write.csv(hamby173and252_train_sub, "../data/hamby173and252_train_sub.csv", row.names = FALSE)

# Apply lime to the subsampled training data with the specified input options
hamby224_lime_explain_sub <- future_pmap(.l = as.list(hamby224_lime_inputs %>%
                                                        select(-case)),
                                         .f = run_lime, # run_lime is one of my helper functions
                                         train = hamby173and252_train_sub %>% select(rf_features),
                                         test = hamby224_test %>% arrange(case) %>% select(rf_features) %>% na.omit(),
                                         rfmodel = as_classifier(rtrees),
                                         label = "TRUE",
                                         nfeatures = 3,
                                         seed = TRUE) %>%
  mutate(training_data = factor("Subsampled"))

# Separate the lime and explain function results from the subsampled data
hamby224_lime_sub <- map(hamby224_lime_explain_sub, function(list) list$lime)
hamby224_explain_sub <- map_df(hamby224_lime_explain_sub, function(list) list$explain)

# Join the lime results from the full and subsampled training data
hamby224_lime <- c(hamby224_lime_full, hamby224_lime_sub)
hamby224_explain <- bind_rows(hamby224_explain_full, hamby224_explain_sub)