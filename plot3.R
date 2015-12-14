# plot3.R

# clean environment
rm(list=ls())

# File names
source_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
source_zip_file <- "exdata-data-household_power_consumption.zip"
source_text_file <- "household_power_consumption.txt"
output_file <- "plot3.png"

# Get the source data file, unzip in the working directory.
# source_text_file contains the name of the file we expect from the zip archive.
download.file(source_url, destfile = source_zip_file, method = "curl")
unzip(source_zip_file)

# Read all the data from the text file into a dataframe.
all_df <- read.table(source_text_file, 
                     sep = ";", 
                     header = TRUE, 
                     stringsAsFactors = FALSE
)

# Extract only the data that is needed: Feb. 1 and 2, 2007
library(dplyr)
two_year_df_1 <- filter(all_df, grepl("^[12]/2/2007", all_df$Date))

# Translate strings into numerics.
two_year_df_2 <- mutate(two_year_df_1, 
                        Sub_metering_1 = as.numeric(Sub_metering_1),
                        Sub_metering_2 = as.numeric(Sub_metering_2),
                        Sub_metering_3 = as.numeric(Sub_metering_3)
)

# Create a new DateTime column out of the Date and Time columns.
two_year_df <- mutate(two_year_df_2, 
                      DateTime = as.POSIXct(paste(Date, Time), 
                                            "%e/%m/%Y %H:%M",
                                            tz = "")
)

# First, plot an empty frame that fits the max dimensions.
plot(
        two_year_df$DateTime,
        two_year_df$Sub_metering_1,
        xlab = NA,
        ylab = "Energy sub metering",
        type = "n"
)

# Overlay the legend.
# I had to add padding-right to the legend text by appending spaces.
# Although the text fit properly on the screen without padding, when rendered to
# the png, the text was too large and got clipped by the border.
legend(
       x = as.POSIXct("2/2/2007 08:00", "%e/%m/%Y %H:%M", tz = ""), 
       y = 40,      
       inset = 0,
       lty = 1, lwd = 2, col = c("black", "red", "blue"),
       legend = paste("Sub_metering_", c("1", "2", "3"), "            ", sep = ""),
       cex = .75
)


# Overlay the data as a line chart.
lines(two_year_df$DateTime, two_year_df$Sub_metering_1, type="l", col="black")
lines(two_year_df$DateTime, two_year_df$Sub_metering_2, type="l", col="red")
lines(two_year_df$DateTime, two_year_df$Sub_metering_3, type="l", col="blue")

# Png it.
dev.copy(png, file = output_file, width = 480, height = 480)
dev.off()


