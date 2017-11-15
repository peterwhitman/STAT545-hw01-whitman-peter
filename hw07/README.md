# Process

I decided to automate my workflow using remake instead of make. Therefore, instead of a make file I have a YAML file which can be found [here](https://github.com/peterwhitman/STAT545-whitman-peter/blob/master/hw07/remake.yml). 

Perhaps the biggest challenge of using remake instead of make was the absence of extensive documentation. Remake is clearly new and still in development, so the number of users is relatively small. Aside from learning how to use remake, I struggled trying output a file for each continent containing scatterplots of life expectancy vs. year for each country. If you are interested you can take a look at my [figure.R](https://github.com/peterwhitman/STAT545-whitman-peter/blob/master/hw07/R/figures.R) script which contains the functions I developed to try and accomplish this task. I even brought my code to the professor for his help, and he was stumped. I ended up outputing one pdf file with a scatterplot for each country, which can be found [here](https://github.com/peterwhitman/STAT545-whitman-peter/blob/master/hw07/figures/Plot_lm.pdf) 

![](https://github.com/peterwhitman/STAT545-whitman-peter/blob/master/hw07/figures/Workflow.png)

Above is the diagram of my automated workflow. 

I relied heavily on the following repositories for help with remake:
* https://github.com/ropenscilabs/remake-tutorial
* https://github.com/richfitz/remake
* https://github.com/nicercode/2015.12.08-EcoStats
