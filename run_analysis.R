library(dplyr)

setwd(
    "/Users/macbook/Documents/Privata projekt/Coursera/Data Science Specialization/code/3-Data_gathering_and_cleaning/Assignment/"
)

filename <- "week4_quiz_dataset.zip"

# Checking if zip archive exists
if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, filename, method="curl")
}

# Checking if folder exists
if (!file.exists("UCI\ HAR\ Dataset")) {
    unzip(filename)
}

# spaces on Mac nees a backslash \
test.x <- "UCI\ HAR\ Dataset/test/X_test.txt"
test.y <- "UCI\ HAR\ Dataset/test/y_test.txt"
test.subject <- "UCI\ HAR\ Dataset/test/subject_test.txt"

train.x <- "UCI\ HAR\ Dataset/train/X_train.txt"
train.y <- "UCI\ HAR\ Dataset/train/y_train.txt"
train.subject <- "UCI\ HAR\ Dataset/train/subject_train.txt"

features <- "UCI\ HAR\ Dataset/features.txt"
activity.labels <- "UCI\ HAR\ Dataset/activity_labels.txt"

# creating all the data frames
df.features <- read.table(features, col.names = c("n", "feature"))
df.activity.labels <- read.table(activity.labels, col.names = c("n", "activity_label"))

df.test.x <- read.table(test.x, col.names = df.features$feature)
df.test.y <- read.table(test.y, col.names = "activity_code")
df.test.subject <- read.table(test.subject, col.names = "subject")

df.train.x <- read.table(train.x, col.names = df.features$feature)
df.train.y <- read.table(train.y, col.names = "activity_code")
df.train.subject <- read.table(train.subject, col.names = "subject")

# 1. Merges the training and the test sets to create one data set.
df.test <- cbind(df.test.subject, df.test.y, df.test.x)
df.train <- cbind(df.train.subject, df.train.y, df.train.x)
df.merged <- rbind(df.test, df.train)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
df.extracted <- df.merged %>% select(subject, activity_code, contains("mean"), contains("std"))

#3. Uses descriptive activity names to name the activities in the data set
df.extracted$activity_code <- df.activity.labels[df.extracted$activity_code, 2]

#4. Appropriately labels the data set with descriptive variable names.
names(df.extracted)[1] = "Subject"
names(df.extracted)[2] = "Activity"
names(df.extracted)<-gsub("Acc", "Accelerometer", names(df.extracted))
names(df.extracted)<-gsub("BodyBody", "Body", names(df.extracted))
names(df.extracted)<-gsub("Gyro", "Gyroscope", names(df.extracted))
names(df.extracted)<-gsub("Mag", "Magnitude", names(df.extracted))
names(df.extracted)<-gsub("^t", "Time", names(df.extracted))
names(df.extracted)<-gsub("^f", "Frequency", names(df.extracted))
names(df.extracted)<-gsub(".mean()", "Mean", names(df.extracted))
names(df.extracted)<-gsub(".std()", "StandardDeviation", names(df.extracted))
names(df.extracted)<-gsub(".freq()", "Frequency", names(df.extracted))
names(df.extracted)<-gsub("angle", "Angle", names(df.extracted))
names(df.extracted)<-gsub("gravity", "Gravity", names(df.extracted))
names(df.extracted)<-gsub("Angle.X", "AngleX", names(df.extracted))
names(df.extracted)<-gsub("Angle.Y", "AngleY", names(df.extracted))
names(df.extracted)<-gsub("Angle.Z", "AngleZ", names(df.extracted))
names(df.extracted)<-gsub("tBody", "TimeBody", names(df.extracted))
names(df.extracted)<-gsub("gravitMean", "GravityMean", names(df.extracted))

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
df.tidy <- df.extracted %>% 
    group_by(Subject, Activity) %>% 
    summarise_all(funs(mean))

write.table(df.tidy, "tidy.txt", row.name=FALSE)
