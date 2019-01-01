# Course 3 - Getting and Cleaning Data - Programming Assignment

This is the codebook of the programming assignment of the course "Getting and Cleaning Data".
All the steps are explained in detail below.

#### Loading the required libraries.
```Rscript
library(dplyr)
```

#### Downloading the data.
Before executing the script, please set the the working directory that you are working with.
```Rscript
setwd(
    ".../3-Data_gathering_and_cleaning/Assignment/"
)

filename <- "week4_quiz_dataset.zip"

# Checking if zip archive exists
if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, filename, method="curl")
}

# Checking if folder exists
# Spaces on Mac nees a backslash \
if (!file.exists("UCI\ HAR\ Dataset")) {
    unzip(filename)
}
```

Once unzipped, the files in folder "UCI HAR Dataset" are:

**Subject files**
test/subject_test.txt
train/subject_train.txt

**Activity files**
test/X_test.txt
train/X_train.txt

**Data files**
test/y_test.txt
train/y_train.txt

**Label files**
features.txt - Names of column variables in the dataTable
activity_labels.txt - Links the class labels with their activity name.

#### Setting the variables and assigning all data frames
```Rscript
# Spaces on Mac nees a backslash \
test.x <- "UCI\ HAR\ Dataset/test/X_test.txt"
test.y <- "UCI\ HAR\ Dataset/test/y_test.txt"
test.subject <- "UCI\ HAR\ Dataset/test/subject_test.txt"

train.x <- "UCI\ HAR\ Dataset/train/X_train.txt"
train.y <- "UCI\ HAR\ Dataset/train/y_train.txt"
train.subject <- "UCI\ HAR\ Dataset/train/subject_train.txt"

features <- "UCI\ HAR\ Dataset/features.txt"
activity.labels <- "UCI\ HAR\ Dataset/activity_labels.txt"

# Creating all the data frames
df.features <- read.table(features, col.names = c("n", "feature"))
df.activity.labels <- read.table(activity.labels, col.names = c("n", "activity_label"))

df.test.x <- read.table(test.x, col.names = df.features$feature)
df.test.y <- read.table(test.y, col.names = "activity_code")
df.test.subject <- read.table(test.subject, col.names = "subject")

df.train.x <- read.table(train.x, col.names = df.features$feature)
df.train.y <- read.table(train.y, col.names = "activity_code")
df.train.subject <- read.table(train.subject, col.names = "subject")
```

#### Description of the downloaded data
*features <- features.txt* : 561 rows, 2 columns 
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ.

*activities <- activity_labels.txt* : 6 rows, 2 columns 
List of activities performed when the corresponding measurements were taken and its codes (labels)

*subject_test <- test/subject_test.txt* : 2947 rows, 1 column 
contains test data of 9/30 volunteer test subjects being observed

*x_test <- test/X_test.txt* : 2947 rows, 561 columns 
contains recorded features test data

*y_test <- test/y_test.txt* : 2947 rows, 1 columns 
contains test data of activities???code labels

*subject_train <- test/subject_train.txt* : 7352 rows, 1 column 
contains train data of 21/30 volunteer subjects being observed

*x_train <- test/X_train.txt* : 7352 rows, 561 columns 
contains recorded features train data

*y_train <- test/y_train.txt* : 7352 rows, 1 columns 
contains train data of activities???code labels

#### Step 1. Merges the training and the test sets and creates one single data set.
```Rscript
df.test <- cbind(df.test.subject, df.test.y, df.test.x)
df.train <- cbind(df.train.subject, df.train.y, df.train.x)
df.merged <- rbind(df.test, df.train)
```

#### Step 2. Extracts only the measurements on the mean and standard deviation for each measurement.
The extracted data frame contains 4 columns: subject, activity_code, mean, std
```Rscript
df.extracted <- df.merged %>% select(subject, activity_code, contains("mean"), contains("std"))
```

#### Step 3. Uses descriptive activity names to name the activities in the data set
The data set imports the names from the file activity_labels.txt
```Rscript
df.extracted$activity_code <- df.activity.labels[df.extracted$activity_code, 2]
```

#### Step 4. Appropriately labels the data set with descriptive variable names.
Descriptive variable names makes it easier to read the variable names.
```Rscript
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
```

#### Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
```Rscript
df.tidy <- df.extracted %>% 
    group_by(Subject, Activity) %>% 
    summarise_all(funs(mean))

write.table(df.tidy, "tidy.txt", row.name=FALSE)
```


#### The final result (a simple from the file tidy.txt)
```
"Subject" "Activity" "TimeBodyAccelerometerMean...X" "TimeBodyAccelerometerMean...Y" "TimeBodyAccelerometerMean...Z" ...
1 "LAYING" 0.22159824394 -0.0405139534294 -0.11320355358 ...
1 "SITTING" 0.261237565425532 -0.00130828765170213 -0.104544182255319 ...
1 "STANDING" 0.278917629056604 -0.0161375901037736 -0.110601817735849 ...
1 "WALKING" 0.277330758736842 -0.0173838185273684 -0.111148103547368 ...
````