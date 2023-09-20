---
title: "codebook"
author: "jn"
date: "2023-09-20"
output: html_document
editor_options: 
  markdown: 
    wrap: 72
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Code book for HAR UCI analysis

This is an R Markdown document. It contains description of the
`run_analyis` script and the required data.

#### The `run_analyis.R` script file

This contain all the necessary R code required to: - Load require
`dplyr` package. It assumes the package is already installed. - Merge
train and test data into one data-set. All data are contained in the
`data` folder. - Updates the combined data-set with descriptive
activities names from `activities_labels.txt` file. - Extracts `mean()`
and `std()` measurements from the combined data-set - Creates a tidy
data-set with averages of each activity grouped by the `subject` and
`activity`. - Clean up memory by removing all working variables created
during the run. - Generate files of the tidy data-set and save them into
`tidy` folder.

#### The structure of the final tidy data-set

The data-set is stored on the `tidy` folder inside the data folder. It
has 2 files. The `summary-har-dataset.txt` contains the following
variables. - `subjectId` identifier of the subject - `activityId` - the
activity id that matches to activity labels 1 to 5 - The rest are the
mean of the mean and std measurement of the subject for the activity
e.g:
`tBodyAccMeanY`,`tBodyAccMeanZ`,`tBodyAccStdX`....`fBodyBodyGyroJerkMagMean`
Please note that the name of the measurement has been sanitized for by
using `gsub()` to remove the \_, ()

The second file `full-har-dataset.txt` contains the same information but
without grouping by subject and activity id
