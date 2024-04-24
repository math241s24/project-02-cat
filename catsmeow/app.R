#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

# Put all necessary libraries here
library(shiny)
library(tidyverse)
library(dplyr)
library(readr)
library(ggplot2)
library(sf)
library(tmap)
library(shiny)
library(lubridate)

#Pulling data from csv files
cat_movement <- read_csv("data/cats_us.csv")
cat_reference <- read_csv("data/cats_us_reference.csv")

#Tidying up the date and time variables in both dataframes
cat_movement <- cat_movement %>% 
  mutate(Time = format(as.POSIXct(timestamp), 
                       format = "%H:%M:%S"),
         Date = as.Date(timestamp)) %>%
  filter(visible) %>%
  subset(select = -timestamp)
cat_reference <- cat_reference %>%
  mutate(`Date-Deploy-On` = as.Date(`deploy-on-date`),
         `Time-Deploy-On` = format(as.POSIXct(`deploy-on-date`), 
                                   format = "%H:%M:%S"),
         `Date-Deploy-Off` = as.Date(`deploy-off-date`),
         `Time-Deploy-Off` = format(as.POSIXct(`deploy-off-date`), 
                                    format = "%H:%M:%S")) %>%
  subset(select = -`deploy-off-date`) %>%
  subset(select = -`deploy-on-date`)

#ordering data alphabetically by animal id
cat_reference <- cat_reference[order(cat_reference$`animal-id`), ]

# Custom distance function using Haversine formula to convert coordinates to distance
haversine_distance <- function(lon1, lat1, lon2, lat2) {
  lon1_rad <- lon1 * pi / 180
  lat1_rad <- lat1 * pi / 180
  lon2_rad <- lon2 * pi / 180
  lat2_rad <- lat2 * pi / 180
  # Earth radius in kilometers
  R <- 6371
  # Haversine formula
  dlon <- lon2_rad - lon1_rad
  dlat <- lat2_rad - lat1_rad
  a <- sin(dlat/2)^2 + cos(lat1_rad) * cos(lat2_rad) * sin(dlon/2)^2
  c <- 2 * atan2(sqrt(a), sqrt(1-a))
  distance <- R * c
  return(distance)
}

# Creating variable distance between each observation and the one right before it
cat_movement$distance <- c(NA, haversine_distance(cat_movement$`location-long`[-nrow(cat_movement)],
                                                  cat_movement$`location-lat`[-nrow(cat_movement)], 
                                                  cat_movement$`location-long`[-1], 
                                                  cat_movement$`location-lat`[-1]))

#convert distance from Km to m
cat_movement <- cat_movement %>%
  mutate(distance = distance*1000)

#Disable scientific notation
options(scipen = 999)

#Creating variables for average distances per 3 minute cycle and per day
summaries_by_day <- cat_movement %>%
  group_by(`individual-local-identifier`, Date) %>%
  summarize(mean_distance = mean(distance, 
                                 na.rm = TRUE),
            sum_distance = sum(distance, 
                               na.rm = TRUE))

#Creating variables for averages for each cat
summaries_by_cat <- summaries_by_day %>%
  group_by(`individual-local-identifier`) %>%
  summarize(mean_distance_obs = mean(mean_distance),
            avg_distance_day = mean(sum_distance)) 

#Binding the reference cat dataset with their average distances per cycle and per day, removing any cat with no age listed
merged_summaries_by_cat <- cbind(summaries_by_cat, 
                                 cat_reference) %>%
  filter(!is.na(`animal-life-stage`)) 

#Tidying up the life stage variable by removing "years" in each observations
merged_summaries_by_cat$`animal-life-stage` <- gsub(" years", 
                                                    "", 
                                                    merged_summaries_by_cat$`animal-life-stage`)
merged_summaries_by_cat$`animal-life-stage` <- gsub(" year", 
                                                    "", 
                                                    merged_summaries_by_cat$`animal-life-stage`)

#Tidying up the animal comments variable by separating it into two variables for hunting and prey per month
merged_summaries_by_cat <- cbind(merged_summaries_by_cat, 
                                 do.call(rbind, 
                                         strsplit(merged_summaries_by_cat$`animal-comments`, 
                                                  "; ", 
                                                  fixed = TRUE)))
merged_summaries_by_cat <- merged_summaries_by_cat %>%
  subset(select = -`3`) %>%
  rename(`Hunt` = `1`,
         `prey_p_month` = `2`)
merged_summaries_by_cat$hunt <- ifelse(grepl("Yes", 
                                             merged_summaries_by_cat$Hunt), 
                                       TRUE, FALSE)
merged_summaries_by_cat$prey_p_month <- as.numeric(gsub("prey_p_month: ", 
                                                        "", 
                                                        merged_summaries_by_cat$prey_p_month))

#Tidying up the manipulation comments variable by separating it into two variables for hours spent indoors and number of cats in the household 
merged_summaries_by_cat <- cbind(merged_summaries_by_cat, do.call(rbind, strsplit(trimws(merged_summaries_by_cat$`manipulation-comments`), ";", fixed = TRUE)))
merged_summaries_by_cat <- merged_summaries_by_cat %>%
  subset(select = -`3`) %>%
  rename(`hrs_indoors` = `1`,
         `n_cats_household` = `2`)
merged_summaries_by_cat$hrs_indoors <- as.numeric(gsub("hrs_indoors: ", 
                                                       "", 
                                                       merged_summaries_by_cat$hrs_indoors))
merged_summaries_by_cat$n_cats_household <- as.numeric(gsub("n_cats: ", 
                                                            "", 
                                                            merged_summaries_by_cat$n_cats_household))

#Getting rid of unnecessary variables and observations outside the United States
merged_summaries_by_cat <- merged_summaries_by_cat %>%
  subset(select = -`animal-comments`) %>%
  subset(select = -`manipulation-comments`) %>%
  subset(select = -`Hunt`) %>%
  subset(select = -`animal-taxon`) %>%
  subset(select = -`attachment-type`) %>%
  subset(select = -`data-processing-software`) %>%
  subset(select = -`deployment-end-type`) %>%
  subset(select = -`duty-cycle`) %>%
  subset(select = -`manipulation-type`) %>%
  subset(select = -`tag-manufacturer-name`) %>%
  subset(select = -`tag-mass`) %>%
  subset(select = -`tag-model`) %>%
  subset(select = -`tag-readout-method`) %>%
  filter(`study-site` != "Denmark" & `study-site` != "Newfoundland")












# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
