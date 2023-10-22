library(shiny)
library(ggplot2)
library(dplyr)
library(readr)

# Load datasets
data_long <- read.csv("../../data/clean/cleaned_Melanoma-in-Victoria-1982-2021.csv")
df_disparities <- read.csv("../../data/clean/cleaned-disparities-Melanoma-in-Victoria-1982-2021.csv")
mortality_data_long <- read.csv("../../data/clean/cleaned-disparities-Melanoma-in-Victoria-1982-2021.csv") 

# Define UI
ui <- fluidPage(
  titlePanel("Narrative: Melanoma in Victoria (1982-2021)"),
  sidebarLayout(
    sidebarPanel(
      selectInput("section", "Choose a Story Section:",
                  choices = c("Introduction", 
                              "Incidence by Gender",
                              "Disparities in Incidence",
                              "Mortality by Age and Gender",
                              "Conclusion"),
                  selected = "Introduction"),
    ),
    mainPanel(
      uiOutput("storyContent")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  output$storyContent <- renderUI({
    switch(input$section,
           "Introduction" = introContent(),
           "Incidence by Gender" = incidenceContent(),
           "Disparities in Incidence" = disparitiesContent(),
           "Mortality by Age and Gender" = mortalityContent(),
           "Conclusion" = conclusionContent())
  })
  
  introContent <- function() {
    tagList(
      h3("Introduction"),
      p("Melanoma is a type of skin cancer that has been on the rise in recent decades."),
      p("In this narrative, we'll explore the data on melanoma incidence, disparities, and mortality in Victoria from 1982 to 2021.")
    )
  }
  
  incidenceContent <- function() {
    plot <- renderPlot({
      ggplot(data_long, aes(x = Year, y = Cases, color = Sex)) +
        geom_line() +
        labs(title = "Yearly Melanoma Cases in Victoria by Gender",
             x = "Year", y = "Number of Cases") +
        theme_minimal()
    })
    tagList(
      h3("Incidence by Gender"),
      p("This section visualizes the yearly melanoma cases in Victoria, segmented by gender."),
      plotOutput("incidencePlot")
    )
  }
  
  disparitiesContent <- function() {
    plot <- renderPlot({
      ggplot(df_disparities, aes(x = Subgroup, y = Observed)) +
        geom_bar(stat = "identity", position = "dodge", aes(fill = "Observed")) +
        geom_bar(stat = "identity", position = "dodge", aes(y = Expected, fill = "Expected")) +
        labs(y = "Number of Cases", title = "Disparities in Melanoma Incidence") +
        theme_minimal()
    })
    tagList(
      h3("Disparities in Incidence"),
      p("Here, we compare the observed vs expected cases of melanoma across different subgroups."),
      plotOutput("disparitiesPlot")
    )
  }
  
  mortalityContent <- function() {
    plot <- renderPlot({
      ggplot(mortality_data_long, aes(x = `Age Group`, y = Value)) +
        geom_col() +
        labs(y = "Age Specific Rate", x = "Age Group") +
        theme_minimal() +
        ggtitle("Mortality by Age and Gender")
    })
    tagList(
      h3("Mortality by Age and Gender"),
      p("In this section, we delve into the mortality rates associated with melanoma across different age groups and genders."),
      plotOutput("mortalityPlot")
    )
  }
  
  conclusionContent <- function() {
    tagList(
      h3("Conclusion"),
      p("Melanoma has been a significant health challenge in Victoria. By understanding the data, we can develop strategies and interventions to manage and reduce its impact."),
      p("Thank you for exploring this narrative.")
    )
  }
}

# Run the application 
shinyApp(ui = ui, server = server)

