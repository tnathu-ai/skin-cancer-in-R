##################################
# Melanoma Studies Analysis      #
# by tnathu-ai          #
# server.R file                  #
##################################

library(shiny)
library(tidyverse)
library(leaflet.extras)
library(rvest)

#####################
# SUPPORT FUNCTIONS #
#####################

# function to retrieve a melanoma image from the melanoma wiki page
melanoma_image <- function (melanoma_Type){
  
  melanoma_WikiUrl <- gsub(" ","_",paste0("https://en.wikipedia.org/wiki/",melanoma_Type))
  melanoma_Img <- read_html(melanoma_WikiUrl)
  melanoma_Img <- melanoma_Img %>% html_nodes("img")
  
  list_melanoma_Img <- (grepl("This is a featured article", melanoma_Img) | grepl("Question_book-new.svg.png", melanoma_Img) | grepl("Listen to this article", melanoma_Img) | grepl("This is a good article", melanoma_Img))
  melanoma_Img <- melanoma_Img[min(which(list_melanoma_Img == FALSE))]
  
  melanoma_Img <- gsub("\"","'",melanoma_Img)
  melanoma_Img <- gsub("//upload.wikimedia.org","https://upload.wikimedia.org",melanoma_Img)
  melanoma_Img <- sub("<img","<img style = 'max-width:100%; max-height:200px; margin: 10px 0px 0px 0px; border-radius: 5%; border: 1px solid black;'",melanoma_Img)
  
  return(melanoma_Img)
}

# function that builds the melanoma card html pop up
melanoma_card <- function (melanoma_Type, melanoma_Subtype, melanoma_Staging, melanoma_Prognosis, melanoma_Incidence, melanoma_Treatment) {
  
  # ... (similar transformation as above with park_card, but adapted for the new context)
}

##################
# DATA WRANGLING #
##################

incidence <- read.csv("../data/clean/cleaned-incidence-Melanoma-in-Victoria-1982-2021.csv")
disparities <- read.csv("../data/clean/cleaned-disparities-Melanoma-in-Victoria-1982-2021.csv")
mortality <- read.csv("../data/clean/cleaned-mortality-Melanoma-in-Victoria-1982-2021.csv")

################
# SERVER LOGIC #
################

shinyServer(function(input, output) {
  
  # ... (rest of the code, adjusted for melanoma studies)
})
