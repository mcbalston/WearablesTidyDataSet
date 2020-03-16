# WearablesTidyDataSet
Code to create a Tidy data set from smartphone activity data.  This code is for the project assignment of the Johns Hopkins Coursera course on Getting and Cleaning Data from the Data Science Specialization.


# Source data
From the source data provided, I identified the following files which will be used by the script:

Training data (70% of subjects)
A1. X_train.txt - test data with one row per observation, 561 columns containing features
A2. subject_train.txt - a vector containing the subject ids for each test observation.  Has the same number of rows as A1
A3. y_train.txt - a vector containing the activity label ids for each test observation.  Has the same number of rows as A1

Test data (30% of subjects)
B1. X_test.txt - test data with one row per observation, 561 columns containing features
B2. subject_test.txt - a vector containing the subject ids for each test observation.  Has the same number of rows as B1
B3. y_test.txt - a vector containing the activity label ids for each test observation.  Has the same number of rows as B1

activity_labels.txt - a two column data set with 6 key:value pairs.  The 'key' in this case is a numeric value corresponding to the number used for the activity in y_train.txt and x_train.txt.  The 'value' is a string providing the name of the activity.

features.txt - a two column data sey with 561 key:value pairs (the same number of columns as both A1 and B1).  The 'key' is the numeric value of the feature.  It is assumed that these numbers correspond to the columns in X_test.txt and X_train.txt. The 'value' is the name of the feature.

# The script

The script first downloads the data and extracts it locally.  It then loads the files identified above into the following R variables. Columns names are explicity given in the load for all files except the two test data files.  The columns auto-generated for these (V1, V2, ...) are sufficiently appropriate (until renamed later in the script).

Source File | R Object name | R Object Class | Dimensions
------------|---------------|----------------|------------
X_test.txt  | X_test  | data.frame | 2947, 561
subject_test.txt | subject_test | data.frame | 2947, 1
y_test.txt | y_test | data.frame | 2947,2
X_train.txt | X_train | data.frame | 2947, 561
subject_train.txt | subject_train | data.frame | 2947, 1
y_train.txt | y_train | data.frame | 2947, 2
activity_labels.txt | activity_labels | data.frame | 6, 2
features.txt | features | data.frame | 561, 2

Next, the script addresses each of the steps descripted in the assignment instructions in order...


## STEP 1
_Merges the training and the test sets to create one data set._


First the script adds the subject and activity columns to both the train and test data sets.  It also adds a column to indicate if the data is taken from the train or the test data.  Although this additional column is not explicitly requested, its inclusion could prove useful to check for consistency in the later data set and to help diagnose any issues which might arise.

Next the script stacks the two datasets together.

## STEP 2
_Extracts only the measurements on the mean and standard deviation for each measurement._

I use grep() to identify which features are mean and std measures.  I assume that only features including the text 'mean()' or 'std()' are required since the instructions requested the 'mean and standard deviation for each measurement'.  For the other features which include mean in their name (e.g. fBodyAcc-meanFreq()-X) the 'mean' appears to be part of the measurement, not a function of the measurement.
Having identified the feature numbers, the function extracts the corresponding columns from the dataset by simple column subsetting.

## STEP 3
_Uses descriptive activity names to name the activities in the data set_

The script looks up the activity names from activity_labels, applying this to the vector of activity IDs using sapply.  An anonymous
function is used to perform the lookup and a new column (ActivityName) is added to the data set.

## STEP 4
_Appropriately labels the data set with descriptive variable names._

Names for the features are taken from the original file features.txt, extracting the required values using the vector obtained using the grep() function in step 2.
Two minor changes are made to the names to ensure compatibility with the final output format: the parentheses are removed and the dashes are replaced with dots.  Both of these adjustments are made using gsub().

## STEP 5
_From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject._

Using the dplyr package, the data set is first turned into a 'tibble', unrequired columns (ActivityID and data.set) are dropped, grouping is defined on activity and subject and finally the data is summarised by this grouping, with the mean for all columns, for each group being returned.
This transformation is achieved efficiently by 'piping' the data through each step above using the pipe (%>%) operator.

This final data set is 'Tidy' because each row represents an observation (defined by a single subject and single activity), while each column is a variable.

The final tidy data can be loaded into R using the script:
`read.table("tidy-data.txt", header=TRUE)`

## References
[Wickham, Hadley. "Tidy Data." *Journal of Statistical Software.* American Statistical Association. August 2014. Date Accessed: 16 March 2020.](https://www.jstatsoft.org/index.php/jss/article/view/v059i10/v59i10.pdf)

Also thanks to David Hood for his extremely useful [advice](https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/) on this assigment...and to Philippe Alcouffe for directing me to it.
