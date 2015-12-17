## Course Project Getting and Cleaning Data

library(plyr)

filename <- "getdata-projectfiles-UCI HAR Dataset.zip"

## Download and unzip the dataset:

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, filename, method="auto")

unzip(filename) 


### Merges the training and the test sets to create one data set

x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

### Extracts only the measurements on the mean and standard deviation for each measurement


features <- read.table("features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data on mean and standard deviation
featuresnum <- grep(".*mean.*|.*std.*", features[,2])
featuresnum_names <- features[featuresnum,2]
featuresnum_names = gsub('-mean', 'Mean', featuresnum_names)
featuresnum_names = gsub('-std', 'Std', featuresnum_names)
featuresnum_names <- gsub('[-()]', '', featuresnum_names)

# subset the wanted colums
x_data <- x_data[, featuresnum]

# putting the names of the features wanted
names(x_data) <- featuresnum_names


### Uses descriptive activity names to name the activities in the data set


activities <- read.table("activity_labels.txt")
activities[,2] <- as.character(activities[,2])

# putting the names of every activities
y_data[, 1] <- activities[y_data[, 1], 2]

# New column name
names(y_data) <- "activity"


### Appropriately labels the data set with descriptive variable names. 


# New column name
names(subject_data) <- "subject"

# Unify all the data
alldata <- cbind(x_data, y_data, subject_data)


### From the data set in step 4, creates a second, independent tidy data set with the average 
### of each variable for each activity and each subject.

tidydata <- ddply(alldata, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(tidydata, "tidydata.txt", row.name=FALSE)

