#
# Module 7- Testing your model's accuracy
#

# NOTE: This code assumes you have executed the code from Module 4 and that the 
# objects created by that code are in memory.  This code will use these objects.  If the objects
# are not present, this code will fail.
#

#   Predict using trained model against test data

#   Logistic Regression
logRegPrediction <- predict(logisticRegModel, testDataFiltered)


#    Get detailed statistics of prediction versus actual via Confusion Matrix 
logRegConfMat <- confusionMatrix(logRegPrediction, testDataFiltered[,"ARR_DEL15"])
logRegConfMat

# Improving performance

# We use the Random Forest algorithm which creates multiple decision trees and uses bagging 
# to improve performance

#  install the package - this only needs to be done once.  After the package is installed
#  comment out this line unless you really want the latest version of the package to be downloaded
#  and installed
install.packages('randomForest')

#  load the random forest library into the current session
library(randomForest)

# This code will run for a while!  It ran for 8 minutes on a system with a i7-4790K, 16 GB of memory, and a 500 GB SSD.
rfModel <- randomForest(trainDataFiltered[-1], trainDataFiltered$ARR_DEL15, proximity = TRUE, importance = TRUE)
rfModel

#   Random Forest
rfValidation <- predict(rfModel, testDataFiltered)
#    Get detailed statistics of prediction versus actual via Confusion Matrix 
rfConfMat <- confusionMatrix(rfValidation, testDataFiltered[,"ARR_DEL15"])
rfConfMat

