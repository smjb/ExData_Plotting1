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

power_data$Global_active_power <- as.numeric(power_data$Global_active_power) 
power_data$Global_reactive_power <- as.numeric(power_data$Global_reactive_power)
power_data$Global_intensity <- as.numeric(power_data$Global_intensity)
power_data$Voltage <- as.numeric(power_data$Voltage)
power_data$Sub_metering_1 <- as.numeric(power_data$Sub_metering_1)
power_data$Sub_metering_2 <- as.numeric(power_data$Sub_metering_2)
power_data$Sub_metering_3 <- as.numeric(power_data$Sub_metering_3)

p2 <- transform(power_data, d = dmy(Date), t = hms(Time))
power_data <- transform(p2, dt = d+t)
rm(p2)

png("plot_1.png", width = 480, height = 480, units = "px", bg = "transparent")

hist(power_data$Global_active_power, freq=T, col="red", xlab="Global Active Power (kilowatts)", ylim = range(0,1200), main = "Global Active Power")
dev.off()
