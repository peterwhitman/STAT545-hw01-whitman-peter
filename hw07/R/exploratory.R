download_data <- function(dest) 
{
  download.file("https://github.com/ropenscilabs/remake-tutorial/blob/master/data/gapminder.csv", dest)
}

read <- function(filename) 
{
  x <- read.csv(filename)
  return(x)
}

lifeExp_scatter <- function(project_data)
{
  ggplot(project_data, aes(x = continent, y = lifeExp)) +
    geom_boxplot(outlier.colour = "hotpink") +
    geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1/4) +
    labs(title="Boxplot of Life Expectancy by Continent")
}

lifeExp_time <- function(project_data)
{
    ggplot(project_data, aes(year, lifeExp, color = continent, group = continent)) + 
    geom_smooth() + labs(x="Year",  y="Life Expectancy", title="Changes in Life Expectancy Over Time") + 
    scale_colour_discrete("Continents")
}

reorder_continents_lifeExp <- function(project_data)
{
  p <- project_data 
  t <- project_data %>%
    group_by(continent) %>%
    summarize(MeanLifeExp = mean(lifeExp)) 
  join <- left_join(p, t, by = "continent") %>%
    arrange(desc(MeanLifeExp)) %>%
    droplevels()
  return(join)
}

