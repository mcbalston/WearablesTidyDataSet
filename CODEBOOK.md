# Variables within TidyData.txt

*All variables within TidyData.txt are derived from the original data set included in this <a name="myfootnote1">study<sup>1</sup></a>.  The description of the variables within that data set provides further explanation.*

The data set contains 180 observations, one for each combination of 30 subjects and 6 activities.  For each observation, 66 variables are given, each of which is the average value of the corresponding variable in the original data set, for **the given subject and activity**.

Position | Name | Description
---------|------|------------
1 | ActivityName | One of 6 string values describing the activity undertaken
2 | SubjectID | An integer (1-30) indicating the subject
3..68 | *various<sup>+</sup>* | The mean value of the corresponding variable in the original data set

<sup>+</sup> The variables in TidyData.txt are derived from the original data set with two modifications:
1. Parenthesis are removed
2. Dashes are changed to dots

For example:

Original Data set | TidyData.txt
------------------|-------------
tBodyAcc-mean()-X| tBodyAcc.mean.X
tBodyAccJerkMag-std() | tBodyAccJerkMag.std


<sup>[1](#myfootnote1)</sup>[Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
