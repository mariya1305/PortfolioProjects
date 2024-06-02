setwd("C:/Users/Mariya/Desktop/PROJECTS/R Weather/")


# Load in weather data from csv file

tempData <- read.csv("LADowntown.csv", header = TRUE, sep = ",")


# Set variables to use in plot

years <- tempData$Year
#month <- tempData$July


#max(month)
#min(month)

# Scatter plot time :)

#plot(years, month, xlab="Year", ylab="Temp", ylim=c(min(month)-5, max(month)+5))

# Set trend line

#tempModel = lm(month ~ years)
#abline(tempModel)


# Let's see if we can use our model for prediction using the p-value and r-squared

#summary(tempModel)

# Let's loop for all 12 months

colCount <- ncol(tempData) - 1

for (col in 2:colCount) {
  month <- tempData[[col]]
  pTitle <- colnames(tempData)[col]
  plot(years, month, main=pTitle, xlab="Year", ylab="Temp", ylim=c(40,100))
  tempModel = lm(month ~ years)
  abline(tempModel)
}
