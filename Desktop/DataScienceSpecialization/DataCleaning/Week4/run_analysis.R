
install.packages("reshape2")
library(reshape2)

### 1.Load data 
### OUTPUT: data with train and test datasets merged 

#Create project file in working directory 
if (!file.exists("./project")){dir.create("./project")}

#Download data and unzip
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile ="./project/data.zip",method="curl" )
unzip("./project/data.zip")

#Load train and test datasets 
test_subjects<-read.table("./UCI HAR Dataset/test/subject_test.txt")
test_x<-read.table("./UCI HAR Dataset/test/X_test.txt")
test_y<-read.table("./UCI HAR Dataset/test/Y_test.txt")

train_subjects<-read.table("./UCI HAR Dataset/train/subject_train.txt")
train_x<-read.table("./UCI HAR Dataset/train/X_train.txt")
train_y<-read.table("./UCI HAR Dataset/train/Y_train.txt")

#Merge datasets 
test<-cbind(test_subjects,test_x,test_y)
train<-cbind(train_subjects,train_x,train_y)
data<-rbind(test,train)


### 2.Create labels for data & name activities 
### OUTPUT: total with labels
names<-read.table("./UCI HAR Dataset/features.txt")
activity<-read.table("./UCI HAR Dataset/activity_labels.txt")

colnames(data)<-c("subject",as.character(names[,2]),"activity")
colnames(activity)<-c("activity","description")

totaldata<- merge(data,activity,by="activity")

### 3.Create Summary and tidy .txt 
totaldata_melt<-melt(totaldata, id.vars = c("subject", "activity","description"))
totaldata_mean<-dcast(totaldata_melt,subject+activity + description ~ variable, mean)

write.table(totaldata_mean, "tidy.txt", row.names = FALSE, quote = FALSE)
