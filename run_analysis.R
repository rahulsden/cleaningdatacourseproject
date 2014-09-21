read_activity_label_func <- function(filename)
{
    filename <- paste(filename, ".txt", sep = "")
    activityLabelDS <- read.table(filename, sep = "", as.is=TRUE)
    names(activityLabelDS) <- c("activityID", "activityName")
    activityLabelDS
}

read_features_label_func <- function(filename)
{
    filename <- paste(filename, ".txt", sep = "")
    featuresLabelDS <- read.table(filename, sep = "")
    names(featuresLabelDS) <- c("featureID", "featureName")
    featuresLabelDS
}

read_subject_order_func <- function (filename)
{
    filename <- paste(filename, ".txt", sep = "")
    subjectOrderDS <- read.table(filename, sep = "")
    names(subjectOrderDS) <- c("Subject")
    subjectOrderDS
}

read_y_order_func <- function (filename)
{
    filename <- paste(filename, ".txt", sep = "")
    yOrderDS <- read.table(filename, sep = "")
    names(yOrderDS) <- c("ActivityDescription")
    yOrderDS
}

read_X_order_func <- function (filename)
{
    filename <- paste(filename, ".txt", sep = "")
    XOrderDS <- read.table(filename, sep = "")
    XOrderDS    
}

#list of columns with mean and std data in 561 length vector form X_*.txt
validMeanStdData <- c(1, 2, 3, 4, 5, 6, 41, 42, 43, 44, 45, 46, 81, 82, 83, 84, 85, 86, 121, 122, 123, 124, 125, 126, 161, 162, 163, 164, 165, 166, 201, 202, 214, 215, 227, 228, 240, 241, 253, 254, 266, 267, 268, 269, 270, 271, 345, 346, 347, 348, 349, 350, 424, 425, 426, 427, 428, 429, 503, 504, 516, 517, 529, 530, 542, 543
)

read_data_set_func <- function(dataSetDir, dataSetName, featuresLabelDS, activityLabelDS)
{
    cwd <- getwd();
    setwd(dataSetDir)
    print("    Read subject order data...")
    subjectOrderDS <- read_subject_order_func(paste("subject", dataSetName, sep = "_"))
    print("    Read y order data...")
    yOrderDS <- read_y_order_func(paste("y", dataSetName, sep = "_"))
    print("    Read x order data...")
    XOrderDS <- read_X_order_func(paste("X", dataSetName, sep = "_"))
    setwd(cwd)
    
    #ensure that all the datasets are of the same size
    if ((nrow(subjectOrderDS) != nrow(yOrderDS)) | (nrow(yOrderDS) != nrow(XOrderDS)))
    {
        print("    Error in data set : ", dataSetName)
        return(0)
    }
    
    #Appropriately labels the data set with descriptive variable names
    print("    Assign feature labels to X Order")
    names(XOrderDS) <- featuresLabelDS[, "featureName"]
    
    #Extracts only the measurements on the mean and standard deviation for each measurement
    XOrderDS <- XOrderDS[, validMeanStdData]
    
    print("    Generate data frame for set ...")
    data.frame(subjectOrderDS, yOrderDS, XOrderDS)
}


#This is the starting function. This function should be called after sourcing this script
# This writes the "output.txt' with the summarized data in the current working directory
# It also returns the summarized data frame
main_func <- function()
{
    print("Read activity label data...")
    activityLabelDS <- read_activity_label_func("activity_labels")
    str(activityLabelDS)
    print(class(activityLabelDS$activityName))

    print("Read features label data...")
    featuresLabelDS <- read_features_label_func("features")

    print("Read training data...")
    trainSetDS <- read_data_set_func("train/", "train", featuresLabelDS, activityLabelDS)

    print("Read test data...")
    testSetDS <- read_data_set_func("test/", "test", featuresLabelDS, activityLabelDS)

    print("Merge training and test data...")
    mergedSetDS <- rbind(trainSetDS, testSetDS)
    
    print("Extract summarised data (step-5)")
    library(dplyr)
    summarySetDs <- ddply(mergedSetDS, c("Subject", "ActivityDescription"), summarise_each, funs(mean))
    write.table(summarySetDs, file = "output.txt", row.names = FALSE)
    summarySetDs
}