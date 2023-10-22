##################################
# Melanoma Incidence in Victoria #
# by [Your Name or Organization] #
# ui.R file                      #
##################################

library(leaflet)
library(shinydashboard)
library(collapsibleTree)
library(shinycssloaders)
library(DT)
library(tigris)
library(ggplot2)

###########
# LOAD UI #
###########

shinyUI(fluidPage(
  
  # load custom stylesheet if any
  # includeCSS("www/style.css"),
  
  # remove shiny "red" warning messages on GUI
  tags$style(type="text/css",
             ".shiny-output-error { visibility: hidden; }",
             ".shiny-output-error:before { visibility: hidden; }"
  ),
  
  # load page layout
  dashboardPage(
    
    skin = "green",
    
    dashboardHeader(title="Melanoma Incidence in Victoria", titleWidth = 300),
    
    dashboardSidebar(width = 300,
                     sidebarMenu(
                       menuItem("Home", tabName = "home", icon = icon("home")),
                       menuItem("Yearly Cases", tabName = "incidence", icon = icon("line-chart")),
                       menuItem("Disparities Analysis", tabName = "disparities", icon = icon("bar-chart")),
                       menuItem("Mortality Analysis", tabName = "mortality", icon = icon("heart-o")),
                       menuItem("Survival Rates", tabName = "survival", icon = icon("medkit"))
                       # You can continue adding more menu items as needed
                     )
                     
    ), # end dashboardSidebar
    
    dashboardBody(
      
      tabItems(
        
        tabItem(tabName = "home",
                # Home section content goes here
        ),
        
        tabItem(tabName = "incidence",
                fluidPage(
                  titlePanel("Melanoma Incidence in Victoria (1982-2021)"),
                  sidebarLayout(
                    sidebarPanel(
                      # Add controls for filtering or selecting data
                    ),
                    mainPanel(
                      plotOutput("timeSeriesPlot")
                    )
                  )
                )
        ),
        
        tabItem(tabName = "disparities",
                fluidPage(
                  selectInput("characteristic", "Select Characteristic", 
                              unique(df_disparities$Characteristic)),
                  plotOutput("barPlot")
                )
        ),
        
        tabItem(tabName = "mortality",
                fluidPage(
                  titlePanel("Melanoma Mortality in Victoria 1982-2021"),
                  sidebarLayout(
                    sidebarPanel(
                      selectInput("sexInput", "Select Gender:", 
                                  choices = unique(mortality_data_long$Sex), 
                                  selected = "Males"),
                      sliderInput("yearInput", "Select Year:", 
                                  min = min(mortality_data_long$Year), 
                                  max = max(mortality_data_long$Year), 
                                  value = min(mortality_data_long$Year),
                                  step = 1)
                    ),
                    mainPanel(
                      plotOutput("mortalityPlot")
                    )
                  )
                )
        ),
        
        # You can continue adding more tab items for other sections like "Survival Rates"
        
      ) # end tabItems
      
    ) # end dashboardBody
    
  ) # end dashboardPage
  
)) # end shinyUI
