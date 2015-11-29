# download online data
rm(list=ls())
#library("RCurl")
#cat(file = "gapminder.tsv",RCurl::getURL("https://raw.githubusercontent.com/jennybc/gapminder/master/inst/gapminder.tsv"))
library(downloader)
download(url = "https://raw.githubusercontent.com/jennybc/gapminder/master/inst/gapminder.tsv", destfile = "gapminder.tsv")

#Bring in the data as data frame
library(readr)
gapminder <- read.delim("gapminder.tsv")
str(gapminder)

#Descriptive plots
#remove the oc
library(ggplot2)
library(dplyr)

barplot(table(gapminder$continent))

p1 <- ggplot(gapminder,aes(x=lifeExp)) + geom_histogram()+ggtitle("lifeExp distribution")
p2 <- ggplot(gapminder,aes(x=gdpPercap)) + geom_histogram()+ggtitle("gdpPercap distribution")
p3 <- ggplot(gapminder,aes(x=continent, y=gdpPercap)) + geom_boxplot(aes(fill=continent)) + 
	scale_y_log10() + ggtitle("log(gdpPercap) distribution in different continents")
p4 <- ggplot(gapminder,aes(x=year, y=gdpPercap)) + 
	geom_point(aes(color = country)) + 
	geom_smooth(lwd = 2, se= FALSE, method = "lm") + 
	scale_y_log10() + facet_grid(~continent) +
	ggtitle("log(gdpPercap) growth in different continent")

ggsave(file="lifeExp_dist.png",plot=p1)
ggsave(file="gdpPercap_dist.png",plot=p2)
ggsave(file="gdpPercap_dist_continent.png",plot=p3)
ggsave(file="gdpPercap_growth_continent.png",plot=p4)

# Reorder the continents based on life expectancy according to the cross-country 
# difference of lifeExp in each continent 2007. 

gap <- gapminder %>% 
	filter(year==2007) %>% 
	group_by(continent) %>% 
	summarise(diff = max(lifeExp)-min(lifeExp))

gap <- full_join(gapminder,gap)
gapminder <- gap %>% 
	mutate(continent=reorder(continent,diff))
levels(gapminder$continent)
# sort the data according to continent, country, and year variable
sort <- gapminder[order(gapminder$continent,gapminder$country, gapminder$year),]

write_tsv(sort,"gap_sort.tsv")
