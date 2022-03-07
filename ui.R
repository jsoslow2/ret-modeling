### PACKAGES ###

library(shiny)
library(tidyverse)


##### THE UI ########

fluidPage(
  tags$head(
    tags$style(
      "#drafted_players{color:red; font-size:12px; font-style:italic; 
    overflow-y:scroll; max-height: 400px; background: ghostwhite;
  #your_draft{width:100%;}")
  ),
  h1("Shiny", span("Widgets Gallery", style = "font-weight: 300")),
  
  br(),
  
  column(
    4, 
    numericInput(
      inputId = 'd1',
      label = 'd1',
      value = .4,
      min = 0,
      max = 1
    ),
    numericInput(
      inputId = 'd7',
      label = 'd7',
      value = .2,
      min = 0, 
      max = 1
    ),
    numericInput(
      inputId = 'd30',
      label = 'd30',
      value = .1,
      min = 0, 
      max = 1
    ),
    br(),
    numericInput(
      inputId = 'new_users',
      label = 'New Users per Day',
      value = 100,
      min = 0
    ),
    br(),
    actionButton(
      inputId = 'generate',
      label = 'Generate Charts'
    )
  ),
  
  
  
  column(
    8,
    plotOutput('users'),
    plotOutput('retention')
  )
)