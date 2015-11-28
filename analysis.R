# Perform statistical analyses

rm(list=ls())

# import the data from download.R
library(readr)
gapminder <- read.delim("gap_sort.tsv") #I want continents treated as factors
str(gapminder)
#make sure new continent order is still in force
gapminder <- gapminder %>% 
	mutate(continent=reorder(continent,diff))
levels(gapminder$continent)


library(plyr)
library(dplyr)
# linear regression of life expectancy on year
reg <- ddply(gapminder, ~ country + continent,fn <- function(dat, offset = 1952) {
	the_fit <- lm(lifeExp ~ I(year - offset), dat)
	sd <- var(residuals(the_fit), na.rm = TRUE)
	setNames(c(coef(the_fit),sd), c("intercept", "slope","sd"))
})

reg <- reg[order(reg$continent,reg$country),]
#write results to file
write_tsv(reg,"reg_life_year.tsv")

# find the 3 or 4 “worst” and “best” countries for each continent


rank_int <- reg %>% 
	group_by(continent) %>% 
	filter(min_rank(intercept)<5 | min_rank(desc(intercept))<5)

write_tsv(rank_int,"reg_worst_best.tsv")

