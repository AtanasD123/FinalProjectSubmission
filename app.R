#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(worldfootballR)
library(stringr)
library(dplyr)
library(ggrepel)

end_season_summary <- read_csv("seasonSummary.csv")
player_stats <- read_csv("PlayerStats.csv")

ui <- fluidPage(
  
  shinythemes::themeSelector(),
  
  titlePanel("Link-Up"),
  
  navbarPage(title = "Link-Up",
             tabPanel("Team Stats",
                      sidebarPanel(
                        selectInput(inputId = "Team1",
                                    label = "Choose your team:", 
                                    choices = c("Tottenham" = "Tottenham",
                                                "Arsenal" = "Arsenal",
                                                "Manchester City" = "Manchester City",
                                                "Manchester United" = "Manchester Utd",
                                                "Chelsea" = "Chelsea",
                                                "Liverpool" = "Liverpool")),
                        
                        selectInput(inputId = "Team2",
                                    label = "Choose your second team:", 
                                    choices = c("Liverpool" = "Liverpool",
                                                "Chelsea" = "Chelsea",
                                                "Manchester United" = "Manchester Utd",
                                                "Manchester City" = "Manchester City",
                                                "Arsenal" = "Arsenal",
                                                "Tottenham" = "Tottenham")),
                        
                        selectInput(inputId = "Statistic",
                                    label = "Choose a stat to compare:",
                                    choices = c("Standing" = "Rk",
                                                "Wins" = "W",
                                                "Loses" = "L",
                                                "Draws" = "D",
                                                "Goals For" = "GF",
                                                "Goals Against" = "GA",
                                                "Goal Difference" = "GD",
                                                "Points" = "Pts",
                                                "Match Attendance" = "Attendance",
                                                "Expected Goals" = "xG")),
                      ),
                      
                      mainPanel(
                        plotOutput("Table")
                      ),
             ),
             tabPanel("Player Stats",
                      sidebarPanel(
                        selectInput(inputId = "Season",
                                    label = "Choose a season",
                                    choices = c("2020/2021" = "2021",
                                                "2019/2020" = "2020",
                                                "2018/2019" = "2019",
                                                "2017/2018" = "2018"
                                    )
                        ),
                        selectInput(inputId = "League",
                                    label = "Choose a League",
                                    choices = c("Premier League" = "Premier League",
                                                "La Liga" = "La Liga",
                                                "Bundesliga" = "Bundesliga",
                                                "Serie A" = "Serie A",
                                                "Ligue 1" = "Ligue 1"
                                    )
                        ),
                        selectInput(inputId = "Stat",
                                    label = "Choose a statistic",
                                    choices = c("Assists" = "Ast",
                                                "Goals" = "Gls",
                                                "Goals Per 90" = "Gls_Per",
                                                "Assists Per 90" = "Ast_Per",
                                                "Penalty Kicks Scored" = "PK",
                                                "Minutes Played" = "Min_Playing",
                                                "Age" = "Age",
                                                "Yellow Cards" = "CrdY",
                                                "Red Cards" = "CrdR"
                                    )
                        ),
                        selectInput(inputId = "Stat2",
                                    label = "Choose a statistic",
                                    choices = c("Goals" = "Gls",
                                                "Assists" = "Ast",
                                                "Goals Per 90" = "Gls_Per",
                                                "Assists Per 90" = "Ast_Per",
                                                "Minutes Played" = "Min_Playing",
                                                "Age" = "Age",
                                                "Penalty Kicks Scored" = "PK",
                                                "Yellow Cards" = "CrdY",
                                                "Red Cards" = "CrdR"
                                    )
                        ),
                        
                      ),
                      mainPanel(
                        plotOutput("PlayerStatTable"),
                      )
                      
             )
  )
)
server <- function(input, output) {

  output$Table <- renderPlot({
    team1 <- end_season_summary %>% group_by(Squad) %>% filter(str_detect(Squad, input$Team1))
    team2 <- end_season_summary %>% group_by(Squad) %>% filter(str_detect(Squad, input$Team2))
    toPlot<- team1 %>% rbind(team2)
    toPlot %>% ggplot( aes_string(x = "Season_End_Year", y = input$Statistic, color = "Squad", group = "Squad")) +
      geom_line() + geom_point() + labs(x = "Seasons", color = "Teams") +
      scale_color_manual(values=c('Red','Blue')) +
      theme_classic() +
      scale_x_continuous(n.breaks = 10) + 
      scale_y_continuous(n.breaks = 10)
  })
  
  
  output$PlayerStatTable <- renderPlot({

    #stat<- reactive({input$Stat})
    #if(stat() == "Gls"){
    

    players1 <- player_stats %>% filter(str_detect(Season_End_Year, input$Season)) %>% filter(str_detect(Comp, input$League)) %>% slice_max(get(input$Stat), n=25)
    
    players1 %>% ggplot( aes_string(x = input$Stat2, y = input$Stat, label = "Player")) +
      geom_point(color = ifelse(players1[[input$Stat]] > mean(players1[[input$Stat]]) & players1[[input$Stat2]] > mean(players1[[input$Stat2]]), "red","black")) +
      geom_text_repel(size = 3.5, max.overlaps = 15) +
      labs(x = input$Stat2, y = input$Stat) + theme_classic() 
  })
  
  
}

shinyApp(ui = ui, server = server)
