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

navbarPage(
  title = tags$span(
    tags$img(src = "logo.ico", height = "50px", width = "50px", style = "vertical-align: middle; margin-right: 10px;"),  # Display logo next to the title
    "Melanoma Incidence and Mortality in Victoria (1982-2021)"
  ),
  windowTitle = "Melanoma Incidence and Mortality",  # This sets the browser window title
  header = tags$head(tags$link(rel = "shortcut icon", type = "image/x-icon", href = "logo.ico")),  # Add favicon to the webpage
  tabPanel("Melanoma & Mortality", 
           titlePanel(tags$span("Melanoma Incidence and Mortality in Victoria (1982-2021)", style = paste0("color:", title_color))),
           windowTitle = "Melanoma & Mortality in VIC",  # This sets the browser window title
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
           )),
  tabPanel("Melanoma Rates Globally", 
           fluidRow(
             plotlyOutput("overallPlot"),
             plotlyOutput("menPlot"),
             plotlyOutput("womenPlot")
           )),
  tabPanel("Tab 3", 
           fluidRow("Content for Tab 3 goes here"))
)
