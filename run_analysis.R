download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "data")
unzip("data")
library(LaF)

##LaF Data
xtrain<-laf_open_fwf("UCI HAR Dataset/train/X_train.txt", 
                     column_types = rep("numeric", 561), 
                     column_widths = rep(16, 561))
xtest<-laf_open_fwf("UCI HAR Dataset/test/X_test.txt", 
                    column_types = rep("numeric", 561), 
                    column_widths = rep(16, 561))

##number of columns with mean or std
features<-read.csv("UCI HAR Dataset/features.txt", sep = " ", header = FALSE)
cols<-vector()
cols<-c(cols, grep("mean", features[,2], ignore.case=T))
cols<-c(cols, grep("std", features[,2], ignore.case=T))
cols<-sort(cols)

##filter for columns with mean or std
xcomp<-xtrain[,cols]
##combind test & train sets
xcomp<-rbind(xcomp, xtest[,cols])

##make subject column
subtrain <- read.csv("UCI HAR Dataset/train/subject_train.txt", 
                         header = FALSE)
subtest <- read.csv("UCI HAR Dataset/test/subject_test.txt", 
                     header = FALSE)
subject<-rbind(subtrain,subtest)

##make activity column
acttrain<-read.csv("UCI HAR Dataset/train/y_train.txt", 
                   header = FALSE)
acttest<-read.csv("UCI HAR Dataset/test/y_test.txt", 
                  header = FALSE)
activity<-rbind(acttrain, acttest) 

##bind subject & activity to data frame
xcomp<-cbind(activity, subject, xcomp)

##label xcomp columns
colnames(xcomp)<- c("activity", "subject", as.character(features[cols,2]))

##build table of means,
tidy<-data.frame(matrix(ncol = 88))
for (i in 1:6)(
        for (j in 1:30) (
                tidy[((i-1)*30)+j,]<-c(i,j,colMeans((subset(xcomp, activity == i & subject == j))[,3:88]))
))

##label tidy columns
colnames(tidy)<- c("activity", "subject", as.character(features[cols,2]))

##alter activity to character
activitylabels<-read.csv("UCI HAR Dataset/activity_labels.txt", sep = " ", header = FALSE)
for (i in 1:length(tidy$activity)){
        for (j in 1:6) {
                if (tidy$activity[i] == j) {
                        tidy$activity[i]<-as.character(activitylabels$V2[j])
                }}}