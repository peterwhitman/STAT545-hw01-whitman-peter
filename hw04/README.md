# Process

I completed the following tasks
* Make a tibble with one row per year and columns for life expectancy for two or more countries.
    + Use knitr::kable() to make this table look pretty in your rendered homework.
    + Take advantage of this new data shape to scatterplot life expectancy for one country against that of another.
* Create a second data frame, complementary to Gapminder. Join this with (part of) Gapminder using a dplyr join function and make some observations about the process and result. Explore the different types of joins>

I found the first task relatively easy. Reshaping the tibble is actually somewhat counterproductive. One could easily create the same scatterplot without reshaping the tibble, but reshaping the tibble allowed me to practice using the spread and melt functions, which came in handy during the second task.

The second task was more difficult. For this task, I found a Human Development Index (HDI) dataset curated by the United Nations (UN). The dataset was comprised of HDI values for 186 countires between 1990 and 2015. HDI is used by the UN to determine which countries are considered developed and which countries are considered developing. I was pretty interested in how HDI is computed, so I ran linear regression tests to discern the relationship between HDI and life expectancy, GDP/capita, and population. Life expectancy and GDP/capita produced acceptable r^2^ values. I also wanted to see how the number of developed countries increased between 1992 and 2007 by continent. This timespan corresponds to the gapminder survey dates. The biggest source of trouble stemmed from importing a dataset. For whatever reason, when I tried to knit the document it wouldn't recognize the file. Eventually I realized I needed to to use the read_excel function. I also had some minor difficulties with replacing NA values with zeros. Neither the replace nor the replace_na functions worked. Instead, I used dev4[is.na(dev4)] <- 0

the hw04.md file can be found (here)[https://github.com/peterwhitman/STAT545-whitman-peter/blob/master/hw04/hw04.md]
