##################################
# Melanoma Incidence in Victoria #
# by tnathu-ai #
# ui.R file                      #
##################################

library(shiny)
library(plotly)

# Colorblind-friendly colors - Okabe and Ito palette
cb_palette <- c('Males' = '#56B4E9', 'Females' = '#CC79A7')

navbarPage(
  title = tags$span(
    tags$img(src = "logo.ico", height = "50px", width = "50px", style = "vertical-align: middle; margin-right: 10px;"),  # Display logo next to the title
    "Melanoma Data Explorer"
  ),
  windowTitle = "Melanoma Incidence and Mortality",  # This sets the browser window title
  header = tags$head(tags$link(rel = "shortcut icon", type = "image/x-icon", href = "logo.ico")),  # Add favicon to the webpage
  
  tabPanel("Melanoma & Mortality in VIC", 
           sidebarLayout(
             sidebarPanel(
               wellPanel(
                 h4("Definitions:"),
                 tags$ul(
                   tags$li("Age-standardised rate (ASR): Provides the capacity to compare..."),
                   tags$li("Crude rate (CR): The number of diagnoses..."),
                   tags$li("Age-specific rate: Number of diagnoses..."),
                   tags$li("Standardised incidence ratio (SIR): A Standardised Incidence Ratio...")
                 ),
                 selectInput("sexInput", "Select Gender:", 
                             choices = sort(unique(mortality_data_long$Sex)),  # Sort gender categories
                             selected = c("Males", "Females"),
                             multiple = TRUE),
                 selectInput("ageGroupInput", "Select Age Group:",
                             choices = sort(unique(mortality_data_long$AgeGroup)),  # Sort age categories
                             selected = "20-24")
               )
             ),
             mainPanel(
               uiOutput("dynamicTitleVIC"),
               plotlyOutput("timeSeriesPlot", height = "400px"),  # Adjust height if necessary
               tags$br(),  
               tags$br(),  
               plotlyOutput("mortalityPlot", height = "400px"),  # Adjust height if necessary
               tags$a("Source: Victorian Cancer Registry (2022)", href = "https://www.cancervic.org.au/research/vcr", target = "_blank", style = "color:gray;") # Making the source a clickable link
             )
           )),
  
  tabPanel("Melanoma Rates Globally",
           sidebarLayout(
             sidebarPanel(
               h4("Definitions:"),
               tags$ul(
                 tags$li("Age-standardised rate (ASR): Provides the capacity to compare..."),
                 tags$li("Crude rate (CR): The number of diagnoses..."),
                 tags$li("Age-specific rate: Number of diagnoses..."),
                 tags$li("Standardised incidence ratio (SIR): A Standardised Incidence Ratio...")
               ),
               selectInput("comparePlotInput", "Select Plots to Compare:",
                           choices = c("Men vs Women", "Men vs Overall", "Women vs Overall"),
                           selected = "Men vs Women")
             ),
             mainPanel(
               uiOutput("dynamicTitleGlobal"),
               conditionalPanel(condition = "input.comparePlotInput == 'Men vs Women' || input.comparePlotInput == 'Men vs Overall'",
                                plotlyOutput("menPlot", height = "400px")),
               tags$br(),
               conditionalPanel(condition = "input.comparePlotInput == 'Men vs Women' || input.comparePlotInput == 'Women vs Overall'",
                                plotlyOutput("womenPlot", height = "400px")),
               tags$br(),
               conditionalPanel(condition = "input.comparePlotInput == 'Men vs Overall' || input.comparePlotInput == 'Women vs Overall'",
                                plotlyOutput("overallPlot", height = "400px")),
               tags$br(),
               tags$a("Source: The data on this page comes from the Global Cancer Observatory, owned by the World Health Organization/International Agency for Research on Cancer, and is used with permission. The cancer incidence figures and ASRs were compiled using the data available", href = "https://www.wcrf.org/cancer-trends/skin-cancer-statistics/#:~:text=Melanoma%20skin%20cancer%20rates&text=Australia%20had%20the%20highest%20overall,2020%2C%20followed%20by%20New%20Zealand.", target = "_blank", style = "color:gray;")
             )
           )),
  
  tabPanel("Tab 3", 
           fluidRow("Content for Tab 3 goes here"))
)


