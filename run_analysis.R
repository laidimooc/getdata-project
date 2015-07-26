library(dplyr)

if(!file.exists("UCI HAR Dataset")) {
  if(!file.exists("getdata_projectfiles_UCI HAR Dataset.zip")) {
    print ("Downloading data")
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL,"getdata_projectfiles_UCI HAR Dataset.zip")
    }
  print("Unzipping file")
  unzip("getdata_projectfiles_UCI HAR Dataset.zip")
}

print("Merging data")
merged_data <- rbind(read.table("UCI HAR Dataset/train/X_train.txt"),read.table("UCI HAR Dataset/test/X_test.txt"))



titles <- read.csv("UCI HAR Dataset/features.txt",sep = " ",header = FALSE)
index_titles <- sort(c(grep("mean",titles[,2]),grep("std",titles[,2])))

titles[,2]<-gsub("\\(|\\)","",titles[,2])
titles[,2]<-gsub("-","_",titles[,2])
#titles[,2]<-tolower(titles[,2])



data_meanstd <- merged_data[,index_titles]

names(data_meanstd) <- titles[index_titles,2]


activities <- rbind(read.csv("UCI HAR Dataset/train/y_train.txt", header = FALSE),read.csv("UCI HAR Dataset/test/y_test.txt",header = FALSE))

activities_name <- read.csv("UCI HAR Dataset//activity_labels.txt", sep=" ", header=FALSE)

for (i in 1:6){activities[activities==i] <- as.character(activities_name[i,2])}

names(activities) <- "Activity"
data_activities <- cbind(activities,MeanStd_data)

subject <- rbind(read.table("UCI HAR Dataset/train//subject_train.txt"),read.table("UCI HAR Dataset/test/subject_test.txt"))

names(subject) <- "Subject"

data_complete <- cbind(subject,data_activities)

tidy_mean <- data.frame(matrix(ncol = ncol(data_complete)))
k<-0

for (i in sort(unique(data_complete[,1]))) {
  for (j in unique(data_complete[,2])) {
    k <- k+1
    tmp_tab <- filter(data_complete,Subject==i & Activity == j)
    tmp_mean <- sapply(tmp_tab[3:ncol(tmp_tab)],mean)
    tmp_id <- c(i,j)
    tmp_row <- c(tmp_id,tmp_mean)
    tidy_mean[k,]<-tmp_row
  }
}
names(tidy_mean) <- names(data_complete)

meanfreq_correction <- grep("meanFreq",names(tidy_mean))
tidy_mean <- tidy_mean[-meanfreq_correction]

write.table(tidy_mean,"tidy_mean.txt",row.name=FALSE,sep=",")

rm(tmp_id,tmp_mean,tmp_row,tmp_tab,k)
