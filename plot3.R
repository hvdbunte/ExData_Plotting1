## Use these libraries:
library(data.table)
library(dplyr)
library(lubridate)

## I assume that the zip file is placed in working directory.
## unzip the data in the workdirectory. 
UnzipFile <- unzip("exdata_data_household_power_consumption.zip")

## read file into R
dt <- fread(UnzipFile, header = TRUE)

## define start and end period.
Start_period <- ymd("2007-02-01")
End_period <- ymd("2007-02-03")

## Create tidy dataset of the unzipped data.
## create datetime field.
## Filter the datetime field for the specified period.
## Because all fields are character type convert them to numeric.
## Remove date and time field from dataset.
PlotData <- dt %>%
  mutate(datetime = dmy_hms(paste(Date, Time)) 
  ) %>%
  filter(datetime >= Start_period & datetime < End_period
  ) %>%
  mutate(Global_active_power = type.convert(Global_active_power)
         , Global_reactive_power = type.convert(Global_reactive_power)
         , Voltage = type.convert(Voltage)
         , Global_intensity = type.convert(Global_intensity)
         , Sub_metering_1 = type.convert(Sub_metering_1)
         , Sub_metering_2 = type.convert(Sub_metering_2)
  ) %>%
  select(datetime, everything(), -Date, -Time)

#Plot 3
# First open the file
# Second setup the graph without the lines.
# Third make the legend
# Fourth draw in the lines one by one. 
png(file = "plot3.png", width = 480, height = 480)
par(mar=c(3,5,1,2.1))
with(PlotData, plot(datetime, Sub_metering_1
                    , type = "n"
                    , ylab = "Energy Sub Metering"
)
)
legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
       , lwd = 2
       , col = c("Black","Red","Blue")
)
with(PlotData, lines(datetime, Sub_metering_1)
)
with(PlotData, lines(datetime, Sub_metering_2
                     , col = "Red" 
)
)
lines(PlotData$datetime, PlotData$Sub_metering_3 
      , col = "Blue"
)

dev.off()
