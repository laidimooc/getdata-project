The data are provided [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

Data consists of a two sets (trin and test) of mesurement from their phone. 
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ.


There two sets are merged in a  unique table called `merged_data`.

The provided features are not directly usable in R. They are transformed like this 

* "-" becomes "_"
* "()" is deleted

Example : `tBodyAcc-mean()-X` becomes `tBodyAcc_mean_X`.

Only the measurements on the mean and standard deviation for each measurement are extracted from this table.
Some measurements which contain the word `meanFreq` are deleted because they are not 

The first column is the subject (1 to 30) and the second is the activity during the measurement (WALKING, WALKING\_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)

This "good" table is named : `data_complete`.

From this table, a second independent tidy data set is created with the average of each variable for each activity and each subject. This table is `tidy_mean` and a file `tidy_mean.txt` without row names.


