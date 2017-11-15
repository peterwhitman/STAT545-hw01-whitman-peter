tabulatelm <- function(sorted_data)
{
  gfits_broom <- sorted_data %>%
    group_by(country, continent) %>% 
    do(tidy(lm(lifeExp ~ I(year - 1952), data = .)))
  gfits_broom
}

TopBottom_Intercept <- function(Table_lm)
{
  TopBottom <- Table_lm %>%
    group_by(continent, country) %>%
    filter(term == "I(year - 1952)") %>%
    summarize(Slope = max(estimate))
  BottomTop <- Table_lm %>%
    group_by(continent) %>%
    filter(term == "I(year - 1952)") %>%
    summarize(MaxSlope = max(estimate), MinSlope = min(estimate)) %>%
    melt(id.vars = "continent") %>%
    select(continent, value) 
  names(BottomTop)[names(BottomTop)=="value"] <- "Slope"
  Join <- left_join(BottomTop, TopBottom, by = "Slope")
  Ordered <- Join %>%
    select(continent.x, Slope, country) %>%
    arrange(continent.x)
  Ordered
}
