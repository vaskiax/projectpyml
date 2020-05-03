#
# NOTE: This code assumes you have executed the code from Module 4 - Preparing your data, and that the 
# objects created by that code are in memory.  This code will use these objects.  If the objects
# are not present, this code will fail.
#


#----------------------------------------------------------------
# Training the Algorithm
#----------------------------------------------------------------
# Download and install caret locally
install.packages('caret')

# Load caret
library(caret)



# Set random number seed for reproducability
set.seed(122515)

# set the columns we are going to use to train algorithm
featureCols <- c("ARR_DEL15", "DAY_OF_WEEK", "CARRIER", "DEST","ORIGIN","DEP_TIME_BLK")

# created filtered version of onTimeData dataframe
onTimeDataFiltered <- onTimeData[,featureCols]
# create vector contain row indicies to put into the training data frames
inTrainRows <- createDataPartition(onTimeDataFiltered$ARR_DEL15, p=0.70, list=FALSE)
# check the row IDs
head(inTrainRows,10)
# Create the training data frame
trainDataFiltered <- onTimeDataFiltered[inTrainRows,]
# Create the testing data frame.  Notice the prefix "-" 
testDataFiltered <- onTimeDataFiltered[-inTrainRows,]


# Check split 
#   Should be 70%
nrow(trainDataFiltered)/(nrow(testDataFiltered) + nrow(trainDataFiltered))
#   Should be 30%
nrow(testDataFiltered)/(nrow(testDataFiltered) + nrow(trainDataFiltered))


# Create a train prediction model

#  Logistic Regression
logisticRegModel <- train(ARR_DEL15 ~ ., data=trainDataFiltered, method="glm", family="binomial",
                          trControl=trainControl(method="cv", number=10, repeats=10))
# Output model
#logisticRegModel

