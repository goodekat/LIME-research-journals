
# Applying LIME to Bullet Data

Repository for research project on assessing LIME by applying it to the
Hamby bullet data. The contents of this respository are listed below.

### app

This folder contains files for Shiny app for visualizing the LIME
explanations associated with the bullet land comparisons:

  - **app.R**: code for the Shiny app

### code

This folder is a place for storing code that is used throughout the
project:

  - **helper\_functions.R**: R script with functions that I use in the
    journals and will probably end up using in the papers as well

### data

This folder is a location for storing raw and created data for the
project:

  - **hamby173and252\_train.csv**: training data that I cleaned (it
    should match the data used to fit `rtrees`)
  - **hamby224\_bin\_boundaries.rds**: contains the boundaries for the
    bins as created by the `lime` function for each of the LIME input
    settings from the single implementation
  - **hamby224\_bins.rds**: contains nice forms of the bin intervals
    (i.e. \[lower, upper)) created using the bin boundaries for each of
    the LIME input settings from the single implementation
  - **hamby224\_explain**: the output from the `explain` function in
    lime from the single implementation with all of the different input
    options
  - **hamby224\_lime**: the output from the `lime` function in lime from
    the single implementation with all of the different input options
  - **hamby224\_lime\_comparisons**: a dataset with summaries of the
    LIME explanations from the single implementation with all of the
    different input options
  - **hamby224\_lime\_inputs**: LIME input settings used for the single
    implementation of LIME
  - **hamby224\_sensitivity\_inputs**: LIME input settings used for the
    sensativity analysis of LIME
  - **hamby224\_sensitivity\_joined.csv**: the test data and the LIME
    explanations from the sensativty analysis joined in a dataframe
  - **hamby224\_sensitivity\_outputs.rds**: outputs from the `explain`
    function applied for each of the different input settings from the
    sensativity analysis combined in one dataframe
  - **hamby223\_test.csv**: testing data that I cleaned (created from
    sets 1 and 11 of the Hamby 224 study)
  - **hamby224\_test\_explain.rds**: dataframe with the testing data and
    the output LIME explanation data from the single implementation with
    all of the different input options
  - raw: original data given to me by Heike
      - **features-hamby173and252.csv**
      - **h224-set1-features.rds**
      - **h224-set11-features.rds**

### journals

This folder contains folders with research journals.

  - **00-objectives\_and\_ideas**: background of the research project,
    goals of the project, concerns with LIME, and ideas to try
  - **01-training\_and\_testing\_data**: information on the Hamby data,
    understanding the raw data, and cleaning of the training and testing
    data
  - **02-plotting\_training\_and\_testing\_data**: exploratory plots of
    the training and testing data
  - **03-computation\_issues**: documentation of some of the computation
    issues I ran into during the project
  - **04-lime\_algorithm\_and\_proposed\_methods**: rough draft of the
    lime algorithm as implemented in the lime R package and proposed
    methods for improving the lime algorithm
  - **05-applying\_lime\_to\_rtrees**: application of lime and
    sensativity analysis for many different input options
  - **06-assessing\_lime\_explanations**: assessment of the lime
    explanations
  - **07-logistic\_regression**: logistic regressions fit to the bullet
    data and application of lime to the logistic regression
  - **08-iris\_comparison**: applying LIME to a random forest fit to the
    iris data
  - **09-understanding\_lime**: attempts to visualize the results from
    LIME to understand how LIME works
  - **10-other\_explainers**: trying out other model explainers
  - **notes from Heike.pdf**: scans of notes written by Heike for this
    project

### papers

This folder contains the statistics and firearm examiners papers:

  - **bullet\_application**: explains how LIME can be used to understand
    the random forest model fit to bullet matching data
  - **lime\_diagnostics**: explains the need to assess LIME and presents
    some visual diagnostic tools
