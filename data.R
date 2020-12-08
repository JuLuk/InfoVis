# reading data in R

library("readxl")
SFB_data <- read_excel("SFB_data.xlsx")

# to see the fir 5 rows of te data 
head(SFB_data)

#str(SFB_data)

# split date and time
year <- format(SFB_data$TimeStamp, format="%Y")
month <- format(SFB_data$TimeStamp, format="%m")
day <- format(SFB_data$TimeStamp, format="%d")
time <- format(SFB_data$TimeStamp, format="%H:%M")

# adding new columns
SFB_data["Year"] <- year
SFB_data["Month"] <- month
SFB_data["Day"] <- day
SFB_data["Time"] <- time

SFB_data$TimeStamp <- NULL
SFB_data$Date <- NULL
#head(SFB_data)

# getting the range of times to create quarters 
sortedDesc <- sort(SFB_data$Time, decreasing = TRUE)
sortedAsc <- sort(SFB_data$Time, decreasing = FALSE)
earliest_record <- tail(sortedDesc, 1)
latest_record <- tail(sortedAsc, 1)


SFB_data$Year <-  as.integer(SFB_data$Year)
SFB_data$Month <-  as.integer(SFB_data$Month)
SFB_data$Day <-  as.integer(SFB_data$Day)

# get a subset of data, YEAR: 1994-2014 10 Yrs data
newdata <- subset(SFB_data, year >= 1994)

data <- data.frame(newdata)

colnames(data)

data1 <- data[, c("Year","Month","Day","Time", "Station.Number", "Depth", "Salinity", "Temperature", 
                  "Nitrite", "Ammonium", "Phosphate", "Silicate", "Distance.from.36", "Discrete.Chlorophyll", 
                  "Chlorophyll.a.a.PHA", "Fluorescence", "Calculated.Chlorophyll", "Discrete.Oxygen", "Oxygen.Electrode.Output","Oxygen.Saturation.percent",       
                  "Calculated.Oxygen","Discrete.SPM", "Optical.Backscatter", "Calculated.SPM", "Measured.Extinction.Coefficient",
                  "Calculated.Extinction.Coefficient")]



data_SFB <- data.frame(data1)
# missing values
length(data_SFB$Year)
## 146159
colSums(is.na(data_SFB))


# columns to remove that dont have values:

# Measured.Extinction.Coefficient
# Calculated.Extinction.Coefficient
# Optical.Backscatter                    
# Calculated.SPM 
# Calculated.Oxygen                      
# Discrete.SPM
# Oxygen.Electrode.Output         
# Oxygen.Saturation.percent 
# Calculated.Chlorophyll                   
# Discrete.Oxygen 
# Chlorophyll.a.a.PHA                      
# Fluorescence
# Discrete.Chlorophyll 
# Ammonium
# Silicate  142233
# Nitrite  143678
# Phosphate 142232

# Let's delete the columns that dont have any recorded values:

data_SFB$Ammonium <- NULL
data_SFB$Discrete.Chlorophyll <- NULL
data_SFB$Fluorescence <- NULL
data_SFB$Chlorophyll.a.a.PHA <- NULL
data_SFB$Discrete.Oxygen <- NULL
data_SFB$Calculated.Chlorophyll <- NULL
data_SFB$Oxygen.Saturation.percent <- NULL
data_SFB$Oxygen.Electrode.Output <- NULL
data_SFB$Discrete.SPM <- NULL
data_SFB$Calculated.Oxygen <- NULL
data_SFB$Calculated.SPM <- NULL
data_SFB$Optical.Backscatter <- NULL
data_SFB$Calculated.Extinction.Coefficient <- NULL
data_SFB$Measured.Extinction.Coefficient <- NULL

data_SFB$Silicate <- NULL
data_SFB$Nitrite <- NULL
data_SFB$Phosphate <- NULL



colSums(is.na(data_SFB))

data_SFB$Salinity[is.na(data_SFB$Salinity)] = mean(data_SFB$Salinity, na.rm=TRUE)
data_SFB$Temperature[is.na(data_SFB$Temperature)] = mean(data_SFB$Temperature, na.rm=TRUE)

# final dataset without missing values 
##### data_SFB
head(data_SFB)
