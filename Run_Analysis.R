#######
# Assignment - Getting and Cleaning Data
#######
setwd("C:/Users/xxxxxx/Documents/R- Assignment/Assignment - Getting and cleaning Data - Week 4/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")
filepath <- getwd()

####
# Read training Data from Subject, Activities and Features files
####
Var_Subject_Train  <- read.table(file.path(filepath, "train", "subject_train.txt"), header = FALSE)
Var_Activity_Train <- read.table(file.path(filepath, "train", "y_train.txt"), header = FALSE)
Var_Features_Train <- read.table(file.path(filepath, "train", "X_train.txt"), header = FALSE)

####
# Read test Data from Subject, Activities and Features files
####
Var_Subject_Test  <- read.table(file.path(filepath, "test", "subject_test.txt"), header = FALSE)
Var_Activity_Test <- read.table(file.path(filepath, "test", "y_test.txt"), header = FALSE)
Var_Features_Test <- read.table(file.path(filepath, "test", "X_test.txt"), header = FALSE)


#####
# Merge rows of test and train files of various types
#####

Merged_Subject <- rbind(Var_Subject_Train, Var_Subject_Test)
Merged_Actvity <- rbind(Var_Activity_Train,Var_Activity_Test)
Merged_Features <- rbind(Var_Features_Train, Var_Features_Test)

# Set names to the variables
names(Merged_Subject) <- c("subject")
names(Merged_Actvity) <- c("activity")
Merged_FeaturesNames <- read.table(file.path(filepath, "features.txt"), head=FALSE)
names(Merged_Features) <- Merged_FeaturesNames$V2

# combine data and create the final merged file
dataCombine <- cbind(Merged_Subject, Merged_Actvity)
Final_Merged_File <- cbind(Merged_Features, dataCombine)

subMerged_FeaturesNames <- Merged_FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)",Merged_FeaturesNames$V2)]
selectedNames <- c(as.character(subMerged_FeaturesNames), "subject", "activity")
Final_Merged_File  <- subset(Final_Merged_File , select = selectedNames)


#3.Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table(file.path(filepath, "activity_labels.txt"), header = FALSE)

Data$activity <- factor(Data$activity, levels = activityLabels[, 1], labels = activityLabels[, 2])

#4.Appropriately labels the data set with descriptive variable names. 
names(Data) <-gsub("^t", "time", names(Data))
names(Data) <-gsub("Gyro", "Gyroscope", names(Data))
names(Data) <-gsub("Mag", "Magnitude", names(Data))
names(Data) <-gsub("BodyBody", "Body", names(Data))
names(Data) <-gsub("^f", "frequency", names(Data))
names(Data) <-gsub("Acc", "Accelerometer", names(Data))

# combine data and create the final merged tidy file

Final_Merged_Tidy_File  <- aggregate(. ~subject + activity, Data, mean)
Final_Merged_Tidy_File <- Final_Merged_Tidy_File[order(Final_Merged_Tidy_File$subject, Final_Merged_Tidy_File$activity),]

write.table(Final_Merged_Tidy_File, file="tidy_Data.txt", row.names = FALSE)
