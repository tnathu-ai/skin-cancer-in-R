##################################
# Melanoma Studies Analysis      #
# by tnathu-ai          #
# server.R file                  #
##################################



library(shiny)
library(plotly)
library(dplyr)

# Load data
data_long <- read.csv("../data/clean/cleaned-incidence-Melanoma-in-Victoria-1982-2021.csv")
mortality_data_long <- read.csv("../data/clean/cleaned-mortality-Melanoma-in-Victoria-1982-2021.csv")
overall_data <- read.csv("../data/clean/overall_melanoma_rates.csv")
men_data <- read.csv("../data/clean/men_melanoma_rates.csv")
women_data <- read.csv("../data/clean/women_melanoma_rates.csv")

# Colorblind-friendly colors - Okabe and Ito palette
cb_palette <- c('Males' = '#56B4E9', 'Females' = '#CC79A7')

function(input, output, session) {
  
  # Show introduction modal when the app starts
  showModal(modalDialog(
    title = "Welcome to the App!",
    "Do you know about melanoma - the most dangerous form of skin cancer, caused by overexposure to ultraviolet (UV) radiation from the sun?",
    selectInput("startup_ageGroupInput", "Please enter your age group:", 
                choices = c("0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69", "70-74", "75-79", "80-84", "85+")),
    footer = tagList(
      modalButton("Cancel"),
      actionButton("submitBtn", "Submit")
    ),
    easyClose = FALSE
  ))
  
  # Update default age group based on modal input and close modal on submit
  observeEvent(input$submitBtn, {
    updateSelectInput(session, "ageGroupInput", selected = input$startup_ageGroupInput)
    removeModal()
  })
  
  # Filter data for Incidence Plot
  filtered_data_incidence <- reactive({
    data_long[data_long$Sex %in% input$sexInput & data_long$AgeGroup == input$ageGroupInput,]
  })
  
  # Filter data for Mortality Plot
  filtered_data_mortality <- reactive({
    mortality_data_long %>%
      filter(AgeGroup == input$ageGroupInput, Sex %in% input$sexInput)
  })
  
  # Determine global x-axis range for synchronization
  global_xrange <- range(c(data_long$Year, mortality_data_long$Year))
  
  # Render Incidence Plot
  output$timeSeriesPlot <- renderPlotly({
    plot_ly(data = filtered_data_incidence(), x = ~Year, y = ~Cases, color = ~Sex, colors = cb_palette, 
            type = "scatter", mode = "lines",
            hoverinfo = "text",
            text = ~paste("Year:", Year, "<br>Sex:", Sex, "<br>Age Group:", AgeGroup, "<br>Cases:", Cases)) %>%
      layout(title = paste("Yearly Melanoma Cases in Victoria by Gender (Age Group:", input$ageGroupInput, ")"),
             xaxis = list(title = "Year", range = global_xrange),
             yaxis = list(title = "Number of Cases")) %>%
      config(displayModeBar = FALSE)  # Hides the plotly default toolbox
  })
  
  # Render Mortality Plot
  output$mortalityPlot <- renderPlotly({
    p <- filtered_data_mortality() %>%
      plot_ly(x = ~Year,
              y = ~Value,
              color = ~Sex,
              colors = cb_palette,
              type = "scatter",
              mode = "lines+markers",
              hoverinfo = "text",
              text = ~paste("Year:", Year, "<br>Sex:", Sex, "<br>Age Group:", AgeGroup,
                            "<br>ASR:", ASR, "<br>Crude Rate:", CrudeRate)) %>%
      layout(title = paste("Melanoma Mortality in Victoria by Year and Gender (Age Group:", input$ageGroupInput, ")"),
             xaxis = list(title = "Year", range = global_xrange),
             yaxis = list(title = "Age Specific Rate")) %>%
      config(displayModeBar = FALSE)  # Hides the plotly default toolbox
    
    p
  })
  
  # Render Overall Melanoma Rates Plot
  output$overallPlot <- renderPlotly({
    plot_ly(data = overall_data, x = ~Country, y = ~ASR, type = "bar", 
            color = ~ASR, colors = c('#56B4E9', '#CC79A7'),  # Updated colors
            hoverinfo = "text",
            text = ~paste("Country:", Country, "<br>ASR:", ASR)) %>%
      layout(title = "Overall Melanoma Rates Globally") %>%
      config(displayModeBar = FALSE)  
  })
  
  # Render Melanoma Rates in Men Plot
  output$menPlot <- renderPlotly({
    plot_ly(data = men_data, x = ~Country, y = ~ASR, type = "bar", 
            color = ~ASR, colors = c('#56B4E9'),  # Updated colors
            hoverinfo = "text",
            text = ~paste("Country:", Country, "<br>ASR:", ASR)) %>%
      layout(title = "Melanoma Rates in Men Globally") %>%
      config(displayModeBar = FALSE)
  })
  
  # Render Melanoma Rates in Women Plot
  output$womenPlot <- renderPlotly({
    plot_ly(data = women_data, x = ~Country, y = ~ASR, type = "bar", 
            color = ~ASR, colors = c('#CC79A7'),  # Updated colors
            hoverinfo = "text",
            text = ~paste("Country:", Country, "<br>ASR:", ASR)) %>%
      layout(title = "Melanoma Rates in Women Globally") %>%
      config(displayModeBar = FALSE)
  })
}
