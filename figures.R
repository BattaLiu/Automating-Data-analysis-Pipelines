# Generate figures
rm(list = ls())
library(dplyr)
library(readr)
library(ggplot2)
gapminder <- read_tsv("gap_sort.tsv")
rank_int <- read_tsv("reg_worst_best.tsv")
pick <- semi_join(gapminder,rank_int,by="country")
pick$continent <- as.factor(pick$continent)
pick$country <- as.factor((pick$country))
str(pick)


for (i in levels(pick$continent)){
	ggplot(pick %>% filter(continent==i),aes(x = year,y = lifeExp)) +
		geom_smooth(se = TRUE, method = "lm") + 
		geom_point() + facet_wrap(~country)+ggtitle(paste("lifeExp changes in Best and Worst countries in",i,sep=" "))
	k <- paste("lifeExp_growth_",i,".png",sep="")
	ggsave(k)
}
