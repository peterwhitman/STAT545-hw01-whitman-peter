Plotlm <- function(sorted_data)
{
  p <-gapminder %>%
    group_by(continent) %>%
    ggplot(aes(x = year, y = lifeExp)) + 
    geom_point(alpha = 0.5) +
    geom_smooth(method = "lm", se = FALSE)
  
  plots <- facet_multiple(plot = p, facets = 'country', ncol = 2, nrow = 2)
  plots
}


AfricaPlot_lm <- function(sorted_data)
{
  Africa <- sorted_data %>%
    filter(continent == "Africa") %>%
    group_by(country) 
  
  N_uniqueC <- length(unique(Africa$country))
  for (i in seq(1, N_uniqueC, 5)) 
  {
    print(ggplot(Africa[Africa$country %in% levels(Africa$country)[i:(i+5)], ], 
                 aes(year, lifeExp)) + 
            geom_point() +
            geom_smooth(method = "lm", se = FALSE) +
            facet_wrap(~ country) +
            theme_bw())
  }
}

AsiaPlot_lm <- function(sorted_data)
{
  Asia <- sorted_data %>%
    filter(continent == "Asia") %>%
    group_by(country) 
  for (i in seq(1, length(unique(Asia$country)), 6)) 
  {
    print(ggplot(Asia[Asia$country %in% levels(Asia$country)[i:(i+5)], ], 
                 aes(year, lifeExp)) + 
            geom_point() +
            geom_smooth(method = "lm", se = FALSE) +
            facet_wrap(~ country) +
            theme_bw())
  }
}

AmericasPlot_lm <- function(sorted_data)
{
  Americas <- sorted_data %>%
    filter(continent == "Americas") %>%
    group_by(country) 
  for (i in seq(1, length(unique(Americas$country)), 6)) 
  {
    print(ggplot(Americas[Americas$country %in% levels(Americas$country)[i:(i+5)], ], 
                 aes(year, lifeExp)) + 
            geom_point() +
            geom_smooth(method = "lm", se = FALSE) +
            facet_wrap(~ country) +
            theme_bw())
  }
}

EuropePlot_lm <- function(sorted_data)
{
  Europe <- sorted_data  %>%
    group_by(country) %>%
    filter(continent == "Europe") %>%
    ggplot(aes(year, lifeExp)) + 
    geom_point() +
    geom_smooth(method = "lm", se = FALSE) 
  plotEurope <- facet_multiple(plot = Europe, facets='country', nrow=2, ncol=2)
  plotEurope
}

OceaniaPlot_lm <- function(sorted_data)
{
  Oceania <- sorted_data %>%
    filter(year >= 1952 & continent == "Oceania") %>%
    group_by(country) 
  for (i in seq(1, length(unique(Oceania$country)), 6)) 
  {
    print(ggplot(Oceania[Oceania$country %in% levels(Oceania$country)[i:(i+5)], ], 
                 aes(year, lifeExp)) + 
            geom_point() +
            geom_smooth(method = "lm", se = FALSE) +
            facet_wrap(~ country) +
            theme_bw())
  }
}

