
# LIME Research <img align="right" height="200" src="./figures/lime.png">

Repository for research journals for my research projects related to
LIME. See below for descriptions of the contents of this repository. For
easy viewing of the journals, use these links:

0.  [Objectives and
    Ideas](https://goodekat.github.io/LIME-research-journals/journals/00-objectives_and_ideas/00-objectives_and_ideas.html)
1.  [Information on Hamby Data and
    Models](https://goodekat.github.io/LIME-research-journals/journals/01-hamby_data_and_models/01-hamby_data_and_models.html)
2.  [Understanding
    LIME](https://goodekat.github.io/LIME-research-journals/journals/02-understanding_lime/02-understanding_lime.html)
3.  [Applying LIME to Hamby
    Data](https://goodekat.github.io/LIME-research-journals/journals/03-applying_lime/03-applying_lime.html)
4.  [Assessing LIME on Hamby
    Data](https://goodekat.github.io/LIME-research-journals/journals/04-assessing_lime/04-assessing_lime.html)
5.  [Applying and Assessing LIME on Iris
    Data](https://goodekat.github.io/LIME-research-journals/journals/05-iris_comparison/05-iris_comparison.html)
6.  [Notes on
    Readings](https://goodekat.github.io/LIME-research-journals/journals/06-literature_review/06-literature_review.html)
7.  [Computational
    Issues](https://goodekat.github.io/LIME-research-journals/journals/07-computation_issues/07-computation_issues.html)
8.  [LIME Applied to Logistic Regressions on Sine
    Data](https://goodekat.github.io/LIME-research-journals/journals/08-logistic_regression/08-logistic_regression.html)
9.  [Identifying rtrees Training
    Data](https://goodekat.github.io/LIME-research-journals/journals/09-identifying_rtrees_training_data/09-identifying_rtrees_training_data.html)
10. [LIME Variability Across Hamby Data and
    Models](https://goodekat.github.io/LIME-research-journals/journals/10-lime_hamby_variability/10-lime_hamby_variability.html)

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
  - `08-logistic_regression`: examples of applying LIME to explain
    logistic regression models
  - `09-refitting-rtrees`: examples where I retrain the rtrees model
    with the “current” version of the training data and compare the
    results

**main**

The documents contained in the top folder are as follows:

  - `.gitattributes`: attributes relating to git
  - `.gitignore`: files to ignore
  - `notes from Heike.pdf`: scans of notes written by Heike for this
    project
  - `README`: document containing to do list and contents of this
    repository
