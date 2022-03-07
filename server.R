library(shiny)
library(tidyverse)

function(input, output) {
  
  ##TODO observeEvent on 'generate'
  observeEvent(input$generate, {
    df = optimization(input$d1, input$d7, input$d30, input$new_users)
    
    output$users = renderPlot({
      ggplot(
        data = df,
        mapping = aes(
          x = day,
          y = total_users
        )
      ) +
        geom_line() +
        theme_bw() +
        ylab("DAUs")
    })
    
    
    output$retention = renderPlot({
      ggplot(
        data = df, 
        mapping = aes(
          x = day,
          y = ret
        )
      ) +
        geom_line() +
        theme_bw() +
        ylab("Retention")
    })
    
    
  })
  
}