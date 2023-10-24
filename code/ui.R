##################################
# Melanoma Incidence in Victoria #
# by tnathu-ai #
# ui.R file                      #
##################################

library(shiny)
library(plotly)

# Colorblind-friendly colors - Okabe and Ito palette
cb_palette <- c('Males' = '#56B4E9', 'Females' = '#CC79A7')
# Load data
data_long <- read.csv("../data/clean/cleaned-incidence-Melanoma-in-Victoria-1982-2021.csv")
mortality_data_long <- read.csv("../data/clean/cleaned-mortality-Melanoma-in-Victoria-1982-2021.csv")
overall_data <- read.csv("../data/clean/overall_melanoma_rates.csv")
men_data <- read.csv("../data/clean/men_melanoma_rates.csv")
women_data <- read.csv("../data/clean/women_melanoma_rates.csv")
sunburn_data <- read.csv("../data/clean/sunburn.csv")
protection_data <- read.csv("../data/clean/protection.csv")
referenceSection <- function() {
  tags$div(
    tags$p("References:", style = "font-weight: bold;"),
    tags$ul(
      style = "color: gray;",  # Adjusting style to the entire list for consistency
      tags$li("Cancer Council. “Preventing Skin Cancer.” Www.cancer.org.au, 2023, ", 
              tags$a(href="https://www.cancer.org.au/cancer-information/causes-and-prevention/sun-safety/preventing-skin-cancer", "www.cancer.org.au/cancer-information/causes-and-prevention/sun-safety/preventing-skin-cancer."), 
              "."),
      tags$li("Australian Institute of Health and Welfare (AIHW). Australian Cancer Incidence and Mortality (ACIM) books. Canberra: AIHW."),
      tags$li("Australia, Cancer. “What Are the Risk Factors for Melanoma?” Www.canceraustralia.gov.au, 18 Dec. 2019, ", 
              tags$a(href="https://www.canceraustralia.gov.au/cancer-types/melanoma/awareness", "www.canceraustralia.gov.au/cancer-types/melanoma/awareness."), 
              ".")
    )
  )
}


navbarPage(
  
  title = tags$span(
    tags$img(src = "logo.ico", height = "50px", width = "50px", style = "vertical-align: middle; margin-right: 10px;"),  # Display logo next to the title
    "Melanoma - Skin cancer in Australia & World"
  ),
  windowTitle = "Melanoma Incidence and Mortality",  # This sets the browser window title
  header = tags$head(
    # Link to the FontAwesome library
    tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css"),
    
    # Add script for toggling the icon for collapsible panel
    tags$script(HTML("
    $(document).on('click', '#collapsiblePanel', function() {
      var icon = $(this).find('.fa-chevron-down, .fa-chevron-up');
      if (icon.hasClass('fa-chevron-down')) {
        icon.removeClass('fa-chevron-down').addClass('fa-chevron-up');
      } else {
        icon.removeClass('fa-chevron-up').addClass('fa-chevron-down');
      }
    });
  ")),
    
    # Add favicon to the webpage
    tags$link(rel = "shortcut icon", type = "image/x-icon", href = "logo.ico")
  ),
  
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
               ),
               referenceSection(),  # Add this where you want references in the sidebar
               
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
  
  # Sunburn & Sun Protection in Australia tab
  tabPanel("Sunburn & Sun Protection in Australia",
           sidebarLayout(
             sidebarPanel(
               wellPanel(
                 h4("Definitions:"),
                 tags$ul(
                   tags$li("Sunburn: Any amount of reddening of the skin after being in the sun."),
                   tags$li("Sun Protection: Use of a combination of two or more sun protection behaviours.")
                 ),
                 radioButtons("displayMode", "Display Mode:", 
                              choices = c("Sunburn", "Sun Protection"), 
                              selected = "Sunburn", inline = TRUE)
               )
             ),
             mainPanel(
               uiOutput("sunburnProtectionTitle"),
               plotlyOutput("sunburnProtectionPlot", height = "400px"),
               tags$br(),
               
               # Adding collapsible panel with sunburn protection advice
               tags$details(
                 id = "collapsiblePanel",  # Add an ID for easy reference
                 style = "border: 1px solid #ccc; padding: 10px; border-radius: 5px;",  # Style the panel
                 
                 tags$summary(
                   HTML("<i class='fa fa-chevron-down' style='margin-right: 5px;'></i> How can I protect my skin from the sun?"),  # Add the icon before the text
                   style = "cursor: pointer;"  # Change the cursor to a hand when hovering over the summary
                 ),
                 
                 tags$p("For best protection, Cancer Council Australia recommends:"),
                 tags$ul(
                   tags$li("Slip on sun-protective clothing that covers as much skin as possible."),
                   tags$li("Slop on broad spectrum, water resistant SPF30 (or higher) sunscreen. Apply 20 minutes before going outdoors and reapply every two hours. Never use sunscreen to extend sun exposure."),
                   tags$li("Slap on a broad brim or legionnaire style hat to shield your face, head, neck, and ears."),
                   tags$li("Seek shade."),
                   tags$li("Slide on sunglasses ensuring they adhere to Australian Standards.")
                 ),
                 tags$p("Note: UV radiation is harmful because it isn’t always detectable by sunlight or heat. This radiation can harm our skin unnoticed."),
                 tags$p("Cancer Council Victoria has a SunSmart Global UV app which offers real-time and forecasted UV levels for locations worldwide. The app provides evidence-based sun protection advice.")
               ),
               tags$br(),
               tags$a("Source: Provided data on Sunburn and Sun Protection", href = "#", style = "color:gray;"),
               tags$a("Advice Source: Cancer Council Australia", href = "https://www.cancer.org.au/cancer-information/causes-and-prevention/sun-safety/preventing-skin-cancer", style = "color:gray;")  # Adding source for the advice
               
             )
           )
  ),
  
  # Adding global footer to navbarPage
  footer = tags$footer(
    style = "text-align: center; padding: 20px 0; border-top: 1px solid #ccc; margin-top: 20px;",  # Aligns content to the center and adds padding & margin
    
    tags$p("Acknowledgments", style = "font-weight: bold;"),
    
    tags$p("Baglin, J. (2023). Data Visualisation: From Theory to Practice. In Data Visualisation and Communication (2350) [Online Textbook]. RMIT University. ", 
           tags$a(href="https://darkstar161610.appspot.com/secured/_book/index.html", "Retrieved from https://darkstar161610.appspot.com/secured/_book/index.html"), 
           "."),
    
    tags$a("tnathu-ai @ 2023", href = "https://github.com/tnathu-ai", target = "_blank", style = "color:gray; display:block; padding-top:10px;")
  )
  
  
)
  


