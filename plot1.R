# plot1.R

# File names
source_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
source_zip_file <- "exdata-data-household_power_consumption.zip"
source_text_file <- "household_power_consumption.txt"
output_file <- "plot1.png"

# Get the source data file, unzip in the working directory.
# source_text_file contains the name of the file we want from the zip archive.
download.file(source_url, destfile = source_zip_file, method = "curl")
unzip(source_zip_file)

# Read all the data from the text file into a dataframe.
all_df <- read.table(source_text_file, 
                     sep = ";", 
                     header = TRUE, 
                     stringsAsFactors = FALSE
                    )

# Extract only the data that is needed.
library(dplyr)
two_year_df_1 <- filter(all_df, grepl("^[12]/2/2007", all_df$Date))

# Translate strings into numerics.
two_year_df <- mutate(two_year_df_1, 
                      Global_active_power = as.numeric(Global_active_power)
               )

# Plot it.
hist(two_year_df$Global_active_power, 
     xlab = "Global Active Power (kilowatts)", 
     main = "Global Active Power", 
     col = "red")

# Png it.
dev.copy(png, file=output_file)
dev.off()


