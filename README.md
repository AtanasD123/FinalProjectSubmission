# Link-Up - Football / Soccer Data Vizualization App

## The App

The app is available at https://atanasd.shinyapps.io/PrototypeAtanas/

The first tab takes in two teams of the user's choosing as well as a statistic. The outputted line chart compares the change in the stat across both teams for the last 10 seasons.

The second tab, has the user input a season, league, and two statistics. The resulting scatter plot has the top 25 players of that season (based on the statistic chosen for the x-axis). 
  - Players colored in red have performed the mean for both the x and y axes.
  - Players colored in black have performed below the mean for at least one of the axes.
  
## Data scraping 

All of the data has been sampled from the WorldfootballR package. 

To create the first seasonSummary.csv file the function, we call the end_season_summary function and write the result onto a csv. 

Similairly, the playerStats.csv uses the fb_big5_advanced_season_stats function and loops over all the past 10 seasons.

- More documentation is available inside the demo.Rmd file
- The demo.Rmd file contains a "work in progress" section that will be used to find the cosine similarities between the best players found in the playerStats.csv
- This section is not part of the project submission or the app 




