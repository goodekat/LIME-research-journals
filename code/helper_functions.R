## Helper Functions for the Paper

## ---------------------------------------------------------------
## Write Bin Dataframe 
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
## Label Feature Bins
## ---------------------------------------------------------------

# Function to use for creating bin labels in the test_explain dataset
bin_labeller <- function(feature, feature_value, bin_data = hamby_divisions){
  
  if (is.na(feature)) {
    
    # Set feature_bin to NA if feature is NA
    feature_bin <- NA
    
  } else {
    
    # Subset the bin cuts table to the selected feature
    feature_bin_data <- bin_data %>%
      filter(Feature == feature) %>%
      select(-Feature, -Lower, -Upper)
    
    # Compute the number of bins based the input dataframe
    nbins = length(bin_data) - 2
    
    # Determine which bin the case falls in
    if(feature_value <= feature_bin_data[1]){
      feature_bin <- paste(feature, "(lower bin)")
    } else if (feature_bin_data[nbins - 1] < feature_value){
      feature_bin <- paste(feature, "(upper bin)")
    } else {
      middle_bin_checks <- data.frame(middle_bin_number = 1:(nbins-2),
                                      contained = sapply(1:(nbins - 2),
                                                         FUN = function(number) {
                                                           feature_bin_data[number] < feature_value &
                                                             feature_value <= feature_bin_data[number + 1]}))
      feature_bin <- sprintf("%s (middle bin %.0f)", 
                             feature,
                             middle_bin_checks %>% filter(contained == TRUE) %>% pull(middle_bin_number))
    }
    
  }
  
  # Return the bin
  return(feature_bin)
  
}