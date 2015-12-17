## Course Project Getting and Cleaning Data

library(plyr)

filename <- "getdata-projectfiles-UCI HAR Dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="auto")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

### Merges the training and the test sets to create one data set

x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# create 'x' data set
x_data <- rbind(x_train, x_test)

# create 'y' data set
y_data <- rbind(y_train, y_test)

# create 'subject' data set
subject_data <- rbind(subject_train, subject_test)

### Extracts only the measurements on the mean and standard deviation for each measurement


features <- read.table("features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data on mean and standard deviation
featuresnum <- grep(".*mean.*|.*std.*", features[,2])
featuresnum.names <- features[featuresnum,2]
featuresnum.names = gsub('-mean', 'Mean', featuresnum.names)
featuresnum.names = gsub('-std', 'Std', featuresnum.names)
featuresnum.names <- gsub('[-()]', '', featuresnum.names)

# subset the desired columns
x_data <- x_data[, featuresnum]

# New column names
names(x_data) <- featuresnum.names


### Uses descriptive activity names to name the activities in the data set


activities <- read.table("activity_labels.txt")
activities[,2] <- as.character(activities[,2])

# update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# New column name
names(y_data) <- "activity"


### Appropriately labels the data set with descriptive variable names. 


# New column name
names(subject_data) <- "subject"

# Unify all the data
all_data <- cbind(x_data, y_data, subject_data)


### From the data set in step 4, creates a second, independent tidy data set with the average 
### of each variable for each activity and each subject.

tidydata <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(tidydata, "tidydata.txt", row.name=FALSE)

