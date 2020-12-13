install.packages("leaflet")
install.packages("ggmap")
library(leaflet)
library(sp)
library(ggmap)

stationInfo <- read.csv("station info.csv")

# making sure the Longitude.Dec column is number column (not text, char)
stationInfo$Longitude.Dec <- as.numeric(stationInfo$Longitude.Dec)
stationInfo$Latitude.Dec <- as.numeric(stationInfo$Latitude.Dec)

# create new spatial points data frame (where to find geocoordinates Lat, Long)
stationInfo.SP <- SpatialPointsDataFrame(stationInfo[,c(3,4)], stationInfo[,-c(3,4)])

# center the map on 37.898193, -122.070647

myMap <- leaflet() %>% 
  addProviderTiles("Esri.WorldGrayCanvas") %>% 
  addCircleMarkers(data = stationInfo, 
             lng = ~Longitude.Dec, 
             lat = ~Latitude.Dec, 
             radius = 4,
             popup = ~paste("<b>Station ID: </b>", Station.Number, "<br>",  #inside paste you can use HTML
                            "<b>Location: </b>", General.Location, 
                            sep = " ",)
             )

myMap
