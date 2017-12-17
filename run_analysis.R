library(dplyr)

# read in metadata
activity_labels <- read.csv("activity_labels.txt", sep="", header=FALSE, col.names=c("numericValue", "name"))
feature_labels <- make.names(read.table("features.txt", header=FALSE)[,2], unique=TRUE)

# read in the data, labels and subjects
test_data <- read.csv("test/X_test.txt", sep="", header=FALSE, col.names=feature_labels)
test_labels <- read.csv("test/y_test.txt", sep="", header=FALSE, colClasses="factor", col.names=c("activity"))
test_subjects <- read.csv("test/subject_test.txt", sep="", header=FALSE, colClasses="factor", col.names=c("subject"))
train_data <- read.csv("train/X_train.txt", sep="", header=FALSE, col.names=feature_labels)
train_labels <- read.csv("train/y_train.txt", sep="", header=FALSE, colClasses="factor", col.names=c("activity"))
train_subjects <- read.csv("train/subject_train.txt", sep="", header=FALSE, colClasses="factor", col.names=c("subject"))

# only use columns with mean or standard deviation data, explicitly excluding unwanted columns that match simple "contains" statements
filtered_test_data <- select(test_data, contains("mean"), contains("std"), -contains("meanFreq"), -contains("Mean", ignore.case=FALSE))
filtered_train_data <- select(train_data, contains("mean"), contains("std"), -contains("meanFreq"), -contains("Mean", ignore.case=FALSE))

# merge subjects, labels and data for test and train datasets
test <- data.frame(test_subjects, test_labels, filtered_test_data)
train <- data.frame(train_subjects, train_labels, filtered_train_data)

# translate activity labels to names instead of numeric value
levels(test$activity) <- (activity_labels$name)

# merge test and train data
data <- rbind(test, train)

# calculate averages by activity and subject
result <- data %>%
  group_by(activity, subject) %>%
  summarise_all(funs(mean))

write.csv(result, "result.csv")