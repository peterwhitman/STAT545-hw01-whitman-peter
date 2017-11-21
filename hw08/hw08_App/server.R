library(dplyr)
library(tidyr)
library(leaflet)
library(rgdal)
library(DT)
library(gapminder)
library(tidyverse)
library(ggplot2)
library(stringr)
library(maptools)
library(data.table)
library(broom)
library(shiny)
library(plotly)

# Define server logic required to draw a histogram ----
server <- function(input, output) 
{
  #Read gapminder.csv
  gapminder_data <- read.csv("data/gapminder.csv") 
  
  #Read .shp file
  countries.shp <- readOGR(dsn=("data"), layer = "TM_WORLD_BORDERS_SIMPL-0.3") 
  #Subset .shp file
  countries <- subset(countries.shp, select= c("NAME","LON","LAT")) 
  
  #Creates a drop-down for year which is rendered in ui.R
  output$yearSelect<-renderUI({ 
    yearRange <-sort(unique(as.numeric(gapminder_data$year)), decreasing=TRUE) 
    selectInput("yearIn", "Year", choices=yearRange, selected=yearRange[1]) 
  })
  
  filtered_gapminder <- reactive(
    {
      #Round gdpPercap and lifeExp and convert both variables to integer
      filter_gap <- gapminder_data %>% 
        mutate(lifeExp = as.integer(round(lifeExp, 0))) %>%
        mutate(gdpPercap = as.integer(round(gdpPercap, 0))) 
      
      #input selected yearIn value as intial input to avoid crashing
      if(!is.null(input$yearIn)){
      filter_gap <- filter_gap %>%
        filter(year == input$yearIn) # 
      }
      #join filtered gapminder.csv to the countries.shp file
      filtered_countries <- suppressWarnings(left_join(countries@data, filter_gap, by=c("NAME"="country")))
      return(filtered_countries)
    })
  
  #output basemap
  output$map <- renderLeaflet(
    {
      leaflet() %>% addProviderTiles("Esri.WorldShadedRelief",
               options = tileOptions(minZoom=1, maxZoom=15)) %>%
        setView(lng = 0, lat = 0, zoom = 1)
    })
  
  #observe changes in the radio buttions, redraw map accordingly
  observeEvent(input$typeIn, 
    {
      
      dataSet <- filtered_gapminder()
      
      if(input$typeIn == "gdpPercap")
      {
        #pallete with bins
        pal_GDP <- colorBin("Greens", domain = dataSet$gdpPercap, bins = c(0, 1000, 10000, 25000, 50000, 75000, 100000, 125000))
        
        #pop up that provides country name and variable
        popup_GDP <- paste0("Country: ",             
                            dataSet$NAME,         
                            "<br>GDP/capita: ", 
                            dataSet$gdpPercap) 
        
        #clears previous map and redraws with gdp values for each country
        leafletProxy("map", data = dataSet) %>%
          clearShapes() %>%
          addPolygons(data = countries,
                      fillColor = ~pal_GDP(dataSet$gdpPercap),
                      fillOpacity = 0.8,
                      color = "darkgrey",
                      weight = 1.5,
                      popup = popup_GDP)
      }
      
      #same as abouve but for lifeExp
      else if(input$typeIn == "lifeExp")
      {
        pal_lifeExp <- colorBin("Purples", domain = dataSet$lifeExp, bins = c(25, 35, 45, 55, 65, 75, 85))
        
        popup_lifeExp <- paste0("Country: ",             
                                dataSet$NAME,
                                "<br>Life Expectancy: ", 
                                dataSet$lifeExp) 
        
        leafletProxy("map", data = dataSet) %>%
          clearShapes() %>%
          addPolygons(data = countries,
                      fillColor = ~pal_lifeExp(dataSet$lifeExp),
                      fillOpacity = .8,
                      color = "darkgrey",
                      weight = 1.5,
                      popup = popup_lifeExp)
      }
      
      #same as above but for pop
      else if(input$typeIn == "pop")
      {
        pal_pop <- colorBin("Oranges", domain = dataSet$pop, bins = c(0, 500000, 1000000, 5000000, 10000000, 50000000, 100000000, 500000000, 1000000000, 1500000000))
        
        popup_pop <- paste0("Country: ",             
                            dataSet$NAME,         
                            "<br>Population: ", 
                            dataSet$pop) 
        
        leafletProxy("map", data = dataSet) %>%
          clearShapes() %>%
          addPolygons(data = countries,
                      fillColor = ~pal_pop(dataSet$pop),
                      fillOpacity = 0.8,
                      color = "darkgrey",
                      weight = 1.5,
                      popup = popup_pop)
      }
    })
  
  #observe changes in radio buttons, output the correct legend
  observeEvent(input$typeIn, 
    {
      dataSet_legend <- filtered_gapminder()
      
      if(input$typeIn == "pop")
      {
        legend_pop <- colorBin("Oranges", domain = dataSet_legend$pop, bins = c(0, 500000, 1000000, 5000000, 10000000, 50000000, 100000000, 500000000, 1000000000, 1500000000))
        
        leafletProxy("map", data = dataSet_legend) %>%
          clearControls() %>%
          addLegend(position = "bottomright", pal = legend_pop, values = dataSet_legend$pop, opacity = 0.6, title = "Legend")
      }
      
      else if(input$typeIn == "gdpPercap")
      {
        legend_GDP <- colorBin("Greens", domain = dataSet_legend$gdpPercap, bins = c(0, 1000, 10000, 25000, 50000, 75000, 100000, 125000))
        
        leafletProxy("map", data = dataSet_legend) %>%
          clearControls() %>%
          addLegend(position = "bottomright", pal = legend_GDP, values = dataSet_legend$gdpPercap, opacity = 0.6, title = "Legend")
      }
      
      else if(input$typeIn == "lifeExp")
      {
        legend_lifeExp <- colorBin("Purples", domain = dataSet_legend$lifeExp, bins = c(25, 35, 45, 55, 65, 75, 85))
        
        leafletProxy("map", data = dataSet_legend) %>%
          clearControls() %>%
          addLegend(position = "bottomright", pal = legend_lifeExp, values = dataSet_legend$lifeExp, opacity = 0.6, title = "Legend")
      }
    })
  
  #a reactive function for the table that filters the gapminder data based on input year, selects variables to the project, and outputs aesthetically pleasing column names
  Filtered_forTable <- reactive(
    {
      gapminder_data %>%
        filter(year == input$yearIn) %>%
        select(country, continent, lifeExp, gdpPercap, pop) %>%
        setnames(old=c("country","continent", "lifeExp", "gdpPercap", "pop"), 
                 new=c("Country", "Continent", "Life Expectancy", "GDP/capita", "Population"))
    })
  
  #reactive function for the plot that filters the data based on year and selects the relevent variables
  Filtered_forPlot <- reactive(
    {
      for_plot <- gapminder_data %>%
        filter(year == input$yearIn) %>%
        select(country, continent, lifeExp, gdpPercap, pop)
    })
  
  #a plot that uses a reactive function to update when there are changes in inputed year
  output$Data <- renderPlot(
    {
        plot_data <- Filtered_forPlot()
        
        plot_data %>%
        ggplot(aes(gdpPercap, lifeExp, size = pop, color = continent)) +
          geom_point() +
          labs(x= "GDP/capita (USD)", y = "Life Expectancy (years)") +
          ggtitle(paste("GDP/capita vs Life Expectancy in ", input$yearIn)) +
          scale_size(range = c(2, 10)) +
          scale_colour_discrete("Population") +
          scale_colour_discrete("Continents")
    })
  
  #a table that uses a reactive function to update when there are changes in inputed year
  output$table_head <- DT::renderDataTable(
  {
    Filtered_forTable()
  }, 
    options = list(lengthMenu = c(5, 10, 20), pageLength = 5) # controls the number of rows
  )
}