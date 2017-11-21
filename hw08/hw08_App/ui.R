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


ui <- fluidPage(
  # App title ----
  titlePanel("A Tool to Visualize Gapminder Data"),
  
  # Sidebar Layout
  sidebarLayout(
    sidebarPanel("", 
                 uiOutput("yearSelect"), #Drop down that accepts year as input
                 radioButtons("typeIn", "Map Variable", 
                              choices = c("GDP/capita"="gdpPercap", "Life Expectancy"="lifeExp", "Population"="pop"), # Radio buttons that control which variable is displayed on the map
                              selected = "gdpPercap"), "*Currently, only the table and plot respond to changes in year", br(), br(), "**Click on the country to get specific data for that country"),
    
    mainPanel(
      tabsetPanel( #Creates tabs for each output
        tabPanel("Map", leafletOutput("map")), 
        tabPanel("Plot", plotOutput("Data")), 
        tabPanel("Table", dataTableOutput("table_head")))
  )
)
)