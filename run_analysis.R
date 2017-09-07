# run_analysis.R that does the following.
# 
# 1-Merges the training and the test sets to create one data set.
# 2-Extracts only the measurements on the mean and standard deviation for each measurement.
# 3-Uses descriptive activity names to name the activities in the data set
# 4-Appropriately labels the data set with descriptive variable names.
# 5-From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#Data link for download:
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#Data link for description:
#http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## 1-Merges the training and the test sets to create one data set.
#loading common files
feat<-read.table("features.txt")
act_labels<-read.table("activity_labels.txt")

# Loading required files for training

X_tr<-read.table("train/X_train.txt")
y_tr<-read.table("train/y_train.txt")
subj_tr<-read.table("train/subject_train.txt")
#name columns
names (X_tr)<-feat$V2
names(subj_tr)<-"subject"
names(y_tr)<-"activity"
#combine training in one table + add type column
dt_tr<-cbind(X_tr, y_tr, subj_tr)

# Loading required files for test
X_ts<-read.table("train/X_train.txt")
y_ts<-read.table("train/y_train.txt")
subj_ts<-read.table("train/subject_train.txt")
#name columns
names (X_ts)<-feat$V2
names(subj_ts)<-"subject"
names(y_ts)<-"activity"
#combine test in one table
dt_ts<-cbind(X_ts, y_ts, subj_ts)

#Combine all in one
dt<-rbind(dt_tr,dt_ts)

##2-Extracts only the measurements on the mean and standard deviation for each measurement.
#filtering the names finishing by mean() or std() and keep y, subject, type

selection<-grepl("mean..$|std..$|^activity$|^subject$",names(dt))
#push the filtered data back to dt variable
dt<-dt[,selection]

## 3-Uses descriptive activity names to name the activities in the data set
#by subsetting the activity column, replacement with corresponding label from activity_label file
dt$activity<-as.character(act_labels$V2[as.numeric(dt$activity)])

# 4-Appropriately labels the data set with descriptive variable names.

# The data frame was already included at step 1. I found easier and safer to add the labels before combining columns

##5-From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(reshape2)
#define activity and subject as the ids for reshaping
dt_Melt<-melt(dt,id.vars = c("activity","subject") )
#create a table of mean grouped for each variable by activity by subject
dt_Mean<-dcast(dt_Melt, activity + subject ~variable, mean)

#Saving the dt_Mean dataframe
write.table(dt_Mean,file = "dt_Mean.txt",row.names = FALSE)

## Here's R code suggested to view the dt_Mean dataframe file.
#data <- read.table("dt_Mean.txt", header = TRUE)
#View(data)
