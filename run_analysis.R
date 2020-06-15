#setwd(".//DataScience//DataCleaning")
library(data.table)
library(dplyr)
library(tidyr)
# reading training data
train_feat <- read.table(".//UCI_HAR_Dataset//train//X_train.txt")
# reading test data
test_feat <- read.table(".//UCI_HAR_Dataset//test//X_test.txt")
# task 1. combining train and test data sets to create one data set
X_dataset <- bind_rows(train_feat,test_feat)
# clearing memory
rm(train_feat, test_feat)
# task 2. Extracting on measurements on mean and standard deviation for each measurement, i.e., 
# desired dataset
# reading text file to get indices of mean and standard deviation
feat <- read.table(".//UCI_HAR_Dataset//features.txt")
mn <- grep("mean()", feat[, 2])         # mean
st <- grep("std()", feat[, 2])          # standard deviation
idx <- sort(c(mn,st), decreasing = F)   # indices to be used to extract desired variable data 
desired_data <- X_dataset[, idx]
# task 3. Uses descriptive activity names to name the activities in the data set
act <- read.table(".//UCI_HAR_Dataset//activity_labels.txt")
act <- as.character(act[, 2])
train_label <- read.table(".//UCI_HAR_Dataset//train//y_train.txt")
test_label <- read.table(".//UCI_HAR_Dataset//test//y_test.txt")
Label <- bind_rows(train_label, test_label)
Label <- Label$V1
rm(train_label, test_label)
for (i in 1:length(act)){
  Label[Label == i] = act[i]
}
# task 4. Appropriately labels the data set with descriptive variable names
colnames(desired_data) = feat[idx, 2]
sub_test <- read.table(".//UCI_HAR_Dataset//test//subject_test.txt")
sub_train <- read.table(".//UCI_HAR_Dataset//train//subject_train.txt")
subjects <- bind_rows(sub_train, sub_test)
full_data <- mutate(desired_data,Label)
full_data <- bind_cols(subjects, full_data)
nam <- names(full_data)
nam[1] = "Subject"
names(full_data) = nam
rm(desired_data, Label, X_dataset, feat, sub_train, sub_test, act, i, idx, mn, st)
# task 5. From the data set in step 4, creates a second, independent tidy 
# data set with the average of each variable for each activity and each subject
tidy_data <- full_data %>%
  group_by(Subject,Label) %>%
  summarise_all("mean") %>%
  write.table("tidy_data.txt")

# further tideness
# avg_subject <- full_data %>%
  # select(-Label) %>%
  # group_by(Subject) %>%
#   summarise_all("mean") %>%
#   write.table("avg_subject.txt")
# avg_activity <- full_data %>%
#   select(-Subject) %>%
#   group_by(Label) %>%
#   summarise_all("mean") %>%
#   write.table("avg_activity.txt")

# Note: the same can be performed by 
# avg_subject <- aggregate(full_data[, 2:80], list(full_data$Subject), mean, colnames = "subject")
# avg_activity <- aggregate(full_data[, 2:80], list(full_data$Label), mean)


  


