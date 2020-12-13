# SFBay - app

year <- format(as.Date(SFB_DATA$Date, format="%Y/%m/%d"),"%Y")
month <- format(as.Date(SFB_DATA$Date, format="%Y/%m/%d"),"%m")
day <- format(as.Date(SFB_DATA$Date, format="%Y/%m/%d"),"%d")


SFB_DATA["Year"] <- year
SFB_DATA["Month"] <- month
SFB_DATA["Day"] <- day

SFB_DATA$Date <- NULL

head(SFB_DATA)

library(DT)
library(shiny)
library(shinydashboard)
library(leaflet)
library(sp)

ui <- dashboardPage(
    dashboardHeader(title = 'San Francisco Bay App' ),
    dashboardSidebar(
        width = 300,
        sidebarMenu(
            menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
            menuItem("Widgets", tabName = "widgets", icon = icon("th")),
            menuItem("Charts", tabName = "charts", icon = icon("ch"))
        )
    ),
    dashboardBody(
        tabItems(
        tabItem(tabName = "dashboard",
                fluidRow(
                    box(leafletOutput("mymap1",width = "100%",height = "500")),
                    box(
                        title = "Please select Year",
                        sliderInput("sliderY", "Year:", 1994, 2014, 1999, round = TRUE, sep = "")),
                    box(
                        title = "Station Information",
                        DTOutput("stationTable1"))
                    )
                ),
        tabItem(tabName = "widgets",
                h2("Widgets tab content to be pasted")),
        tabItem(tabName = "charts",
                h2("Select chart type"),
                fluidRow(
                    box(
                        title = "Please select Year",
                        sliderInput("slider", "Year:", 1994, 2014, 1999, round = TRUE, sep = "")),
                    box(
                        title = "Please select Month",
                        sliderInput("slider", "Month:", 1, 12, 6, round = TRUE, sep = "")),
                    box(title = "Water temperature",
                        plotOutput("hist", click = "plot_click"), 
                        verbatimTextOutput("infoHist")
                    ),
                    box(title = "Salinity", 
                        plotOutput("scatter", click = "plot_click"),
                        verbatimTextOutput("infoScatter")
                    )
                )
                )
        )
    )
)
    
    #plotOutput("corr"),
    #plotOutput("hist"))

server <- function(input, output) {
  
    stationInfoRel <- stationInfo
    stationInfoRel$Latitude.Dec <- NULL
    stationInfoRel$Longitude.Dec <- NULL
    
    
    output$stationTable1 <- renderDT(stationInfoRel)
    
    
    output$infoScatter <- renderText({
      paste0("Temperature =",input$plot_click$x, "\nSalinity =", input$plot_click$y)
    })
    
    output$scatter <- renderPlot({
      title <- "scatter"
      plot(SFB_DATA$Temperature, SFB_DATA$Salinity)
      })
    
    output$infoHist <- renderText({
      paste0("Temperature = ", input$plot_click$x, "\nFrequency = ", input$plot_click$y)
      })
    
    output$hist <- renderPlot({
      title <- "histogram"
      hist(SFB_DATA$Temperature)
    })

    output$mymap1 <- renderLeaflet({
        stationInfo <- read.csv("stationInfo.csv")
        
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
                             popup = ~paste("Station ID:", Station.Number, "<br>", #inside paste you can use HTML
                                            "Location/Name:", General.Location, "<br>",
                                            "Water Depth (m):", Depth.MLW..meters., "<br>",
                                            "Standard Station:", Standard.Station
                             )
            )
    })
}


shinyApp(ui = ui, server = server)