# Course 3 - Getting and Cleaning Data - Programming Assignment

This is the programming assignment for the "Getting and Cleaning Data" course, which is a part of John's Hopkin's course in Data Science on Coursera.


## The files

* **CodeBook.md**, the codebook that describes the variables, the data, and any transformations or work that was performed to clean up the data.

* **run_analysis.R** performs all the tasks as described in the project???s definition.
The script:
* Downloads the dataset, if it doesn't already exist in the working directory.
* Loads the activity and feature info.
* Loads both the training and test datasets and then extracts only the measurements on the mean and standard deviation for each measurement.
* Loads the activity and subject data for each dataset, and merges those columns with the dataset.
* Merges the training and the tests sets to create one single data set.
* Sets descriptive variable names in the dataset.
* Creates a second tidy dataset that consists of the mean value of each variable for each subject and activity, where the end result is written to the file tidy.txt.

* **tidy.txt** is the exported final data

## Description 
1. Clone the repository and be sure to set the the working directory.
2. Run the "run_analysis.R" script.
