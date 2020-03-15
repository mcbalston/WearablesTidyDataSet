# WearablesTidyDataSet
Code to create a Tidy data set from smartphone activity data.  This code was for the project assignment of the Johns Hopkins Coursera course on Getting and Cleaning Data from the Data Science Specialization.


# Source data
From the source data provided, I identified the following files which will be used by the script:

Training data (70% of subjects)
1. X_train.txt - test data with one row per observation, 561 columns containing features
2. subject_train.txt - a vector containing the subject ids for each test observation.  Has the same number of rows as #1
3: y_train.txt - a vector containing the activity label ids for each test observation.  Has the same number of rows as #1

Test data (30% of subjects)
1. X_test.txt - test data with one row per observation, 561 columns containing features
2. subject_test.txt - a vector containing the subject ids for each test observation.  Has the same number of rows as #1
3: y_test.txt - a vector containing the activity label ids for each test observation.  Has the same number of rows as #1

activity_labels.txt - a two column data set with key:value pairs.  The 'key' in this case is a numeric value corresponding to the number used for the activity in y_train.txt and x_train.txt.  The 'value' is a string providing the name of the activity.

features.txt - a two column data sey with 561 key:value pairs.  The 'key' is the numeric value of the feature.  It is assumed that these numbers correspond to the columns in X_test.txt and X_train.txt. The 'value' is the name of the feature.


# STEP 1
Merges the training and the test sets to create one data set.


First we add the subject and activity columns to both the train and test data sets.  We also add a column to indicate if the data is taken from the train or the test data.

Next we stack the two datasets together.

# STEP 2
Extracts only the measurements on the mean and standard deviation for each measurement.

I use grep() to identify which features are mean and std measures.  I assume that only features including the text 'mean()' or 'std()' are required since the 
Having identified the feature numbers, I extract the corresponding columns from the dataset.

# STEP 3
Uses descriptive activity names to name the activities in the data set

There are several ways the numeric values for activity could be converted into the string representation, but I chose to provide the string values as factor labels, since the column is best represented as a factor variable.

# STEP 4
Appropriately labels the data set with descriptive variable names.

Names for the features were taken from the original file features.txt, extracting the required values using the vector obtained using the grep() function in step 2.

# STEP 5
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Using the dplyr package, I first grouped the data by activity and subject and then summarised, using mean to obtain the average for each of the remaining columns (the 'variables').

This final data set is 'Tidy' because...


The final tidy data can be loaded into R using the script:



