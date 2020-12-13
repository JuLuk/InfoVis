# read a csv file 

data <- read.csv("SFBay.csv", sep=";")



colSums(is.na(data))

# columns to remove that have  more than 90% of values missing:

#  Discrete.Chlorophyll
# Chlorophyll.a.a.PHA 
# Discrete.Oxygen
# Discrete.SPM                    
# Measured.Extinction.Coefficient 
# Calculated.Extinction.Coefficient 
# Nitrite
# Nitrate...Nitrite
# Ammonium
# Phosphate
# Silicate


data$Discrete.Chlorophyll <- NULL
data$Chlorophyll.a.a.PHA <- NULL
data$Discrete.Oxygen <- NULL
data$Discrete.SPM<- NULL
data$Measured.Extinction.Coefficient <- NULL
data$Calculated.Extinction.Coefficient <- NULL
data$Nitrate...Nitrite <- NULL
data$Nitrite <- NULL
data$ Ammonium <- NULL
data$Phosphate <- NULL
data$Silicate <- NULL


SFB_data <- na.omit(data)

# split date and timem
date <- as.Date(SFB_data$TimeStamp)

# adding new columns
SFB_data["Date"] <- date
head(SFB_data)

SFB_data$TimeStamp <- NULL

SFB_DATA <- data.frame(SFB_data) 




year <- format(as.Date(SFB_DATA$Date, format="%Y/%m/%d"),"%Y")
month <- format(as.Date(SFB_DATA$Date, format="%Y/%m/%d"),"%m")
day <- format(as.Date(SFB_DATA$Date, format="%Y/%m/%d"),"%d")


SFB_DATA["Year"] <- year
SFB_DATA["Month"] <- month
SFB_DATA["Day"] <- day

SFB_DATA$Date <- NULL

head(SFB_DATA)
write.csv(SFB_DATA,'C:/Users/user/Documents/SFB_DATA.csv', row.names = FALSE)
