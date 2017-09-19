hw01\_gapminder
================
Peter Whitman
9/17/2017

### 1. Initialize gapminder and tidyverse

``` r
library(gapminder)
library(tidyverse)
```

    ## Loading tidyverse: ggplot2
    ## Loading tidyverse: tibble
    ## Loading tidyverse: tidyr
    ## Loading tidyverse: readr
    ## Loading tidyverse: purrr
    ## Loading tidyverse: dplyr

    ## Conflicts with tidy packages ----------------------------------------------

    ## filter(): dplyr, stats
    ## lag():    dplyr, stats

### 2. Plot life expentancy by year

``` r
plot(lifeExp ~ year, gapminder)
```

![](hw01_gapminder_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-2-1.png)

### 3. Plot life expentancy by GDP per capita

``` r
plot(lifeExp ~ gdpPercap, gapminder)
```

![](hw01_gapminder_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-3-1.png)

### 4. Plot life expentancy by log(GDP per capita)

``` r
plot(lifeExp ~ log(gdpPercap), gapminder)
```

![](hw01_gapminder_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-4-1.png)

### 5. Provide a summary of the Life Expectancy data

``` r
summary(gapminder$lifeExp)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   23.60   48.20   60.71   59.47   70.85   82.60

### 6. Produce frequency distribution histogram for Life Expectancy

``` r
hist(gapminder$lifeExp)
```

![](hw01_gapminder_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-6-1.png)

### 7. Create a frequency distribution bar plot for each continent

``` r
barplot(table(gapminder$continent))
```

![](hw01_gapminder_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-7-1.png)

### 8. Explore the relationship between GDP and Life expectancy and the variation between continents

``` r
p <- ggplot(filter(gapminder, continent != "Oceania"),
            aes(x = gdpPercap, y = lifeExp)) # just initializes
p <- p + scale_x_log10() # log the x axis the right way
p + geom_point() # scatterplot
```

![](hw01_gapminder_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-8-1.png)

``` r
p + geom_point(aes(color = continent)) # map continent to color
```

![](hw01_gapminder_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-8-2.png)

``` r
p + geom_point(alpha = (1/3), size = 3) + geom_smooth(lwd = 3, se = FALSE)
```

    ## `geom_smooth()` using method = 'gam'

![](hw01_gapminder_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-8-3.png)

``` r
p + geom_point(alpha = (1/3), size = 3) + facet_wrap(~ continent) +
  geom_smooth(lwd = 1.5, se = FALSE)
```

    ## `geom_smooth()` using method = 'loess'

![](hw01_gapminder_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-8-4.png)
