##################################
# Melanoma Incidence in Victoria #
# by tnathu-ai #
# ui.R file                      #
##################################
library(shiny)
library(plotly)

# Colorblind-friendly colors - Okabe and Ito palette
cb_palette <- c('Males' = '#E69F00', 'Females' = '#56B4E9')
title_color <- '#CC79A7'  # Dark pink in Okabe and Ito palette

fluidPage(
  titlePanel(tags$span("Melanoma Incidence and Mortality in Victoria (1982-2021)", style = paste0("color:", title_color))),
  windowTitle = "Melanoma Incidence and Mortality",  # This sets the browser window title
  padding = 5,  
  sidebarLayout(
    sidebarPanel(
      selectInput("sexInput", "Select Gender:", 
                  choices = unique(mortality_data_long$Sex), 
                  selected = c("Males", "Females"),
                  multiple = TRUE),
      selectInput("ageGroupInput", "Select Age Group:",
                  choices = unique(mortality_data_long$AgeGroup),
                  selected = "20-24"),
      wellPanel(
        h4("Definitions:"),
        tags$ul(
          tags$li("Age-standardised rate (ASR): Provides the capacity to compare..."),
          tags$li("Crude rate (CR): The number of diagnoses..."),
          tags$li("Age-specific rate: Number of diagnoses..."),
          tags$li("Standardised incidence ratio (SIR): A Standardised Incidence Ratio...")
        )
      )
    ),
    mainPanel(
      plotlyOutput("timeSeriesPlot"),
      tags$br(),  # This line creates a break between the plots
      tags$br(),  # Optional: Add more breaks if more space is needed
      plotlyOutput("mortalityPlot"),
      tags$a("Source: Victorian Cancer Registry (2022)", href = "https://www.cancervic.org.au/research/vcr", target = "_blank", style = "color:gray;") # Making the source a clickable link
    )
  )
)
