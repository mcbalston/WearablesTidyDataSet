## This script demonstrates the collection and processing of a data set with the objective of forming a 
## 'Tidy' data set as per Wickham 2004 see README.md for a detailed explanation of this script.

## Check if required study files are already in the working directory. Download and unzip if not.
if(!file.exists("UCI HAR Dataset")) {

        print("Downloading source data set...")
        ## Download zip file to temp files folder

        temp.file <- tempfile()
        url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(url, temp.file, method="curl")
        
        # Unzip to working directory
        
        unzip(temp.file)
}
        
# Load required files.
# The normalizePath() function is used to try to ensure that the code can be run on any platform.
# The test platform was Windows.
# Where appropriate, column names are given to aid future differentiation

activity_labels <- read.table(normalizePath(
                        paste0("UCI HAR Dataset/activity_labels.txt")),
                        col.names = c("ActivityID","ActivityName"))

features <- read.table(normalizePath(
                        paste0("UCI HAR Dataset/features.txt")),
                        col.names = c("FeatureID","FeatureName"))

X_train <- read.table(normalizePath(
                        paste0("UCI HAR Dataset/train/X_train.txt")))

y_train <- read.table(normalizePath(
                        paste0("UCI HAR Dataset/train/y_train.txt")), col.names = "ActivityID")

subject_train <- read.table(normalizePath(
                        paste0("UCI HAR Dataset/train/subject_train.txt")), col.names = "SubjectID")

X_test <- read.table(normalizePath(
                        paste0("UCI HAR Dataset/test/X_test.txt")))

y_test <- read.table(normalizePath(
                        paste0("UCI HAR Dataset/test/y_test.txt")), col.names = "ActivityID")

subject_test <- read.table(normalizePath(
                        paste0("UCI HAR Dataset/test/subject_test.txt")), col.names = "SubjectID")

##----------------------------------------------------------------------
## STEP 1 - Merge the training and the test sets to create one data set.
##----------------------------------------------------------------------

# Add the subject and activity ID columns to both the train and test data sets.
# Also add an additional column to indicate if the data is taken from the train or the test data.
# Although this additional column is not explicitly asked for, its inclusion could aid any
# consistency tests on the data later in the processing.

data.set <- "train"
data.train <- cbind(subject_train,             # subject ID vector
                   cbind(y_train,              # activity ID vector
                         cbind(data.set,       # vector of "train"
                               X_train         # observation data
                              )
                         )
                    )

data.set <- "test"
data.test <- cbind(subject_test,             # subject ID vector
                   cbind(y_test,             # activity ID vector
                         cbind(data.set,     # vector of "test"
                                   X_test    # observation data
                              )
                         )
                   )
 
# Stack the two datasets together, with the train data first, test data below.

data.full <- rbind(data.train, data.test)

##-------------------------------------------------------------------------------
## STEP 2 - Extract only the measurements on the mean and standard deviation for
##          each measurement.
##-------------------------------------------------------------------------------

# First identify the required features (as a list of positions within the vector) from feature.txt

feature.required <- grep("mean\\(|std\\(",features$FeatureName)

# Subset the full data set to retain the observation identifiers (in the first three columns)
# and the required features

data.columnextract <- data.full[,c(1:3, feature.required+3)]


##-------------------------------------------------------------------------------
## STEP 3 - Use descriptive activity names to name the activities in the data set
##-------------------------------------------------------------------------------

# Since the activity names are stored in activity_names.txt in the order corresponding to their
# respective ID, we can use the row number of the data frame activity_labels as a substitute for the
# activity ID.  We can therefore simply identify the label corresponding to the required activity ID 
# using activity_label$ActivityName[<required_ActivityID>].
#
# In order to apply this operation across the full column of the data, we use sapply and an anonymous 
# function to perform the lookup.

# The descriptive activity name is stored in a new column 'ActivityName'

data.columnextract$ActivityName <- sapply(data.columnextract$ActivityID,
                                          function(x) activity_labels$ActivityName[x])

##----------------------------------------------------------------------------
## STEP 4 - Appropriately label the data set with descriptive variable names.
##----------------------------------------------------------------------------

# Names for the features are taken from the original file features.txt, extracting the required
# values using the vector obtained using the grep() function in step 2.
#                                          
# Since the feature name is stored as a factor within the features data frame, we use as.character()
# to ensure that the string representation is returned, not the numeric factor level.
                                          
feature.required.name <- as.character(features[feature.required,2])

# Two minor adjustments are made to the feature names to make them compatible with the eventual output format:
# parentheses are removed and dashes are replaced with dots:
                                          
feature.required.name <- gsub("\\(\\)","",feature.required.name)
feature.required.name <- gsub("-",".",feature.required.name)

# Apply the required column names from column 4 onwards
names(data.columnextract)[4:(ncol(data.columnextract)-1)] <- feature.required.name



##--------------------------------------------------------------------------------------------
## STEP 5 - From the data set in step 4, creates a second, independent tidy data set with the 
##          average of each variable for each activity and each subject.
##--------------------------------------------------------------------------------------------

# This final step is solved efficiently using the dplyr package.
# The final data set has 180 rows, one for each combination of the 30 subjects and 6 activities. 
# In addition to the 2 columns identifying the activity and subject, are 66 columns providing 
# the average of each variable.

library(dplyr)

data.final <- tbl_df(data.columnextract) %>%            # Create a tbl from the data frame
                select(-c(ActivityID, data.set)) %>%    # Remove the unrequired columns
                group_by(ActivityName, SubjectID) %>%   # Specify grouping to be by Activity and Subject
                summarise_all(mean)                     # Summarise for each group, returning the mean of all other columns

# Finally, the tidy data is written to file for submission.
write.table(data.final, "tidy-data.txt", row.names=FALSE)

# This file can be read in using the function:
#       read.table("tidy-data.txt", header=TRUE)
