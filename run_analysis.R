library(dplyr)

clean_data <- function() {
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
  
  meanfreq_correction <- grep("meanFreq",names(data_meanstd))
  data_meanstd <- data_meanstd[-meanfreq_correction]
  
  activities <- rbind(read.csv("UCI HAR Dataset/train/y_train.txt", header = FALSE),read.csv("UCI HAR Dataset/test/y_test.txt",header = FALSE))
  
  activities_name <- read.csv("UCI HAR Dataset//activity_labels.txt", sep=" ", header=FALSE)
  
  for (i in 1:6){activities[activities==i] <- as.character(activities_name[i,2])}
  
  names(activities) <- "Activity"
  data_activities <- cbind(activities,data_meanstd)
  
  subject <- rbind(read.table("UCI HAR Dataset/train//subject_train.txt"),read.table("UCI HAR Dataset/test/subject_test.txt"))
  
  names(subject) <- "Subject"
  
  data_complete <- cbind(subject,data_activities)
  data_complete  
}
  


make_tidy <- function(m) {
  tidy_mean <- data.frame(matrix(ncol = ncol(m)))
  k<-0
  
  for (i in sort(unique(m[,1]))) {
    for (j in unique(m[,2])) {
      k <- k+1
      tmp_tab <- filter(m,Subject==i & Activity == j)
      tmp_mean <- sapply(tmp_tab[3:ncol(tmp_tab)],mean)
      tmp_id <- c(i,j)
      tmp_row <- c(tmp_id,tmp_mean)
      tidy_mean[k,]<-tmp_row
    }
  }
  names(tidy_mean) <- names(m)
  

  
  write.table(tidy_mean,"tidy_mean.txt",row.name=FALSE,sep=",")
  
  tidy_mean
  
}

#usage :
#u<-clean_data()
#v<-make_tidy(u)

#make_tidy