# Set working directory
setwd("D:\\DataScience\\UCI HAR Dataset")

## 1. Merges the training and the test sets to create one data set:
  x_train <- read.table(".\\train\\X_train.txt", header = FALSE)
  x_test <- read.table(".\\test\\X_test.txt", header = FALSE)
  y_train <- read.table(".\\train\\y_train.txt", header = FALSE)
  y_test <- read.table(".\\test\\y_test.txt", header = FALSE)
  subject_train <- read.table(".\\train\\subject_train.txt", header = FALSE)
  subject_test <- read.table(".\\test\\subject_test.txt", header = FALSE)

# Merge training and test sets by rows
  x <- rbind(x_train, x_test)
  y <- rbind(y_train, y_test)
  s <- rbind(subject_train, subject_test)
  
  ## 2. Extracts only the measurements on the mean and standard deviation for each measurement:
  
# Read features labels
  features <- read.table(".\\features.txt")
# Rename features column
  names(features) <- c('Feature_id', 'Feature_name')
# Search for matches to argument mean or standard deviation (sd)  within each element of character vector
  index_features <- grep("-mean\\(\\)|-std\\(\\)", features$Feature_name) 
  x <- x[, index_features] 
# Replaces all matches of a string features 
  names(x) <- gsub("\\(|\\)", "", (features[index_features, 2]))

## 3. Uses descriptive activity names to name the activities in the data set:
## 4. Appropriately labels the data set with descriptive activity names:

# Read activity labels
  activities <- read.table(".\\activity_labels.txt")
# Descriptive activities column
  names(activities) <- c('Activities_id', 'Activities_name')
  y[, 1] = activities[y[, 1], 2]

  names(y) <- "Activity"
  names(s) <- "Subject"

# Combines data table by columns
  tidyDataSet <- cbind(s, y, x)

## 5. Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject:
  p <- tidyDataSet[, 3:dim(tidyDataSet)[2]] 
  tidyDataSetAverage <- aggregate(p,list(tidyDataSet$Subject, tidyDataSet$Activity), mean)
  
# Activity and Subject name of columns 
  names(tidyDataSetAverage)[1] <- "Subject"
  names(tidyDataSetAverage)[2] <- "Activity"

# Create txt (tidy data set average) in directory
  write.table(tidyDataSetAverage, "tidy.txt", row.names=FALSE)
