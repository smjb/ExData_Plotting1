require(lubridate)
require(sqldf)
require(dplyr)
require(data.table)
rm(power_data)

#using sqldf to selectively select lines of interest using sqlite syntax

power_data<-read.csv.sql("household_power_consumption.txt", sql="select * from file where Date = '1/2/2007' or Date = '2/2/2007'", sep=";", colClasses = "character")

#cleanup all "?" and empty field

power_data$Global_active_power[which(power_data$Global_active_power=="?")] <- NA
power_data$Global_reactive_power[which(power_data$Global_reactive_power=="?")] <- NA
power_data$Global_intensity[which(power_data$Global_intensity=="?")] <- NA
power_data$Voltage[which(power_data$Voltage=="?")] <- NA
power_data$Sub_metering_1[which(power_data$Sub_metering_1=="?")] <- NA
power_data$Sub_metering_2[which(power_data$Sub_metering_2=="?")] <- NA
power_data$Sub_metering_3[which(power_data$Sub_metering_3=="?")] <- NA
power_data$Sub_metering_3[which(power_data$Sub_metering_3=="")] <- NA

# reclass column
power_data$Global_active_power <- as.numeric(power_data$Global_active_power) 
power_data$Global_reactive_power <- as.numeric(power_data$Global_reactive_power)
power_data$Global_intensity <- as.numeric(power_data$Global_intensity)
power_data$Voltage <- as.numeric(power_data$Voltage)
power_data$Sub_metering_1 <- as.numeric(power_data$Sub_metering_1)
power_data$Sub_metering_2 <- as.numeric(power_data$Sub_metering_2)
power_data$Sub_metering_3 <- as.numeric(power_data$Sub_metering_3)

# create proper Date, Time and DateTime object
p2 <- transform(power_data, d = dmy(Date), t = hms(Time))
power_data <- transform(p2, dt = d+t)
rm(p2)

# plot as PNG
png("plot_4.png", width = 480, height = 480, units = "px", bg = "transparent")

par(mfcol = c(2, 2), mar=c(4,4,4,1), oma = c(1,0,0,0))
with(power_data, {
    plot(x=dt, y=Global_active_power, type="l", lwd=1, xlab="", ylab="Global Active Power (kilowatts)")
    plot(x=dt, y=Sub_metering_1, type="l", lwd=1, xlab="", ylab="Energy sub metering")
    lines(x=dt, y=Sub_metering_2, col="red", lwd=1)
    lines(x=dt, y=Sub_metering_3, col="blue", lwd=1)
    legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), lwd=1)
    plot(x=dt, y=Voltage, type="l", lwd=1, xlab="datetime", ylab="Voltage")
    plot(x=dt, y=Global_reactive_power, type="l", lwd=1, xlab="datetime", ylab="Global reactive power")
})

dev.off()
