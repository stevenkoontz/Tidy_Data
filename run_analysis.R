#load all data sets
features <- read.table("UCI HAR Dataset/features.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
train_x <- read.table("UCI HAR Dataset/train/X_train.txt")
test_x <- read.table("UCI HAR Dataset/test/X_test.txt")
train_sub <- read.table("UCI HAR Dataset/train/subject_train.txt")
test_sub <- read.table("UCI HAR Dataset/test/subject_test.txt")
train_y <- read.table("UCI HAR Dataset/train/y_train.txt")
test_y <- read.table("UCI HAR Dataset/test/y_test.txt")

# Merges the X_train and the X_test sets to create one dataset
data_x <- rbind(train_x, test_x)

# Merges the subject_train and the subject_test sets to create one dataset
data_sub <- rbind(train_sub, test_sub)

# Merges the y_train and the y_test sets to create one dataset
data_y <- rbind(train_y, test_y)

# Selects clean variables names for mean and standard deviation variables for dataset 
feature_sel <- grep("(mean|std)\\(\\)", features[, 2])
data_x_sel <- data_x[, feature_sel]
names(data_x_sel) <- features[feature_sel, 2]
names(data_x_sel) <- tolower(names(data_x_sel)) 
names(data_x_sel) <- gsub("\\(|\\)", "", names(data_x_sel))

#Makes clean activity labels for dataset
activities[, 2] <- tolower(as.character(activities[, 2]))
activities[, 2] <- gsub("_", "", activities[, 2])
data_y[, 1] = activities[data_y[, 1], 2]
colnames(data_y) <- 'activity'
colnames(data_sub) <- 'subject'

# Combine all data into one dataset
final_df <- cbind(data_sub, data_y, data_x_sel )
write.csv(final_df, file = "tidydata.csv")

# Creates a second dataset with the average 
average.df <- aggregate(x=final_df, by=list(activities=final_df$activity, subj=final_df$subject), FUN=mean)
average.df <- average.df[, !(colnames(average.df) %in% c("subj", "activity"))]
write.csv(average.df, "average.csv")
