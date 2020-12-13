SFB_DATA <- read.csv("SFB_DATA.csv")

head(SFB_DATA)

library(DT)
library(shiny)
library(shinydashboard)
library(leaflet)
library(sp)
library(dplyr)



ui <- dashboardPage(
    dashboardHeader(title = 'San Francisco Bay Water Quality Survey Dashboard',
                    titleWidth = 500),
    dashboardSidebar(
        width = 300,
        sidebarMenu(
            menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
            menuItem("Charts", tabName = "charts", icon = icon("th")),
            menuItem("Create Alert", tabName = "alert", icon = icon("cog", lib = "glyphicon"))
        )
    ),
    dashboardBody(
        tabItems(
        tabItem(tabName = "dashboard",
                fluidRow(
                    box(leafletOutput("mymap1",width = "100%",height = "500")),
                    box(plotOutput("plot")),
                    box(
                        title = "Please select Water Depth (m):",
                        sliderInput("sliderW", "Year:", 0, 15, 8.5)),
                    box(
                        title = "Station Information",
                        DTOutput("stationTable1"))
                    )
                ),
        tabItem(tabName = "charts",
                h2("Select chart type"),
                fluidRow(
                    box(
                        title = "Please select Year",
                        sliderInput("slider", "Year:", 1994, 2014, 1999, round = TRUE, sep = "")),
                    box(
                        title = "Please select Month",
                        sliderInput("slider", "Month:", 1, 12, 6, round = TRUE, sep = "")),
                    box(
                      title = "Water temperature (Celsius)",
                        plotOutput("hist", click = "plot_click"), 
                        verbatimTextOutput("infoHist")
                    ),
                    box(title = "Salinity", 
                        plotOutput("scatter", click = "plot_click"),
                        verbatimTextOutput("infoScatter")
                    )
                )
                ),
        tabItem(tabName = "alert",
                h3("Create your customized alert")
                )
        )
    )
)
    

server <- function(input, output) {
  
    stationInfoRel <- stationInfo
    stationInfoRel$Latitude.Dec <- NULL
    stationInfoRel$Longitude.Dec <- NULL
    
    id = stationInfo$General.Location
    
    data_of_click <- reactiveValues(clickedMarker=NULL)
    
    output$stationTable1 <- renderDT(stationInfoRel)

    output$infoScatter <- renderText({
      paste0("Temperature =",input$plot_click$x, "\nSalinity =", input$plot_click$y)
    })
    
    SFB_DATA2014 <- filter(SFB_DATA, Year == 2014)
    
    output$scatter <- renderPlot({
      title <- "scatter"
      plot(SFB_DATA2014$Temperature, SFB_DATA2014$Salinity,
           pch = 16, col = "blue",
        xlab = "Temperature in Celsius", 
        ylab = "Salinity")

      })
    
      'output$infoHist <- renderText({
      paste0("Temperature = ", input$plot_click$x, "\nFrequency = ", input$plot_click$y)
      })'
    
    output$hist <- renderPlot({
      title <- "histogram"
      hist(SFB_DATA$Temperature,
      main= paste(""),
      xlab = "Temperature in Celsius", 
      ylab = "Cumulated Frequency")
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
    
    observeEvent(input$map_marker_click,{
      data_of_click$clickedMarker <- input$map_marker_click
    })
    
    output$plot <- renderPlot({
      my_place=data_of_click$clickedMarker$id[]
      if(is.null(my_place)){my_place="Rio Vista"}
      if(my_place=="Rio Vista"){
        #plot(rnorm(1000), col=rgb(0.9,0.4,0.1,0.3), cex=3, pch=20)
        plot(SFB_DATA2013$Depth, SFB_DATA2013$Temperature, 
             main = paste("Water temperature with varying Depth"),
             pch = 16, col = "orange",
             xlab = "Depth in metres", 
             ylab = "Temperature in Celsius")
        }else{
          barplot(rnorm(10), col=rgb(0.1,0.4,0.9,0.3))
        }
    })

}

shinyApp(ui = ui, server = server)