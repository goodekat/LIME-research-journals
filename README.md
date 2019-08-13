
# LIME Research <img align="right" height="200" src="./figures/lime.png">

Repository for research projects on LIME applied to the Hamby bullet
data.

Link to csafe server: <https://isu-csafe.stat.iastate.edu/rstudio/>

## Talking points

  - I am thinking about moving the paper to a new repository and then
    renaming this repository as LIME-research-journals and using it more
    as a place to try stuff out
  - Can I remove some of the sources from the references file that I am
    not going to use?
  - Can we talk about how best to present the LIME algorithm and some of
    the terms from the original paper that do not make sense in the
    context of the R package?

## To Do List

**Current**

  - work on first draft of paper
  - read through papers giving an overview of the current explanation
    methods

**Later**

  - LIME diganostics
      - turn repetitive code into functions
      - try out different weights
      - change distance matrix in seriation to be 5-\# of variables
        shared between two rows
      - try using distance matrix computed on the feature value with
        seriation
      - add in feature selection methods to LIME input options
      - think of a way to compute consistency across top two features
      - Siggi suggests refitting the RF model to the perturbations and
        then continuing with LIME with the RF predictions from the new
        model - this may help to understand if the problems are due to
        the sampling procedure or LIME itself
      - he also suggested looking into SMOTE for dealing the inbalance
        in the classes with sampling
      - compare the simple models based on different number of bins
        using an F-test
      - look into computing a diversity or consistency measure for the
        sensitivity analysis
      - include a penalty for the number of parameters when choosing
        bins
      - look at the AUC after binning
      - compute a likelihood ratio prob TRUE / prob FALSE from the LIME
        ridge regression
      - try visualizing the features from the test data using dimension
        reduction and coloring them by variables suggested to be
        important by lime
  - explainer models
      - look into iml (<https://www.youtube.com/watch?v=jP6Rg13PEkQ>)
      - look more into Molnar and his adviser Bernd
      - look into
        [MAPLE](https://blog.ml.cmu.edu/2019/07/13/towards-interpretable-tree-ensembles/)
  - understanding LIME
      - read through LIME papers again
      - finish journal on understanding lime (look at the RF in the
        local region lime is considering to see if it agrees with the
        lime explanations)
      - try fitting LASSO logistic model and leave one out approach (for
        multicollinarity)
      - assess lime results on logistic regression models
      - think about how the argmin is accomplished by the LIME R package
      - try retriculate to apply python version of lime
      - look into literature on binning methods
      - think about why R^2 would be better for some binning methods
      - read new paper on Anchor
  - simulation with RF
      - think about how to implement a simulation with a random forest
      - look back at 601 notes from Kaiser for model assessment
      - look at Hadley’s ‘removing the blindfold’ for ideas
      - read book Dr. Dixon lent me on sensativity analyses
  - possible improvements to LIME
      - determine the best number of bins to use for each variable
      - try out subsampling idea
  - random forests confidence intervals
      - look into papers by Giles Hooker and Lucas Mentch
      - Dr. Nettleton paper

## Contents

Descriptions of the materials in this respository are listed below.

**app**

This folder contains files for Shiny app for visualizing the LIME
explanations associated with the bullet land comparisons:

  - `app.R`: code for the Shiny app

**code**

This folder is a place for storing code that is used throughout the
project:

  - `helper_functions.R`: R script with functions that I use in the
    journals and will probably end up using in the papers as well

**data**

This folder is a location for storing raw and created data for the
project:

  - `hamby173and252_train.csv`: training data that I cleaned (it should
    match the data used to fit `rtrees`)
  - `hamby224_bin_boundaries.rds`: contains the boundaries for the bins
    as created by the `lime` function for each of the LIME input
    settings from the single implementation
  - `hamby224_bins.rds`: contains nice forms of the bin intervals (i.e.
    \[lower, upper)) created using the bin boundaries for each of the
    LIME input settings from the single implementation
  - `hamby224_explain`: the output from the `explain` function in lime
    from the single implementation with all of the different input
    options
  - `hamby224_lime`: the output from the `lime` function in lime from
    the single implementation with all of the different input options
  - `hamby224_lime_comparisons`: a dataset with summaries of the LIME
    explanations from the single implementation with all of the
    different input options
  - `hamby224_lime_inputs`: LIME input settings used for the single
    implementation of LIME
  - `hamby224_sensitivity_inputs`: LIME input settings used for the
    sensativity analysis of LIME
  - `hamby224_sensitivity_joined.csv`: the test data and the LIME
    explanations from the sensativty analysis joined in a dataframe
  - `hamby224_sensitivity_outputs.rds`: outputs from the `explain`
    function applied for each of the different input settings from the
    sensativity analysis combined in one dataframe
  - `hamby223_test.csv`: testing data that I cleaned (created from sets
    1 and 11 of the Hamby 224 study)
  - `hamby224_test_explain.rds`: dataframe with the testing data and the
    output LIME explanation data from the single implementation with all
    of the different input options
  - raw: original data given to me by Heike
      - `features-hamby173and252.csv`
      - `h224-set1-features.rds`
      - `h224-set11-features.rds`

**journals**

This folder contains folders with research journals.

  - `00-objectives_and_ideas`: background of the research project, goals
    of the project, concerns with LIME, and ideas to try
  - `01-training_and_testing_data`: information on the Hamby data,
    understanding the raw data, and cleaning of the training and testing
    data
  - `02-plotting_training_and_testing_data`: exploratory plots of the
    training and testing data
  - `03-computation_issues`: documentation of some of the computation
    issues I ran into during the project
  - `04-lime_algorithm_and_proposed_methods`: rough draft of the lime
    algorithm as implemented in the lime R package and proposed methods
    for improving the lime algorithm
  - `05-applying_lime_to_rtrees`: application of lime and sensativity
    analysis for many different input options
  - `06-assessing_lime_explanations`: assessment of the lime
    explanations
  - `07-logistic_regression`: logistic regressions fit to the bullet
    data and application of lime to the logistic regression
  - `08-iris_comparison`: applying LIME to a random forest fit to the
    iris data
  - `09-understanding_lime`: attempts to visualize the results from LIME
    to understand how LIME works
  - `10-other_explainers`: trying out other model explainers
  - `notes from Heike.pdf`: scans of notes written by Heike for this
    project

**papers**

This folder contains the statistics and firearm examiners papers:

  - `bullet_application`: explains how LIME can be used to understand
    the random forest model fit to bullet matching data
  - `lime_diagnostics`: explains the need to assess LIME and presents
    some visual diagnostic tools
