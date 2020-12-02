### GET THE DATA

# Download files in the working directory

dataset_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataset_url, "Dataset.zip")
unzip("Dataset.zip", exdir = "dataset")

# Files are in a UCI HAR Dataset" folder. 

path <- file.path("./dataset" , "UCI HAR Dataset")
list.files(path, recursive=TRUE)

# Create all tables. Only 6 files are considered, plus the Features and Activities files

features  <- read.table(file.path(path, "features.txt"),col.names = c("i","measures"))
activities <- read.table(file.path(path, "activity_labels.txt"), col.names = c("number", "activity"))
subject_test <- read.table(file.path(path, "test/subject_test.txt"), col.names = "subject")
x_test <- read.table(file.path(path,"test/X_test.txt"), col.names = features$measures)
y_test <- read.table(file.path(path,"test/y_test.txt"), col.names = "number")
subject_train <- read.table(file.path(path, "train/subject_train.txt"), col.names = "subject")
x_train <- read.table(file.path(path,"train/X_train.txt"), col.names = features$measures)
y_train <- read.table(file.path(path,"train/y_train.txt"), col.names = "number")

# Merge train and tests tables to create one dataset
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Dataset <- cbind(Subject, Y, X)

# Extract only the measurements on the mean and standard deviation for each measurement

shortdataset <- select(Dataset, subject, number, contains("mean"), contains("std"))

# Use descriptive activity names to name the activities in the data set

shortdataset$number <- activities[shortdataset$number, 2]

# Appropriately label the data set with descriptive variable names

names(shortdataset)[2]= "activity"
names(shortdataset)<-gsub("Acc", "Accelerometer", names(shortdataset))
names(shortdataset)<-gsub("Gyro", "Gyroscope", names(shortdataset))
names(shortdataset)<-gsub("BodyBody", "Body", names(shortdataset))
names(shortdataset)<-gsub("Mag", "Magnitude", names(shortdataset))
names(shortdataset)<-gsub("^t", "Time", names(shortdataset))
names(shortdataset)<-gsub("^f", "Frequency", names(shortdataset))
names(shortdataset)<-gsub("angle", "Angle", names(shortdataset))
names(shortdataset)<-gsub("gravity", "Gravity", names(shortdataset))

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each 
# activity and each subject

tidydata<-aggregate(. ~ subject + activity, shortdataset, mean)
write.table(tidydata, "tidydata.txt", row.name=FALSE)
write.table(tidydata, "tidydata.csv", row.name=FALSE)

