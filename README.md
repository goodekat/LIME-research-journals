# Applying-LIME-to-Bullet-Data-Paper

Repository for research project on assessing LIME by applying it to the Hamby bullet data. Each section below corresponds to one of the folers in the respository. The contents of each folder are listed and explained.

### app

This folder contains files for Shiny app for visualizing the LIME explanations associated with the bullet land comparisons.

<u> Contents: </u>

### code

This folder is a place for storing code that is used throughout the project.

<u> Contents: </u>

### data

This folder is a location for storing raw and created data for the project.

<u> Contents: </u>

- **hamby173and252_train.csv**: training data that I cleaned (it should match the data used to fit `rtrees`)
    
- **hamby224_bin_boundaries.rds**: contains the boundaries for the bins as created by the `lime` function for each of the LIME input settings from the single implementation 
    
- **hamby224_bins.rds**: contains nice forms of the bin intervals (i.e. [lower, upper)) created using the bin boundaries for each of the LIME input settings from the single implementation 

- **hamby224_explain**: the output from the `explain` function in lime from the single implementation with all of the different input options

- **hamby224_lime**: the output from the `lime` function in lime from the single implementation with all of the different input options

- **hamby224_lime_comparisons**: a dataset with summaries of the LIME explanations from the single implementation with all of the different input options

- **hamby224_lime_inputs**: LIME input settings used for the single implementation of LIME

- **hamby224_sensitivity_inputs**: LIME input settings used for the sensativity analysis of LIME

- **hamby224_sensitivity_joined.csv**: the test data and the LIME explanations from the sensativty analysis joined in a dataframe

- **hamby224_sensitivity_outputs.rds**: outputs from the `explain` function applied for each of the different input settings from the sensativity analysis combined in one dataframe

- **hamby223_test.csv**: testing data that I cleaned (created from sets 1 and 11 of the Hamby 224 study)

- **hamby224_test_explain.rds**: dataframe with the testing data and the output LIME explanation data from the single implementation with all of the different input options
  
### journals

This folder contains research journals with my work. Some of this will eventually end up in one of the papers.

<u> Contents: </u>

### papers

This folder contains the statistics and firearm examiners papers.

<u> Contents: </u>

### presentations

This folder contains the graphics group and JSM presentations.

<u> Contents: </u>