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

function(input, output, session) {
  
  # Show introduction modal when the app starts
  showModal(modalDialog(
    title = "Welcome to the App!",
    "This application visualizes the incidence and mortality rates of melanoma in Victoria from 1982 to 2021.",
    easyClose = TRUE
  ))
  
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
}
