### PACKAGES ###

library(shiny)
library(tidyverse)


##### FUNCTIONS #####

### FUNCTIONS ###
churnBG <- Vectorize(function(alpha, beta, period){
  # Computes churn probabilities based on sBG distribution
  # Equation (7) in Paper 1
  #
  # Args:
  #  alpha: numeric
  #  beta: numeric
  #  period: integer or vector of integers
  #
  # Returns:
  #  Vector of churn probabilities for period(s) 
  t1 = alpha/(alpha+beta)
  result = t1
  if (period > 1) {
    result = (beta+period-2)/(alpha+beta+period-1)
  }
  
  return(result)
}, vectorize.args = c("period"))


survivalBG = Vectorize(function(alpha, beta, period){
  m = max(period)
  # Computes survival probabilites based on a sBG distribution
  #
  # Args:
  #  alpha: numeric
  #  beta: numeric
  #  period: integer or vector of integers
  #
  # Returns:
  #  Vector of survival probabilities for period(s) 
  t1 = 1-churnBG(alpha, beta, 1)
  churnlist = c(t1, -1 * cumprod(churnBG(alpha,beta,1:m))[2:m])
  
  survivals = cumsum(churnlist)
  
  result = survivals[period]
  
  return(result)
}, vectorize.args = c("period"))



MLL = function(params){
  # Computes likelihood. Equation (B3) in Paper 1
  #
  # Args:
  #  alphabeta: vector with alpha being the first and beta being the second elements, c(a,b)
  #
  # Returns:
  #  Vector of churn probabilities for period(s) 
  #
  
  alpha = params[1]
  beta = params[2]
  gamma = params[3]
  
  return(
    sqrt(
      sum(
        (
          pmax(survivalBG(alpha, beta, c(1,7,30)) - gamma, 0) - active_cust
        ) ^ 2
      ) / 3
    )
    
  )
}




optimization <- function(d1, d7, d30, new_users) {
  active_cust <<- c(d1, d7, d30)
  
  fun <- optim(c(1, 1, 0), MLL)
  
  alpha = fun$par[1]
  beta = fun$par[2]
  gamma = fun$par[3]
  
  ret = pmax(survivalBG(alpha, beta, 1:365) - gamma, 0)
  
  df = data.frame(day = 1:length(ret), ret, new_users)
  df$ret_users <- new_users * df$ret
  df$total_users <- cumsum(df$ret_users)
  
  return(df)
}





### SERVER ###

function(input, output) {

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