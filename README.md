
# LIME Research <img align="right" height="200" src="./figures/lime.png">

Repository for research projects on LIME applied to the Hamby bullet
data.

Link to csafe server: <https://isu-csafe.stat.iastate.edu/rstudio/>

## Talking points

  - Paper
      - I found ridge regression models in Python code (see journal 04)
      - Show the plots using the ridge regression in journal 09
      - What should I do about computing the generalized R2 value?
      - Show this paper: <https://arxiv.org/pdf/1806.07498.pdf>
      - Can you help to show me your vision with the minipage format?
      - I could not find a locality metric output from Python. There was
        a section in their vignettes that seemed to be referring to some
        sort of assessment about the models, but I’m not sure what was
        happening.
        <https://marcotcr.github.io/lime/tutorials/Tutorial%20-%20continuous%20and%20categorical%20features.html>
  - Graphics Group
      - email list (should I be added as an admin?)
      - send out another email and plan for first week?
      - updates on schedule since last meeting

## To Do List

*First draft of paper due two weeks into the semester (Tuesday,
September 10)*

**Current**

  - keep the LIME procedure at a higher level in the paper
  - change to computing the \(\mathcal{L}\) metric from the paper
  - add figure descriptions in both caption and text
  - go back through LIME procedure and update with new understanding
    (such as d’ can be larger than d)
  - add an assert\_that statement in the code to check if the LIME
    package is changing
  - read through papers giving an overview of the current explanation
    methods

**Later**

  - LIME diagnostics
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
      - he also suggested looking into SMOTE for dealing the imbalance
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
      - read book Dr. Dixon lent me on sensitivity analyses
  - possible improvements to LIME
      - determine the best number of bins to use for each variable
      - try out subsampling idea
  - random forests confidence intervals
      - look into papers by Giles Hooker and Lucas Mentch
      - Dr. Nettleton paper

## Contents

Descriptions of the materials in this repository are listed below.

**code**

This folder is a place for storing code that is used throughout the
project:

  - `app.R`: code for the Shiny app for visualizing the LIME
    explanations associated with the bullet land comparisons
  - `helper_functions.R`: R script with functions that I use in the
    journals and will probably end up using in the papers as well

**figures**

This folder contains static images:

  - `lime.png`: fun picture of a lime to use in the readme

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
  - `05-applying_lime_to_rtrees`: application of lime and sensitivity
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

**main**

The documents contained in the top folder are as follows:

  - `.gitattributes`: attributes relating to git
  - `.gitignore`: files to ignore
  - `notes from Heike.pdf`: scans of notes written by Heike for this
    project
  - `README`: document containing to do list and contents of this
    repository
