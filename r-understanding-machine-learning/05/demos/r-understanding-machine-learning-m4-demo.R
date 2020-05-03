# OnTime.R - R OnTime script
setwd("C:/Your folder were your csv file resides")

# Load the data into a data frame with columns and rows
origData <- read.csv2('.\\Jan_2015_ontime.csv', sep=",", header=TRUE, stringsAsFactors = FALSE)
# We specify the file path, separator, whether the CSV file's 1st row is clumn names, and how to treat strings.
nrow(origData)
# we read in in 469,969 rows of data

# That is a lot of rows to process so to speed thing up let's restrict data to only flight between certain large airports
airports <-c('ATL','LAX', 'ORD', 'DFW', 'JFK', 'SFO', 'CLT', 'LAS', 'PHX')
origData <- subset(origData, DEST %in% airports & ORIGIN %in% airports)
nrow(origData)
# just like that we are down to a more managable 32,716 rows



#Inspecting and Cleaning Data


# Let's visually inspect data to find obvious issues
head(origData,2)
# As we can see, we have a lot of columns.  Most are expected, but notice the last column "X" with values of NA.  The X caolumn was created
#  as part of the import from CSV.  And NA is the mean the data was "Not Available".  So it looks like that column can be dropped.
# But to be sure let's check the end of the data frame with the tail() function.
tail(origData,2)

# Yes, it definitely appears that the column X has no value so lets remove this column.
# The column can be removed by setting it's value to NULL
origData$X <- NULL
# Let's check the data again,
head(origData,2)
# yes the X column is gone

# In general we want eliminate any columns that we do not need.  
# In particular, we want to eliminate columns that are duplicates or provide the same information
# We can do this by 
# 1. Visual inspect if we have columns that are really the same.  But visual inspection is error prone
# and does not deal with a second issue of correlation.
# 2. Often there are correlated columns such as an ID and the text value for the ID.  
#    And these highly correlated columns usually do not add information about the 
#    how the data causes changes in the results, but do cause the effect of a field to be overly 
#    amplified because some algorithm naively treat ever columns as being independant and just as important.
#
head(origData,10)
# In looking at the data I see the possible correlations between ORIGIN_AIRPORT_SEQ_ID and ORIGIN_AIRPORT_ID
# and between DEST_AIRPORT_SEQ_ID and DEST_AIRPORT_ID.  I am not sure we will use these fields,
# but if they are correlated we need only one of each pair
#
#  Let's Check the values using corrilation function, cor().  Closer to 1 =>  more correlated
cor(origData[c("ORIGIN_AIRPORT_SEQ_ID", "ORIGIN_AIRPORT_ID")])
# Wow.  A perfect 1.  So ORIGIN_AIRPORT_SEQ_ID and ORIGIN_AIRPORT_ID are moving in lock step.
# Let's check DEST_AIRPORT_SEQ_ID, DEST_AIRPORT_ID
cor(origData[c("DEST_AIRPORT_SEQ_ID", "DEST_AIRPORT_ID")])
# Another perfect 1.  So DEST_AIRPORT_SEQ_ID and DEST_AIRPORT_SEQ_ID are also moving in lock step.
#
# Let's drop the columns ORIGIN_AIRPORT_SEQ_ID and DEST_AIRPORT_SEQ_ID since they are not providing
# any new data
origData$ORIGIN_AIRPORT_SEQ_ID <- NULL
origData$DEST_AIRPORT_SEQ_ID <- NULL

# UNIQUE_CARRIER and CARRIER also look related, actually they look like identical
# We can see if the are identical by filtering the rows to those we they are different.
# R makes this easy, no loops to write.  All iteration is done for us.
mismatched <- origData[origData$CARRIER != origData$UNIQUE_CARRIER,]
nrow(mismatched)
# 0 mismatched, so UNIQUE_CARRIER and CARRIER identical.  So let's rid of the UNIQUE_CARRIER column
origData$UNIQUE_CARRIER <- NULL
# let's see what origData looks like
head(origData,2)

# To do both these we filter rows as shown below.
onTimeData <- origData[!is.na(origData$ARR_DEL15) & origData$ARR_DEL15!="" & !is.na(origData$DEP_DEL15) & origData$DEP_DEL15!="",]
# Let's compare the number of rows in the new and old dataframes
nrow(origData)
nrow(onTimeData)

# Changing the format of a column and all of the data for the row in that column is hard in some languages 
# but simple in R.  
# We just type in a simple command
onTimeData$DISTANCE <- as.integer(onTimeData$DISTANCE)
onTimeData$CANCELLED <- as.integer(onTimeData$CANCELLED)
onTimeData$DIVERTED <- as.integer(onTimeData$DIVERTED)

#   Let's take the Arrival departure and delay fields.  Sometime algorithm perform better 
# when you change the fields into factors which are like enumeration values in other languages
# This allows the algorithm to use count of when a value is a discrete value. 
onTimeData$ARR_DEL15 <- as.factor(onTimeData$ARR_DEL15)
onTimeData$DEP_DEL15 <-as.factor(onTimeData$DEP_DEL15)

# Let also change some other columns factors
onTimeData$DEST_AIRPORT_ID <- as.factor(onTimeData$DEST_AIRPORT_ID)
onTimeData$ORIGIN_AIRPORT_ID <- as.factor(onTimeData$ORIGIN_AIRPORT_ID)
onTimeData$DAY_OF_WEEK <- as.factor(onTimeData$DAY_OF_WEEK)
onTimeData$DEST <- as.factor(onTimeData$DEST)
onTimeData$ORIGIN <- as.factor(onTimeData$ORIGIN)
onTimeData$DEP_TIME_BLK <- as.factor(onTimeData$DEP_TIME_BLK)
onTimeData$CARRIER <- as.factor(onTimeData$CARRIER)

# let see how many arrival delayed vs non delayed flights.  We use tapply to 
# see how many time ARR_DEL15 is TRUE, and how many times it is FALSE
tapply(onTimeData$ARR_DEL15, onTimeData$ARR_DEL15, length)
# We should check how many departure delayed vs non delayed flights
#tapply(onTimeData$DEP_DEL15, onTimeData$DEP_DEL15, length)
#
(6460 / (25664 + 6460))
# The fact that we have a reasonable number of delays (6460 / (25664 + 6460)) = 0.201 ~ (20%) is important.  

