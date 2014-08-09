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

#Generates plot3.png
png(filename="plot3.png", width=480, height=480, type="cairo")
ylimit <- 0
ylimit[2] <- max(PowerConsumptionSub$Sub_metering_1, PowerConsumptionSub$Sub_metering_2, PowerConsumptionSub$Sub_metering_3)
#plot(PowerConsumptionSub$TimeStamp, PowerConsumptionSub$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
plot(PowerConsumptionSub$TimeStamp, PowerConsumptionSub$Sub_metering_1, type="l", col="black", xlab="", ylab="Energy sub metering", ylim=ylimit)
lines(PowerConsumptionSub$TimeStamp, PowerConsumptionSub$Sub_metering_2, col="red")
lines(PowerConsumptionSub$TimeStamp, PowerConsumptionSub$Sub_metering_3, col="blue")
legend("topright", names(PowerConsumptionSub[7:9]), lty=1, col=c('black', 'red', 'blue'))
dev.off()
print (paste(getwd(),"/plot3.png has been created.", sep=""))