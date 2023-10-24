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
data_long <- read.csv("www/cleaned-incidence-Melanoma-in-Victoria-1982-2021.csv")
mortality_data_long <- read.csv("www/cleaned-mortality-Melanoma-in-Victoria-1982-2021.csv")
overall_data <- read.csv("www/overall_melanoma_rates.csv")
men_data <- read.csv("www/men_melanoma_rates.csv")
women_data <- read.csv("www/women_melanoma_rates.csv")
sunburn_data <- read.csv("www/sunburn.csv")
protection_data <- read.csv("www/protection.csv")

referenceSection <- function(type = NULL) {
  
  # First Tab references
  melanoma_references <- tags$ul(
    style = "color: gray;",
    tags$li("---. (2016). Sunscreen use and subsequent melanoma risk: A population-based cohort study. Journal of Clinical Oncology, 34(33), 3976–3983.", tags$a(href="https://doi.org/10.1200/jco.2016.67.5934", "https://doi.org/10.1200/jco.2016.67.5934.")),
    tags$li("Nijsten, Tamar. (2016). Sunscreen use in the prevention of melanoma: Common sense rules. Journal of Clinical Oncology, 34(33), 3956–3958.", tags$a(href="https://doi.org/10.1200/jco.2016.69.5874", "https://doi.org/10.1200/jco.2016.69.5874.")),
    tags$li("Australian Institute of Health and Welfare. (2023). Cancer data in Australia, data.", tags$a(href="https://www.aihw.gov.au/reports/cancer/cancer-data-in-australia/data?&page=7", "https://www.aihw.gov.au/reports/cancer/cancer-data-in-australia/data?&page=7.")),
    tags$li("Cancer Australia. (2019). What are the risk factors for melanoma?", tags$a(href="https://www.canceraustralia.gov.au/cancer-types/melanoma/awareness", "https://www.canceraustralia.gov.au/cancer-types/melanoma/awareness.")),
    tags$li("Cancer Council Victoria. (2018). Victorian cancer registry.", tags$a(href="https://www.cancervic.org.au/research/vcr", "https://www.cancervic.org.au/research/vcr.")),
    tags$li("Cancer Australia. (2019). Melanoma of the skin statistics.", tags$a(href="https://www.canceraustralia.gov.au/cancer-types/melanoma/statistics", "https://www.canceraustralia.gov.au/cancer-types/melanoma/statistics.")),
    tags$li("---. (2015). Skin cancer incidence and mortality - Skin cancer statistics and issues.", tags$a(href="https://wiki.cancer.org.au/skincancerstats/Skin_cancer_incidence_and_mortality", "https://wiki.cancer.org.au/skincancerstats/Skin_cancer_incidence_and_mortality."))
  )
  
  # Second Tab references
  global_references <- tags$ul(
    style = "color: gray;",
    tags$li("World Cancer Research Fund International. (n.d.). Skin cancer statistics.", tags$a(href="https://www.wcrf.org/cancer-trends/skin-cancer-statistics", "https://www.wcrf.org/cancer-trends/skin-cancer-statistics.")),
    tags$li("International Agency for Research on Cancer. (n.d.). Cancer today.", tags$a(href="https://gco.iarc.fr/today/online-analysis-table?v=2020&mode=cancer&mode_population=continents&population=900&populations=900&key=asr&sex=0&cancer=39&type=0&statistic=5&prevalence=0&population_group=0&ages_group%5B%5D=0&ages_group%5B%5D=17&group_cancer=1&include_nmsc=0&include_nmsc_other=1", "https://gco.iarc.fr/today/online-analysis-table..."))
  )
  
  # Third Tab references
  sunburn_references <- tags$ul(
    style = "color: gray;",
    tags$li("Cancer Australia. (2019). Sunburn and sun protection.", tags$a(href="https://ncci.canceraustralia.gov.au/prevention/sun-exposure/sunburn-and-sun-protection", "https://ncci.canceraustralia.gov.au/prevention/sun-exposure/sunburn-and-sun-protection.")),
    tags$li("Cancer Council. (2023). Preventing skin cancer.", tags$a(href="https://www.cancer.org.au/cancer-information/causes-and-prevention/sun-safety/preventing-skin-cancer", "https://www.cancer.org.au/cancer-information/causes-and-prevention/sun-safety/preventing-skin-cancer.")),
    tags$li("---. (2016). Sunscreen use and subsequent melanoma risk: A population-based cohort study. Journal of Clinical Oncology, 34(33), 3976–3983.", tags$a(href="https://doi.org/10.1200/jco.2016.67.5934", "https://doi.org/10.1200/jco.2016.67.5934.")),
    tags$li("Nijsten, Tamar. (2016). Sunscreen use in the prevention of melanoma: Common sense rules. Journal of Clinical Oncology, 34(33), 3956–3958.", tags$a(href="https://doi.org/10.1200/jco.2016.69.5874", "https://doi.org/10.1200/jco.2016.69.5874."))
  )
  
  if (type == "Melanoma in Australia") {
    return(melanoma_references)
  } else if (type == "Global melanoma") {
    return(global_references)
  } else if (type == "Sunburn") {
    return(sunburn_references)
  } else {
    return(NULL)
  }
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
               referenceSection("Melanoma in Australia"),  # References in the sidebar
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
                           selected = "Men vs Women"),
               wellPanel(
                 referenceSection("Global melanoma")  # Add reference section here
               )
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
               ),
               referenceSection("Sunburn"),  # Updated call to referenceSection
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
  


