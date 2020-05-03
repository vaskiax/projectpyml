library(readr)
data <- read_csv("Documentos/Universidad/programing/ML-TRAINING/projectpyml/data.csv")

airports <-c ('ATL','LAX','ORD','DWF','JFK','SFO','CLT','LAS','PHX')
data <- subset(data, DEST %in% airports & ORIGIN %in% airports)
data$X23 <- NULL 
data$ORIGIN_AIRPORT_SEQ_ID <- NULL 
data$DEST_AIRPORT_SEQ_ID <- NULL 
onTimeData <- data[!is.na(data$DEP_DEL15) & data$DEP_DEL15!="" & !is.na(data$ARR_DEL15) & data$ARR_DEL15!="",]
onTimeData$ARR_DEL15 <- as.factor(onTimeData$ARR_DEL15)
onTimeData$DEP_DEL15 <- as.factor(onTimeData$DEP_DEL15)
onTimeData$DEST <- as.factor(onTimeData$DEST)
onTimeData$ORIGIN <- as.factor(onTimeData$ORIGIN)
onTimeData$ORIGIN_AIRPORT_ID <- as.factor(onTimeData$ORIGIN_AIRPORT_ID)
onTimeData$DEST_AIRPORT_ID <- as.factor(onTimeData$DEST_AIRPORT_ID)
onTimeData$DAY_OF_WEEK <- as.factor(onTimeData$DAY_OF_WEEK)
onTimeData$DEP_TIME_BLK <- as.factor(onTimeData$DEP_TIME_BLK)
onTimeData$OP_UNIQUE_CARRIER <- as.factor(onTimeData$OP_UNIQUE_CARRIER)
tapply(onTimeData$ARR_DEL15, onTimeData$ARR_DEL15, length)
