# Applying-LIME-to-Bullet-Data-Paper

Repository for research project on assessing LIME by applying it to the Hamby bullet data. Each section below corresponds to one of the folers in the respository. The contents of each folder are listed and explained.

### app

This folder contains files for Shiny app for visualizing the LIME explanations associated with the bullet land comparisons

### code

This folder is a place for storing code that is used throughout the project

### data

This folder is a location for storing raw and created data for the project.

- **hamby173and252_train.csv**: training data that I cleaned (it should match the data used to fit `rtrees`)
    
- **hamby224_bin_boundaries.rds**: contains the boundaries for the bins as created by the `lime` function for each of the LIME input settings from the single implementation 
    
- **hamby224_bins.rds**: contains nice forms of the bin intervals (i.e. [lower, upper)) created using the bin boundaries for each of the LIME input settings from the single implementation 

- **hamby224_explain**:

- **hamby224_lime**:

- **hamby224_lime_comparisons**:

- **hamby224_lime_inputs**:

- **hamby224_sensitivity_inputs**:

- **hamby224_sensitivity_joined.csv**:

- **hamby224_sensitivity_outputs.rds**:

- **hamby223_test.csv**:

- **hamby224_test_explain.rds**:
  
### journals

This folder contains research journals with my work. Some of this will eventually end up in one of the papers.

### papers

This folder contains the statistics and firearm examiners papers.

### presentations

This folder contains the graphics group and JSM presentations.