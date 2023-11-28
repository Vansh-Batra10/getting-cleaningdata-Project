url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if (!file.exists('./UCI HAR Dataset.zip')){
  download.file(url,'./UCI HAR Dataset.zip', mode = 'wb')
  unzip("UCI HAR Dataset.zip", exdir = getwd())
}
library(dplyr)
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)
mean_std_features <- grep("-(mean|std)\\(\\)", features$functions)
x_data <- x_data[, mean_std_features]
y_data$code <- activities[y_data$code, "activity"]
names(x_data) <- gsub("\\(|\\)", "", names(x_data))
names(x_data) <- tolower(names(x_data))
tidy_data <- cbind(subject_data, y_data, x_data)
tidy_data <- tidy_data %>%
  group_by(subject, code) %>%
  summarise_all(mean)
write.table(tidy_data, file = "tidy_data.txt", row.names = FALSE)

