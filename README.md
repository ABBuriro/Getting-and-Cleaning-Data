---
title: "Untitled"
author: "Abdul Baseer"
date: "6/15/2020"
output: word_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```
This document explains the steps taken to get and clean Samsung phone data to recognize human activity. 
The following code block add the required libraries/packages.

```{library(data.table)
library(dplyr)
library(tidyr)}
```
The following lines of code read the train and test data sets and then combine them as per task 1.

```{
train_feat <- read.table(".//UCI_HAR_Dataset//train//X_train.txt")
test_feat <- read.table(".//UCI_HAR_Dataset//test//X_test.txt")
X_dataset <- bind_rows(train_feat,test_feat)
rm(train_feat, test_feat) # clearing memory
}
```
Task 2 requires to extract variables/features that involves mean and standard deviation of measurements. 
The following lines perform task 2.

```{
feat <- read.table(".//UCI_HAR_Dataset//features.txt")
mn <- grep("mean()", feat[, 2])                       # mean
st <- grep("std()", feat[, 2])                        # standard deviation
idx <- sort(c(mn,st), decreasing = F)                 # indices to be used extract variables 
desired_data <- X_dataset[, idx]
}
```
Task 3 requires name the activites in the dataset. The following code block perform the task.

```{
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
}
```
Task 4 is to appropriately labels the data set with descriptive variable names, performed by the following block of the code.
```{
colnames(desired_data) = feat[idx, 2]
sub_test <- read.table(".//UCI_HAR_Dataset//test//subject_test.txt")
sub_train <- read.table(".//UCI_HAR_Dataset//train//subject_train.txt")
subjects <- bind_rows(sub_train, sub_test)
full_data <- mutate(desired_data,Label)
full_data <- bind_cols(subjects, full_data)
nam <- names(full_data)
nam[1] = "Subject"
names(full_data) = nam
}
```
Task 5 is to create a second, independent tidy data set with the average of each variable for each activity and each subject, performed by the following code lines.

```{
tidy_data <- full_data %>%
  group_by(Subject,Label) %>%
  summarise_all("mean") %>%
  write.table("tidy_data.txt")
}
```
