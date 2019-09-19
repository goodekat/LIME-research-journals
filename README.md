
# LIME Research <img align="right" height="200" src="./figures/lime.png">

Repository for research projects on LIME

Link to csafe server: <https://isu-csafe.stat.iastate.edu/rstudio/>

## Talking points

  - Should I write the code in a package or just save the functions in a
    folder in the paper repository?
  - Sometimes LIME does not want to run in R with the bullet data

<!-- end list -->

``` r
library(lime)

# Split up the data set
iris_test <- iris[1:5, 1:4]
iris_train <- iris[-(1:5), 1:4]
iris_lab <- iris[[5]][-(1:5)]

# Create Random Forest model on iris data
#model <- caret::train(iris_train, iris_lab, method = 'rf')
model <- randomForest::randomForest(iris_train, iris_lab)

# Create an explainer object
explainer <- lime(iris_train, as_classifier(model))

# Explain new observation
explanation <- explain(iris_test, explainer, n_labels = 1, n_features = 2)
```

## To Do List

*First draft of paper due Wednesday, September 18)*

  - draft methods section of the paper
  - draft data example section of paper
  - draft discussion section of paper
  - draft appendices

## Oral Prelim

**Schedule**

  - can be anytime during the semester
  - just needs to be 6 months before final defense
  - schedule when it gets closer to the time
  - schedule 3 or 4 weeks in advance
  - send prelim materials to committee 2 weeks in advance

**Materials**

  - Chapter 0 (complete)
      - lit review
      - research statement: “this is what this thesis will investigate”
  - Chatper 1 (as close to submission as possible)
      - LIME and shortcomings
      - Dr. Dixon likes to give feedback before submission
  - Chapter 2 (draft)
      - Diagnostics for RF
  - Chapter 3 (some idea)
      - Diagnostics for Bayesian Neural Networks
      - Could switch to chapter 2 if more complete
  - Conclusion (not needed)

## Ideas

**LIME diagnostics**

  - turn repetitive code into functions
  - try out different weights
  - change distance matrix in seriation to be 5-\# of variables shared
    between two rows
  - try using distance matrix computed on the feature value with
    seriation
  - add in feature selection methods to LIME input options
  - think of a way to compute consistency across top two features
  - Siggi suggests refitting the RF model to the perturbations and then
    continuing with LIME with the RF predictions from the new model -
    this may help to understand if the problems are due to the sampling
    procedure or LIME itself
  - he also suggested looking into SMOTE for dealing the imbalance in
    the classes with sampling
  - compare the simple models based on different number of bins using an
    F-test
  - look into computing a diversity or consistency measure for the
    sensitivity analysis
  - include a penalty for the number of parameters when choosing bins
  - look at the AUC after binning
  - compute a likelihood ratio prob TRUE / prob FALSE from the LIME
    ridge regression
  - try visualizing the features from the test data using dimension
    reduction and coloring them by variables suggested to be important
    by lime

**Explainer Models**

  - read through papers giving an overview of the current explanation
    methods
  - look into iml (<https://www.youtube.com/watch?v=jP6Rg13PEkQ>)
  - look more into Molnar and his adviser Bernd
  - look into
    [MAPLE](https://blog.ml.cmu.edu/2019/07/13/towards-interpretable-tree-ensembles/)

**Understanding LIME**

  - edit details in understanding LIME journal
  - look at the RF in the local region lime is considering to see if it
    agrees with the lime explanations
  - try fitting LASSO logistic model and leave one out approach (for
    multicollinarity)
  - assess lime results on logistic regression models
  - try retriculate to apply python version of lime
  - look into literature on binning methods
  - think about why R^2 would be better for some binning methods
  - read new paper on Anchor

**Possible Improvements to LIME**

  - determine the best number of bins to use for each variable
  - try out subsampling idea

**Simulation with RF**

  - think about how to implement a simulation with a random forest
  - look back at 601 notes from Kaiser for model assessment
  - look at Hadley’s ‘removing the blindfold’ for ideas
  - read book Dr. Dixon lent me on sensitivity analyses

**Random Forests Confidence Intervals**

  - look into papers by Giles Hooker and Lucas Mentch
  - Dr. Nettleton paper

**Random Forest Interpretations**

  - read
    <https://www.r-bloggers.com/explaining-predictions-random-forest-post-hoc-analysis-randomforestexplainer-package/>

## Repository Contents

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
  - `python-ridge1`, `python-ridge2`, and `python-ridge3`: screen shots
    of the python LIME package showing the use of a ridge regression as
    the explainer

**journals**

This folder contains folders with research journals.

  - `00-objectives_and_ideas`: background of the research project, goals
    of the project, concerns with LIME, and ideas to try
  - `01-hamby_data_and_models`: information on the Hamby data, cleaning
    of the training and testing data, visualizations of the data, and
    models fit to the data (rtrees and logistic regressions)
  - `02-understanding_lime`: explanation of LIME procedure
  - `03-applying_lime`: applications of LIME to the models fit to the
    Hamby data
  - `04-assessing_lime`: visual diagnostics for assessing the lime
    explanations
  - `05-iris_comparison`: applying LIME to a random forest fit to the
    iris data
  - `06-literature_review`: notes on papers relating to LIME
  - `07-computation_issues`: documentation of some of the computation
    issues I ran into during the project

**main**

The documents contained in the top folder are as follows:

  - `.gitattributes`: attributes relating to git
  - `.gitignore`: files to ignore
  - `notes from Heike.pdf`: scans of notes written by Heike for this
    project
  - `README`: document containing to do list and contents of this
    repository
