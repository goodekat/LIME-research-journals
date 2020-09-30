
# LIME Research <img align="right" height="200" src="https://i.pinimg.com/originals/de/18/33/de18338e3313edd97d8156d987244e74.jpg">

Repository for research journals for my research projects related to
LIME. See below for descriptions of the contents of this repository.

Descriptions of the work done can be found in the journals. Beware of
typos in the journals. Not all of them have been proof read. For easy
viewing of the journals, use these links:

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

#### [**code**](code/)

Place for storing R code used in the research journals:

  - [app.R](code/app.R): code for the Shiny app for visualizing the LIME
    explanations associated with the bullet land comparisons
  - [helper\_functions.R](code/helper_functions.R): R script with
    functions that I use in the journals

#### [**figures**](figures)

Contains static images:

  - [laugel-lime-concept.png](figures/laugel-lime-concept.png) and
    [laugel-locality-metric](figures/laugel-locality-metric.png):
    figures from the Laugel et al. (2018) paper
  - [python-ridge1](figures/python-ridge1.png),
    [python-ridge2](figures/python-ridge2.png), and
    [python-ridge3](figures/python-ridge3.png): screen shots of the
    python LIME package showing the use of a ridge regression as the
    explainer

#### [**journals**](journals)

Contains folders with research journals:

  - [00-objectives\_and\_ideas](journals/00-objectives_and_ideas):
    background of the research project, goals of the project, concerns
    with LIME, and ideas to try
  - [01-hamby\_data\_and\_models](journals/01-hamby_data_and_models)\*\*\*:
    information on the Hamby data, cleaning of the training and testing
    data, visualizations of the data, and models fit to the data (rtrees
    and logistic regressions)
  - [02-understanding\_lime](journals/02-understanding_lime)\*\*\*: work
    done to understand the LIME algorithm
  - [03-applying\_lime](journals/03-applying_lime)\*\*\*: applications
    of LIME to the models fit to the Hamby data
  - [04-assessing\_lime](journals/04-assessing_lime)\*\*\*: visual
    diagnostics for assessing the lime explanations
  - [05-iris\_comparison](journals/05-iris_comparison): applying LIME to
    a random forest fit to the iris data and assessing the explanations
  - [06-literature\_review](journals/06-literature_review/): notes on
    papers relating to LIME
  - [07-computation\_issues](journals/07-computation_issues/)\*\*\*:
    documentation of some of the computation issues I ran into during
    the project
  - [08-logistic\_regression](journals/08-logistic_regression): examples
    of applying and diagnosing LIME with logistic regression models fit
    to the sine data
  - [09-identifying\_rtrees\_training\_data](journals/09-identifying_rtrees_training_data/):
    examples where I retrain the rtrees model with the “current” version
    of the training data and compare the results
  - [10-lime\_hamby\_variability](journals/10-lime_hamby_variability/):
    investigating variability between LIME explanations using diagnostic
    figures for random forest models trained on the Hamby bullet data

\*\*\* **Note**: We have realized that the training dataset for the
`rtrees` model is not the one used in these files. See
[09-identifying\_rtrees\_training\_data](journals/09-identifying_rtrees_training_data)
for more details on the correct dataset. The correct data is used in the
LIME diagnostics paper. For time reasons, the results in these journals
have not been updated.

#### [**old-journals**](old-journals)

Contains materials from my earliest research journals relating to the
LIME project. It is likely that the code in these files will not run.
However, the knit versions of the R markdown documents may still be
useful, so I included them in the repository.

#### **main**

Files contained in the main folder of the repository:

  - [.gitignore](.gitignore): files to ignore
  - [notes from Heike.pdf](notes%20from%20Heike.pdf): scans of notes
    written by Heike for this project
  - [README.md](README.md) and [README.Rmd](README.Rmd): this README and
    the R markdown document used to generate this README
