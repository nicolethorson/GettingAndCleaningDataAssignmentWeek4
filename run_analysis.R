# Load the dplyr library

library(dplyr)

#read in all of the files in the train folder
xtrain<- read.table("/users/nicolemurphy012/desktop/coursera/assignment/UCRData/train/X_train.txt")
ytrain<- read.table("/users/nicolemurphy012/desktop/coursera/assignment/UCRData/train/y_train.txt")
subjecttrain<- read.table("/users/nicolemurphy012/desktop/coursera/assignment/UCRData/train/subject_train.txt")

#read in all of the files in the test folder
xtest<- read.table("/users/nicolemurphy012/desktop/coursera/assignment/UCRData/test/X_test.txt")
ytest<- read.table("/users/nicolemurphy012/desktop/coursera/assignment/UCRData/test/y_test.txt")
subjecttest<- read.table("/users/nicolemurphy012/desktop/coursera/assignment/UCRData/test/subject_test.txt")

#read in features file
variableName <-read.table("/users/nicolemurphy012/desktop/coursera/assignment/UCRData/features.txt")

#read in activity labels file
activity <- read.table("/users/nicolemurphy012/desktop/coursera/assignment/UCRDATA/activity_labels.txt")

#merge the train and test files together through rbind (Task #1)
XCombined <- rbind(xtrain,xtest)
YCombined <- rbind(ytrain,ytest)
SubjectCombined <- rbind(subjecttrain, subjecttest)

# extract out the mean and standard deviation from each measurement (task #2)
selected <- variableName[grep("mean\\(\\)|std\\(\\)",variableName[,2]),]
XCombined <- XCombined[,selected[,1]]

# Use descriptive activity names to name activities in data set (Task #3)
colnames(YCombined) <- "activity"
YCombined$activitylabel <- factor(YCombined$activity, labels = as.character(activity[,2]))
activity <- YCombined[,-1]

# appropriately label data det with descriptive variable names (Task #4)
colnames(XCombined) <- variableName[selected[,1],2]

# from data set in #4, creates a second, independent tidy data set with average of each variable for each activity and each subject
colnames(SubjectCombined)<-"subject"
total<- cbind(XCombined,activity, SubjectCombined)
total_mean<- total %>% group_by(activity, subject) %>% summarize_all(funs(mean))
write.table(total_mean, file="/users/nicolemurphy012/desktop/coursera/assignment/tidydata.txt", row.names=FALSE, col.names=TRUE)
