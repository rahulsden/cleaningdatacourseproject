Usage:
source("run_analysis.R")
summaryDS <- main_func()

Assumptions:
The DS files are present in the current working directory
the output is generated in output.txt in the current working directory

Problem Statement:
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names. 
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Source of DataSet:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

How It Works:
This code first populates the:
List of 6 activities and ID from activity_labels.txt
List of 561 variables from features.txt
It populates the training and test data using the function read_data_set_func(<>)
The files X_Order, Y_Order and Subject are read from each of test and train directory
The data set is merged to form am merged DS
We use the ddply function from dplyr library to create the summaryDS as per the problem statement
