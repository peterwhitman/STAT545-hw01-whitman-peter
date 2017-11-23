library(dplyr)
library(tidyr)
library(leaflet)
library(rgdal)
library(DT)
library(gapminder)
library(tidyverse)
library(ggplot2)
library(stringr)
library(shiny)
library(plotly)


ui <- fluidPage(
  # App title ----
  titlePanel("A Tool to Visualize Gapminder Data"),
  
  # Sidebar Layout
  sidebarLayout(
    sidebarPanel("", 
                 uiOutput("yearSelect"), #Drop down that accepts year as input
                 radioButtons("typeIn", "Map Variable", 
                              choices = c("GDP/capita"="gdpPercap", "Life Expectancy"="lifeExp", "Population"="pop"), # Radio buttons that control which variable is displayed on the map
                              selected = "gdpPercap"), "This is an application that allows users to interactively visualize the gapminder dataset. You can choose between a choropleth map, scatterplot, and table."),
    
    mainPanel(
      tabsetPanel( #Creates tabs for each output
        tabPanel("Map", leafletOutput("map", width = 900, height = 550)), 
        tabPanel("Plot", plotlyOutput("Data")), 
        tabPanel("Table", dataTableOutput("table_head")))
  )
)
)