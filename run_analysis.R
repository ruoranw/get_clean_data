library(kutils)
# Task1: Merges the training and the test sets to create one data set.

# Step 1: Read and combine tables in train folder
setwd("~/Desktop/coursera/R/cour4_week4/final_project/UCI HAR Dataset/train")
x_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")
subject_train <- read.table("subject_train.txt")
train_data <- cbind(x_train, y_train, subject_train)
# Step 2: Change the col name
names(train_data)[562] <- "label"
names(train_data)[563] <- "subject"
# Step3: Do the same to the test folder data
setwd("~/Desktop/coursera/R/cour4_week4/final_project/UCI HAR Dataset/test")
x_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
subject_test <- read.table("subject_test.txt")
test_data <- cbind(x_test, y_test, subject_test)
colnames(test_data)[562] <- "label"
colnames(test_data)[563] <- "subject"
#Step 4: Merge training and the test sets 
merged_data <- merge(train_data, test_data, all = T)

# Task 2: Extracts only the measurements on the mean and standard deviation for each measurement

# Step1: Set variable names to the table
setwd("~/Desktop/coursera/R/cour4_week4/final_project/UCI HAR Dataset")
feature_table <- read.table("features.txt")
features <- as.character(feature_table$V2)
change_names <- setNames(merged_data, features)
names(change_names)[562] <- "label"
names(change_names)[563] <- "subject"
# Step2: extract the variables with mean() and std() in it
vars <- names(change_names)
toMatch <- c("\\bmean()\\b","std()","label","subject")
selectednames <- grepl(paste(toMatch,collapse="|"), vars)
subsetted_df <- subset(change_names,select = selectednames)

# Task3: Uses descriptive activity names to name the activities in the data set

# Step1: Replace label column with descriptive activities
activities_label <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
activities <- mgsub(c(1,2,3,4,5,6), activities_label, subsetted_df$label)
# Step2: Bind the des_act vector to the dataframe and delete the label column
combined_df <- cbind(subsetted_df, activities)
clean_df <- subset(combined_df, select = -label)

# Task4: Appropriately labels the data set with descriptive variable names
# This task has been done in Task 2 step 1

# Task5: From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable for each activity and each subject.

library(dplyr)
# Step1: Group the data by subject first then by activities
grouped_data <- group_by(clean_df,subject, activities)
# Step2: summarise the grouped data and get the mean of each variable
sum_df <- summarise_all(grouped_data, list(mean))
write.table(sum_df, file = "tidy_df.txt", row.names = F)












