# This function downloads the dataset and unzips the contents to the current working directory.
RetrieveDataFunc <- function()
{
  download.file(url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile="exdata_data_household_power_consumption.zip")
  unzip("exdata_data_household_power_consumption.zip")
}


print (paste("Running in", getwd()))
print ("Files will be retrieved to this directory, and you may wish to remove them when done.")

#Checks if data file exists, if not calls RetrieveDataFunc to download and extract dataset.
if ( !file.exists("household_power_consumption.txt"))
{ print ("Data files were not found, retrieving files...")
  RetrieveDataFunc()
  print ("Files retrieved.")
}else{
  print ("Found data files, skipping download step.")
}
print ("Loading the data...")

#Reads in the data with read.table
PowerConsumption <- read.table(file="household_power_consumption.txt", sep=";", header=TRUE, na.strings="?", stringsAsFactors=FALSE)
print ("Data loaded, creating subset of data for specific dates")

#Creates a subset of the data to the specific dates of interest.
PowerConsumptionSub <- subset (PowerConsumption, subset= PowerConsumption$Date %in% c("1/2/2007", "2/2/2007"))
print ("Data subset created for dates between 2007-02-01 and 2007-02-02")

#Adds an additional TimeStamp field to the data subset, combines date and time, and converts it to an R datetime format.
print ("Converting dates and times to timestamp in R date format.")
PowerConsumptionSub$TimeStamp <- paste(PowerConsumptionSub$Date, PowerConsumptionSub$Time) 
PowerConsumptionSub$TimeStamp <- strptime(PowerConsumptionSub$TimeStamp, format = "%d/%m/%Y %H:%M:%S")

#Generates plot2.png
png(filename="plot2.png", width=480, height=480, type="cairo")
plot(PowerConsumptionSub$TimeStamp, PowerConsumptionSub$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
dev.off()
print (paste(getwd(),"/plot2.png has been created.", sep=""))