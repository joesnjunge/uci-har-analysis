library(dplyr)

# 1.Read to R  the training and the test sets to create one data set.
activities <- read.table("./data/activity_labels.txt", header = FALSE, 
                         col.names = c("activityId", "activityName"))

features <- read.table("./data/features.txt"
                       , header = FALSE, col.names = c("id","name"))

#x train
xtrain <- read.table("./data/train/X_train.txt", 
                     header = FALSE, sep = "", col.names = features$name )

colnames(xtrain) <- features$name

#y train
ytrain <- read.table("./data/train/y_train.txt", 
                     header = FALSE, sep = " ", col.names = "activityId" )

#subject train
subjecttrain <- read.table("./data/train/subject_train.txt", 
                     header = FALSE, sep = " ", col.names = "subjectId" )

# X Test
xtest <- read.table("./data/test/X_test.txt", sep = "",
                  header = FALSE)
colnames(xtest) <- features$name
#y test
ytest <- read.table("./data/test/y_test.txt", sep = " ", 
                    header = FALSE, col.names = "activityId")

#subject test

subjecttest <- read.table("./data/test/subject_test.txt", sep = " ", 
                          header = FALSE, col.names = "subjectId")

# merge training and test data for x, y, and subject
xdata <- rbind(xtrain, xtest)
ydata <- rbind(ytrain, ytest)
subjectdata <- rbind(subjecttrain, subjecttest)

#remove large variable from memory
rm(xtrain, xtest, ytrain, ytest, subjecttest, subjecttrain)

# merge subject, xdata, and y data - column binding
data <- cbind(subjectdata, xdata, ydata)

#clean up
rm(subjectdata, xdata, ydata)

# select the columns of interest. 
# 2. Extracts only the measurements on the mean 
    # and standard deviation for each measurement. 
# data <- data %>% select(subject, activity, 
 #                  grepl("mean()|std()",features$name, ignore.case = "True"))
#data <- data %>% select(subjectid, activityid, contains("mean()"),contains("std"))

colindices <- grep("mean\\(\\)|std\\(\\)", names(data))

data <- select (data, subjectId, activityId, all_of(colindices))

rm(colindices)
#order data by subject id, then activity id
data <- data %>% arrange(subjectId, activityId)

# tidy the columns
thecolumns <- gsub("\\(\\)", "", colnames(data))
thecolumns <- gsub("-","",thecolumns)
thecolumns <- gsub("mean","Mean", thecolumns)
thecolumns <- gsub("std","Std", thecolumns)
colnames(data) <-thecolumns
rm(thecolumns)


#merge with activity list 
# Uses descriptive activity names to name the activities in the data set
data <- merge( activities,data, by.x="activityId", by.y="activityId") %>% 
   arrange(subjectId, activityId)


# arrange columns: subject Id first then activity Name, then the measurements
groupeddata <- data %>% group_by(subjectId, activityId) %>%
  summarise(across(3:66,mean))

# drop activity id column now that we have activity name. Drop after grouping
data$activityId <- NULL

# dump data into files:
tidyPath <- "./data/tidy"
if(!dir.exists(tidyPath)) {
  dir.create(tidyPath)
}

# write the full data set (ungrouped).
write.table(data, file= paste(tidyPath,"full-har-dataset.txt", sep="/"), sep=" ", 
            quote=FALSE, col.names = TRUE)

write.table(groupeddata, file= paste(tidyPath,"summary-har-dataset.txt", sep="/"), sep=" ", 
            quote=FALSE,row.names = FALSE, col.names = TRUE)

##final clean up

rm(list = c("data", "groupeddata", "tidyPath"))