## Helper Functions for the Paper

## ---------------------------------------------------------------
## Run the Lime Functions
## ---------------------------------------------------------------

# Function for running the lime functions which runs the lime and explain 
# objects in a list
run_lime <- function(bin_continuous, quantile_bins, nbins, use_density,
                     data_name, train, test, rfmodel, label, nfeatures, 
                     seed = TRUE){
  
  # Set a seed if requested
  if (seed == TRUE) set.seed(84902)
  
  # Run the lime function
  lime <- lime(x = train, model = rfmodel, bin_continuous = bin_continuous, 
               n_bins = nbins, quantile_bins = quantile_bins, use_density = use_density)
  
  # Run the explain function and add a variable for the number of bins
  explain <- explain(x = test, explainer = lime, labels = label, n_features = nfeatures) %>%
    mutate(training_data = data_name,
           bin_continuous = bin_continuous,
           quantile_bins = quantile_bins,
           nbins = nbins,
           use_density = use_density)
  
  return(list(lime = lime, explain = explain))
  
}

## ---------------------------------------------------------------
## Write the Bins
## ---------------------------------------------------------------

# Function for writing bins given the bin boundaries
write_bins <- function(bin_data){
  
  # Compute the number of bins based the input dataframe
  nbins = length(bin_data) - 2
  
  # Create an empty matrix to store the bins in
  bin_matrix <- matrix(NA, nrow = 1, ncol = nbins + 1)
  
  # Put the feature name in the first column
  bin_matrix[,1] <- as.character(bin_data[[1]])
  
  # Put the 1st through 2nd to last bins in the 2nd through 2nd to last columns
  bin_matrix[,2:nbins] <- sapply(2:nbins, 
                          FUN = function(number) sprintf("[%.2f, %.2f)", 
                                                         as.numeric(bin_data[number]),
                                                         as.numeric(bin_data[number + 1])))
  
  # Fill in the last column with the upper bin (based on whether it should be infinite or not)
  bin_matrix[,nbins + 1] <- ifelse(is.na(bin_data[nbins + 2]),
                            sprintf("(%.2f, %s)", as.numeric(bin_data[nbins + 1]), "\U221E"),
                            sprintf("(%.2f, %.2f]", as.numeric(bin_data[nbins + 1]),
                                    as.numeric(bin_data[nbins + 2])))
  
  return(bin_matrix)
  
}

## ---------------------------------------------------------------
## Create a Data Frame with the Bins
## ---------------------------------------------------------------

create_bin_data <- function(lime_object){
  
  # If bin_continuous = TRUE, create a list with data frames on bin information
  if (lime_object$bin_continuous == TRUE){
    
    # Determine the nubmer of bins
    nbins <- length(lime_object$bin_cuts[[1]]) - 1
    
    # Create a dataframe of bin boundaries
    bin_boundaries <- data.frame(Feature = rf_features,
                                 Lower = c(0, -1, rep(0, 7)),
                                 matrix(unlist(lime_object$bin_cuts), nrow = 9, 
                                        byrow = TRUE)[,2:nbins],
                                 Upper = c(1, 1, rep(NA, 7)))
    
    # Use my function "write_bins" to create a dataframe with the bins
    bins <- data.frame(t(apply(bin_boundaries, 1, write_bins)))
    
    # Assign appropriate names to the bin columns
    if (nbins == 2){
      names(bins) <- c("Feature", "Lower Bin", "Upper Bin")
    } else if (nbins == 3) {
      names(bins) <- c("Feature", "Lower Bin", "Middle Bin", "Upper Bin")
    } else {
      names(bins) <- c("Feature", 
                       "Lower Bin",
                       sapply(1:(nbins - 2), function(bin) sprintf("Middle Bin %.0f", bin)),
                       "Upper Bin")
    }
    
    return(list(boundaries = bin_boundaries, bins = bins))
  
  } else {
    
    # If bin_continuous = FALSE, return the following message
    return(list(boundaries = paste("No bins available since bin_continuous = FALSE was selected."),
                bins = paste("No bins available since bin_continuous = FALSE was selected.")))
    
  }
  
}

## ---------------------------------------------------------------
## Label Feature Bins
## ---------------------------------------------------------------

# Function to use for creating bin labels in the test_explain dataset
bin_labeller <- function(feature, feature_value, d_n, b_c, q_b, n_b, u_d, bin_data, case_info){
  
  if (is.na(feature) | b_c == FALSE) {
    
    # Set feature_bin to NA if feature is NA
    feature_bin <- NA
    
  } else {
    
    # Determine which item in the list of bin divisions to grab 
    # based on the case info
    selected_list_item <- case_info %>%
      filter(data_name == d_n,
             bin_continuous == b_c, 
             quantile_bins == q_b,
             nbins == n_b, 
             use_density == u_d) %>%
      pull(case)
    
    # Subset the bin cuts table to the selected feature
    feature_bin_data <- bin_data[[selected_list_item]] %>%
      filter(Feature == as.character(feature)) %>%
      select(-Feature, -Lower, -Upper)
    
    # Determine which bin the case falls in
    if(feature_value <= feature_bin_data[1]){
      feature_bin <- paste(feature, "(lower bin)")
    } else if (feature_bin_data[n_b - 1] < feature_value){
      feature_bin <- paste(feature, "(upper bin)")
    } else {
      middle_bin_checks <- data.frame(middle_bin_number = 1:(n_b - 2),
                                      contained = sapply(1:(n_b - 2),
                                                         FUN = function(number) {
                                                           feature_bin_data[number] < feature_value &
                                                             feature_value <= feature_bin_data[number + 1]}))
      
      if (n_b == 3){
        feature_bin = sprintf("%s (middle bin)", feature)
      } else {
        feature_bin <- sprintf("%s (middle bin %.0f)", 
                               feature,
                               middle_bin_checks %>% filter(contained == TRUE) %>% pull(middle_bin_number))
      }
      
    }
    
  }
  
  # Return the bin
  return(feature_bin)
  
}
