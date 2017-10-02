# STAT545-hw01-whitman-peter

Hello world, my name is Peter Whitman. This is a repository that I've created for STAT 545 homework. 

The STAT 545 homework instructions can be found [here](http://stat545.com/syllabus.html)

## Introduction ##
* Degree program: I am a first year MSc student in geography
* Hometown: I was born and raised in St. Paul, MN
* Undergraduate education: I received a BA in GIS, geoscience, and environmental science from [Carthage College](https://www.carthage.edu/) in Kenosha, WI
* Favorite non-academic activities: reading historical fiction, biking, cooking, whitewater canoeing

![](https://i.pinimg.com/736x/15/23/e5/1523e522c3450d7fb1e2e8c00b4e543f--twin-cities-minneapolis.jpg)

*Downtown St. Paul, MN*

![](http://www.chicagobusiness.com/colleges-2016/images/sponsor-image-carthage.jpg)

*Carthage College campus*

![](https://scontent-sea1-1.xx.fbcdn.net/v/t1.0-9/599459_616544582597_2059276908_n.jpg?oh=d1003c2672ba481af4109786daf2b62a&oe=5A5F0016)

*Somewhere on the Kopka in Northern Ontario*

## hw02 Process ##

1. I created a repository on github
2. I started a new project in RStudio and used the web URL to Connect RStudio to git and GitHub
3. I then created a new .Rmd file locally called "hw02"
4. I worked through hw02 in the hw02.Rmd file
5. I then used the pull, edit locally, save, commit, push to github.com workflow
6. Finally, I added process and reflection sections to the README.md file locally and committed them to github.com

I actually had an easier time with this homework assignment than the first homework assignment. I feel more comfortable with github and Rstudio. I also found that with my background in GIS, queries and query logic are fairly straightforward.

I did get an error temporarily when trying to knit my hw02.Rmd file. The problem stemed from including install.packages() in addition to library(). I used a CS forum online to resolve the issue.

## hw03 Process ##

I tackled the following tasks:

* Get the maximum and minimum of GDP per capita for all continents.
* How is life expectancy changing over time on different continents?
* Report the absolute and/or relative abundance of countries with low life expectancy over time by continent

I found that the third task was the most challenging. I had trouble computing the number of countries below the mean life expectancy rate for each year by continent. I found it easy to compute the number of countries below the mean life expectancy rate for each year, but I couldn't break it down by continent. To remedy this problem I used count(benchmark, year) instead of just count(benchmark). 
