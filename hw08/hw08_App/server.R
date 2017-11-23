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
        mutate(lifeExp = as.integer(lifeExp)) %>%
        mutate(gdpPercap = as.integer(gdpPercap)) 
      
      #Input selected yearIn value as intial input to avoid crashing
      if(!is.null(input$yearIn)){
      filter_gap <- filter_gap %>%
        filter(year == input$yearIn) # 
      }
      #Join filtered gapminder.csv to the countries.shp file
      filtered_countries <- suppressWarnings(left_join(countries@data, filter_gap, by=c("NAME"="country")))
      return(filtered_countries)
    })
  
  #Output basemap
  output$map <- renderLeaflet(
    {
      leaflet() %>% addProviderTiles("Esri.WorldShadedRelief",
               options = tileOptions(minZoom=1, maxZoom=15)) %>%
        setView(lng = 0, lat = 15, zoom = 2)
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
                            "<br>GDP/capita: $", 
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
  
  observeEvent(input$yearIn, 
               {
                 
                 dataSet_year <- filtered_gapminder()
                 
                 if(input$typeIn == "gdpPercap")
                 {
                   #pallete with bins
                   pal_GDP <- colorBin("Greens", domain = dataSet_year$gdpPercap, bins = c(0, 1000, 10000, 25000, 50000, 75000, 100000, 125000))
                   
                   #pop up that provides country name and variable
                   popup_GDP <- paste0("Country: ",             
                                       dataSet_year$NAME,         
                                       "<br>GDP/capita: $", 
                                       dataSet_year$gdpPercap) 
                   
                   #clears previous map and redraws with gdp values for each country
                   leafletProxy("map", data = dataSet_year) %>%
                     clearShapes() %>%
                     addPolygons(data = countries,
                                 fillColor = ~pal_GDP(dataSet_year$gdpPercap),
                                 fillOpacity = 0.8,
                                 color = "darkgrey",
                                 weight = 1.5,
                                 popup = popup_GDP)
                 }
                 
                 #same as abouve but for lifeExp
                 else if(input$typeIn == "lifeExp")
                 {
                   pal_lifeExp <- colorBin("Purples", domain = dataSet_year$lifeExp, bins = c(25, 35, 45, 55, 65, 75, 85))
                   
                   popup_lifeExp <- paste0("Country: ",             
                                           dataSet_year$NAME,
                                           "<br>Life Expectancy: ", 
                                           dataSet_year$lifeExp) 
                   
                   leafletProxy("map", data = dataSet_year) %>%
                     clearShapes() %>%
                     addPolygons(data = countries,
                                 fillColor = ~pal_lifeExp(dataSet_year$lifeExp),
                                 fillOpacity = .8,
                                 color = "darkgrey",
                                 weight = 1.5,
                                 popup = popup_lifeExp)
                 }
                 
                 #same as above but for pop
                 else if(input$typeIn == "pop")
                 {
                   pal_pop <- colorBin("Oranges", domain = dataSet_year$pop, bins = c(0, 500000, 1000000, 5000000, 10000000, 50000000, 100000000, 500000000, 1000000000, 1500000000))
                   
                   popup_pop <- paste0("Country: ",             
                                       dataSet_year$NAME,         
                                       "<br>Population: ", 
                                       dataSet_year$pop) 
                   
                   leafletProxy("map", data = dataSet_year) %>%
                     clearShapes() %>%
                     addPolygons(data = countries,
                                 fillColor = ~pal_pop(dataSet_year$pop),
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
        select(country, continent, gdpPercap, lifeExp, pop) %>%
        setnames(old=c("country","continent", "gdpPercap", "lifeExp", "pop"), 
                 new=c("Country", "Continent", "GDP/capita", "Life Expectancy", "Population"))
    })
  
  #reactive function for the plot that filters the data based on year and selects the relevent variables
  Filtered_forPlot <- reactive(
    {
      for_plot <- gapminder_data %>%
        filter(year == input$yearIn) %>%
        select(country, continent, lifeExp, gdpPercap, pop)
    })
  
  #a plot that uses a reactive function to update when there are changes in inputed year
  output$Data <- renderPlotly(
    {
        plot_data <- Filtered_forPlot()
        
        p<- plot_data %>%
          ggplot(aes(gdpPercap, lifeExp, size = pop, color = continent, text = paste('</br> Country: ', country,
                                                                                                   '</br> Continent: ', continent,
                                                                                                   '</br> GDP/capita: ', gdpPercap,
                                                                                                   '</br> Life Expectancy: ', lifeExp,
                                                                                                   '</br> Population: ', pop))) +
          geom_point(alpha = 0.9, shape = 21) +
          labs(x= "GDP/capita (USD)", y = "Life Expectancy (years)") +
          ggtitle(paste("GDP/capita vs Life Expectancy in ", input$yearIn)) +
          scale_size(range = c(2, 10)) +
          theme(legend.title = element_blank())
        ggplotly(p, tooltip = c("text")) %>% 
          add_annotations(text="Continents", xref="paper", yref="paper",
                                         x=1.02, xanchor="left",
                                         y=0.8, yanchor="bottom",    
                                         legendtitle=TRUE, showarrow=FALSE ) %>%
          layout( legend=list(y=0.8, yanchor="top" )) %>% 
          config(displayModeBar = F)
    })
  
  
  #a table that uses a reactive function to update when there are changes in inputed year
  output$table_head <- DT::renderDataTable(
  {
    Filtered_forTable()
  }, 
    options = list(lengthMenu = c(5, 10, 20), pageLength = 5) # controls the number of rows
  )
}