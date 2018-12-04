
# It took about half the time when using the function from furrr!

library(tictoc)
library(future)
library(furrr)

# This should take 6 seconds in total running sequentially
plan(sequential)
tic()
sensitivity_explain <- future_pmap(.l = as.list(sensitivity_inputs %>% 
                                                         select(-case)),
                                          .f = run_lime, # run_lime is one of my helper functions
                                          train = hamby173and252_train %>% select(rf_features),
                                          test = hamby224_test %>% arrange(case) %>% select(rf_features) %>% na.omit(),
                                          rfmodel = as_classifier(rtrees),
                                          label = "TRUE",
                                          nfeatures = 3,
                                          seed = FALSE)
toc()
# 218.188 sec elapsed

plan(multiprocess)
tic()
sensitivity_explain <- future_pmap(.l = as.list(sensitivity_inputs %>% 
                                                         select(-case)),
                                          .f = run_lime, # run_lime is one of my helper functions
                                          train = hamby173and252_train %>% select(rf_features),
                                          test = hamby224_test %>% arrange(case) %>% select(rf_features) %>% na.omit(),
                                          rfmodel = as_classifier(rtrees),
                                          label = "TRUE",
                                          nfeatures = 3,
                                          seed = FALSE)
toc()
# 107.731 sec elapsed
