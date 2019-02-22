# Applying-LIME-to-Bullet-Data-Paper

Repository for research project on assessing LIME by applying it to the Hamby bullet data. Each section below corresponds to one of the folers in the respository. The contents of each folder are listed and explained.

### app

This folder contains files for Shiny app for visualizing the LIME explanations associated with the bullet land comparisons: 

- **app.R**: code for the Shiny app

### code

This folder is a place for storing code that is used throughout the project:

- **helper_functions.R**: R script with functions that I use in the journals and will probably end up using in the papers as well

### data

This folder is a location for storing raw and created data for the project:

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

This folder contains research journals with my work. Some of this will eventually end up in one of the papers:

- **00-objectives_and_ideas.Rmd (& .html)**: background of the research project, goals of the project, concerns with LIME, and ideas to try
- **01-training_and_testing_data.Rmd (& .html)**: information on the Hamby data, understanding the raw data, and cleaning of the training and testing data
- **02-plotting_training_and_testing_data.Rmd (& .html)**: exploratory plots of the training and testing data
- **03-computation_issues.Rmd (& .html)**: documentation of some of the computation issues I ran into during the project
- **04-lime_algorithm_and_proposed_methods.Rmd (& .html)**: rough draft of the lime algorithm as implemented in the lime R package and proposed methods for improving the lime algorithm
- **05-applying_lime_to_rtrees.Rmd (& .html)**: application of lime and sensativity analysis for many different input options
- **06-assessing_lime_explanations.Rmd (& .html & cache files)**: assessment of the lime explanations
- **07-logistic_regression.Rmd (& .html)**: logistic regressions fit to the bullet data and application of lime to the logistic regression

### papers

This folder contains the statistics and firearm examiners papers: 

- **An Assessment of LIME Explanations from a Random Forest Models**: statistical paper assessing LIME applied to a random forest model and proposal of improvements to the algorithm
- **Interpreting Random Forest Predictions for Firearm Identification Using LIME**: firearm examiners' paper explaining how LIME can be used to understand the random forest model fit to bullet matching data
- **references.bib**: references for the firearm examiners' paper

### presentations

This folder contains the graphics group and JSM presentations:

- jsm:
    - **jsm abstract.Rmf (& .html)**: abstract for JSM conference presentation
- graphics group:
