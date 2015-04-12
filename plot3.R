UCIEPC <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Wrangle data
FILENAME <- "plot2.png"
TEMPFILE <- tempfile()
download.file(url = UCIEPC, destfile = TEMPFILE)
unzip(TEMPFILE, overwrite = T)
epcfile <- unzip(TEMPFILE, list = T)$Name
epcframe <- read.csv(epcfile, header = T, sep = ";", na.strings = c("?"))
epcframe <- epcframe[grepl("^0?[12]/0?2/2007", epcframe$Date), ]
epcframe <- transform(epcframe, Time = paste(Date, Time))
epcframe <- transform(epcframe, Time = strptime(Time, "%d/%m/%Y %H:%M:%S", tz = "GMT"))
epcframe <- transform(epcframe, Global_active_power = as.numeric(Global_active_power))
epcframe <- transform(epcframe, Sub_metering_1 = as.numeric(Sub_metering_1))
epcframe <- transform(epcframe, Sub_metering_2 = as.numeric(Sub_metering_2))
epcframe <- transform(epcframe, Sub_metering_3 = as.numeric(Sub_metering_3))

# Show on screen for convenience
with(epcframe,plot(y = Sub_metering_1, x = Time, 
                   type = "n",
                   xlab = "",
                   ylab = "Energy sub metering"))
with(epcframe, lines(y = Sub_metering_1, x = Time, col="black"))
with(epcframe, lines(y = Sub_metering_2, x = Time, col="red"))
with(epcframe, lines(y = Sub_metering_3, x = Time, col="blue"))
legend("topright", 
       col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty= c(1, 1, 1))

# Write to file as required
png(filename = FILENAME)
with(epcframe,plot(y = Sub_metering_1, x = Time, 
                   type = "n",
                   xlab = "",
                   ylab = "Energy sub metering"))
with(epcframe, lines(y = Sub_metering_1, x = Time, col="black"))
with(epcframe, lines(y = Sub_metering_2, x = Time, col="red"))
with(epcframe, lines(y = Sub_metering_3, x = Time, col="blue"))
legend("topright", 
       col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty= c(1, 1, 1))
dev.off()

# Clean up
sapply(c(TEMPFILE, epcfile), function(epcfilename) { file.remove(epcfilename) })