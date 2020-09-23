#Getting and Cleaning Data Course Project

features <- read.table('./UCI HAR Dataset/features.txt', header = FALSE, sep = ' ')
x_train <- read.table('./UCI HAR Dataset/train/X_train.txt')
y_train <- read.table('./UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ')
subject_train <- read.table('./UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = ' ')
x_test <- read.table('./UCI HAR Dataset/test/X_test.txt')
y_test <- read.table('./UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ')
subject_test <- read.table('./UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ')

# Merges the training and the test sets to create one data set

xData <- rbind(x_train, x_test)
yData <- rbind(y_train, y_test)
subjectData <- rbind(subject_train, subject_test)
dim(xData)
dim(yData)
dim(subjectData)

# Extracts only the measurements on the mean and standard deviation for each measurement.

xDataSet_mean_std <- xData[, grep("-(mean|std)\\(\\)", features[, 2])]
names(xDataSet_mean_std) <- features[grep("-(mean|std)\\(\\)", features[, 2]), 2] 
dim(xDataSet_mean_std)

# Uses descriptive activity names to name the activities in the data set

activity_labels <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)
yData[, 1] <- activity_labels[yData[, 1], 2]
names(yData) <- "Activity"

names(subjectData) <- "Subject"

# Appropriately labels the data set with descriptive variable names.

DataSet <- cbind(xDataSet_mean_std, yData, subjectData)
names(DataSet) <- make.names(names(DataSet))
names(DataSet) <- gsub('Acc',"Acceleration",names(DataSet))
names(DataSet) <- gsub('GyroJerk',"AngularAcceleration",names(DataSet))
names(DataSet) <- gsub('Gyro',"AngularSpeed",names(DataSet))
names(DataSet) <- gsub('Mag',"Magnitude",names(DataSet))
names(DataSet) <- gsub('^t',"TimeDomain.",names(DataSet))
names(DataSet) <- gsub('^f',"FrequencyDomain.",names(DataSet))
names(DataSet) <- gsub('\\.mean',".Mean",names(DataSet))
names(DataSet) <- gsub('\\.std',".StandardDeviation",names(DataSet))
names(DataSet) <- gsub('Freq\\.',"Frequency.",names(DataSet))
names(DataSet) <- gsub('Freq$',"Frequency",names(DataSet))

# creates a tidy data set with the average of each variable for each activity and each subject.
TidyData<-aggregate(. ~Subject + Activity, DataSet, mean)
TidyData<-TidyData[order(TidyData$Subject,TidyData$Activity),]
write.table(TidyData, file = "tidydata.txt",row.name=FALSE)
