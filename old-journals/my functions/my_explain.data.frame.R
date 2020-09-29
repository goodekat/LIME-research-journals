## Purpose: Add comments to the LIME function explain.data.frame and make
##          adjustments to it so it outputs the perturbations, predictions
##          for the perturbations based on the model, weights, and the
##          numerified perturbations
## Created: 2018/02/13
## Last Edited: 2018/02/13

# Load necessary libraries 
library(assertthat)
library(glmnet)

# My adjusted explain.data.frame function with comments -- I started comments 
# with "Added by KG" before each of the lines of code that I added to the
# function
my_explain.data.frame <- function(x, explainer, labels = NULL, n_labels = NULL,
                               n_features, n_permutations = 5000,
                               feature_select = 'auto', dist_fun = 'euclidean',
                               kernel_width = NULL, rr_predictors = "numerified",
                               ...) {
  
  # Make sure that the object explainer is of the type data_frame_explainer - 
  # if not, then the function will stop
  assert_that(is.data_frame_explainer(explainer))
  
  # Determine the type of the model that is contained within the explainer function
  m_type <- model_type(explainer)
  
  # Determine the output type based on the type of the model in the explainer
  o_type <- output_type(explainer)
  
  # If the model type is regression, then set n_lables to 1 and labels to NULL
  # also if the model is a regression and labels or n_labels are not set to NULL, 
  # then output a warning saying that labels and n_labels are ignored with 
  # explaining regression models
  if (m_type == 'regression') {
    if (!is.null(labels) || !is.null(n_labels)) {
      warning('"labels" and "n_labels" arguments are ignored when explaining 
              regression models')
    }
    n_labels <- 1
    labels <- NULL
  }
  
  # If both labels and n_labels are specified or neither are specified, then 
  # output a warning saying that we must choose between one or the other
  assert_that(is.null(labels) + is.null(n_labels) == 1, 
              msg = "You need to choose between labels and n_labels parameters.")
  
  # Stop function if n_features is not specified (as a numeric object) and 
  # output a warning saying this is the case
  assert_that(is.count(n_features))
  
  # Stop funtion if n_perumtations is not specified (as a numeric object) and 
  # output a warning saying this is the case
  assert_that(is.count(n_permutations))
  
  # If kernel width has not been specified, then compute it as the square root
  # of the number of columns of the testing dataframe multiplied by 0.75
  if (is.null(kernel_width)) {
    kernel_width <- sqrt(ncol(x)) * 0.75
  }
  
  # Create a kernel function that will be used to weight the perturbations 
  # based on the specified kernel width
  kernel <- exp_kernel(kernel_width)

  # Makes use of the permute_cases function for data frames in the lime 
  # package - this is the function that creates the perturbations - one 
  # for each of the n_permuations specified for each test case
  case_perm <- permute_cases(x, n_permutations, explainer$feature_distribution,
                             explainer$bin_continuous, explainer$bin_cuts)
  
  # Obtains predictions for all of the permutated data points using whatever 
  # the original model was
  case_res <- predict_model(explainer$model, case_perm, type = o_type)
  
  # Creates indicies for each of the perturbations and divides them into 
  # groups based on which new prediction case they correspond to
  case_ind <- split(seq_len(nrow(case_perm)), 
                    rep(seq_len(nrow(x)), each = n_permutations))
  
  # Create a function for computing weights, performing feature selection,
  # and fitting the final ridge regression model and apply the function to
  # each of the test cases
  
  res <- lapply(seq_along(case_ind), function(ind) {
    
    # Create a vector of indicies for one of the observations
    i <- case_ind[[ind]]
    
    # Turns the factor and character variables into numeric variables and
    # determines whether a permutation falls into the test data bin if 
    # bins_continuous is set to TRUE -- the perturbations get set to 0s 
    # and 1s
    perms <- numerify(case_perm[i, ], explainer$feature_type, 
                      explainer$bin_continuous, explainer$bin_cuts)
    
    # Determine the distance between the actual observations and the 
    # permutations (the 0s and 1s)
    dist <- c(0, dist(feature_scale(perms, 
                                    explainer$feature_distribution, 
                                    explainer$feature_type, 
                                    explainer$bin_continuous),
                      method = dist_fun)[seq_len(n_permutations-1)])
    
    # Added by KG: Compute the weights associated with the permutations
    # using the kernel function with specified width
    Weights <- kernel(dist)
    
    # Added by KG: Create a dataframe with the permutations and weights
    per <- cbind(perms, Weights)
    
    # Added by KG: Add a column which contains the name of the test_case
    per$Test_Case <- rownames(x)[ind]
    
    # Perform feature selection and fit a ridge regression model to the
    # permutations using the selected features with lambda = 0.001 and
    # weighted using the kernel function
    if(rr_predictors == "numerified"){
      res <- model_permutations(as.matrix(perms), 
                                case_res[i, , drop = FALSE], 
                                kernel(dist), labels, n_labels, n_features, 
                                feature_select)
    } else if(rr_predictors == "perturb"){
      res <- model_permutations(as.matrix(case_perm[i, ]), 
                                case_res[i, , drop = FALSE], 
                                kernel(dist), labels, n_labels, n_features, 
                                feature_select)
    } else{
      stop("Ridge regression response specified incorrectly.")
    }
    
    # Grab the original data values associated with the features used in
    # the ridge regressions (and make sure there are not in a list format)
    res$feature_value <- unlist(case_perm[i[1], res$feature])
    
    # This function determine which bins the original observations fall in and
    # outputs a character string describing the bin the observation is in
    res$feature_desc <- describe_feature(res$feature, 
                                         case_perm[i[1], ], 
                                         explainer$feature_type, 
                                         explainer$bin_continuous, 
                                         explainer$bin_cuts)
    
    # Determine the prediction made by the model for the test case of interest
    guess <- which.max(abs(case_res[i[1], ]))
    
    # Determine the "name" associated with the test case
    res$case <- rownames(x)[ind]
    
    # Associates the probability the model assigned to each outcome with the
    # appropriate outcome rows in the table
    res$label_prob <- unname(as.matrix(case_res[i[1], ]))[match(res$label, 
                                                                colnames(case_res))]
    
    # Creates a column with the observed data for the test case
    res$data <- list(as.list(case_perm[i[1], ]))
    
    # Creates a column with the prediction made by the model for each of 
    # the rows
    res$prediction <- list(as.list(case_res[i[1], ]))
    
    # Makes a column that lists the model type used in this predictive analysis
    res$model_type <- m_type
    
    return(list(res = res, per = per))
  })
  
  # Added by KG: Extract the permutations from the result above - they are still
  # in a list form
  per <- lapply(seq_along(case_ind), function(ind){
    per <- res[[ind]]$per  
  })
  
  # Added by KG: Transform the list of permutations into on big data frame
  per <- do.call(rbind, per)
  
  # Added by KG: Extract the explainer results from the result above - they are still
  # in a list form
  res <- lapply(seq_along(case_ind), function(ind){
    res <- res[[ind]]$res  
  })
  
  # Transform the list of results to one big data frame
  res <- do.call(rbind, res)

  # Reorder the variables in the results data frame
  res <- res[, c('model_type', 'case', 'label', 'label_prob', 'model_r2', 
                 'model_intercept', 'model_prediction', 'feature', 'feature_value', 
                 'feature_weight', 'feature_desc', 'data', 'prediction')]
  
  # If the model type is regression, then remove the variables of label and label
  # probability and unlist the predictions
  if (m_type == 'regression') {
    res$label <- NULL
    res$label_prob <- NULL
    res$prediction <- unlist(res$prediction)
  }

  # Added by KG: Join the perturbations and model probabilities in a data frame
  perturb <- cbind(case_perm, case_res)
  
  # Added by KG: Determine the model predictions for the perturbations and add
  # to the perturbation data frame
  perturb$Prediction <- predict(explainer$model, case_perm)
  
  # Added by KG: Added the weights to the perturbation data frame
  perturb$Weight <- per$Weights
  
  # Added by KG: Added the test case number to the perturbation data frame
  perturb$Test_Case <- per$Test_Case
  
  # Added by KG: Created a data frame with only the permutations
  per_numerified <- per[ , !(names(per) %in% c("Weights"))]
  
  # Added by KG: Return the results table (what LIME does), the perturbations,
  # and the numerified perturbations
  return(list(explanations = res, 
              perturb = perturb, 
              perturb_numerified = per_numerified))

}
