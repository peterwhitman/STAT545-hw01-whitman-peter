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
    filter(term == "(Intercept)") %>%
    summarize(Intercept = max(estimate))
  BottomTop <- Table_lm %>%
    group_by(continent) %>%
    filter(term == "(Intercept)") %>%
    summarize(MaxIntercept = max(estimate), MinIntercept = min(estimate)) %>%
    melt(id.vars = "continent") %>%
    select(continent, value) 
    names(BottomTop)[names(BottomTop)=="value"] <- "Intercept"
  Join <- left_join(BottomTop, TopBottom, by = "Intercept")
  Ordered <- Join %>%
    select(continent.x, Intercept, country) %>%
    arrange(continent.x)
  Ordered
}
