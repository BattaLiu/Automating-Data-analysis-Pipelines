all:	report.html

clean:	
	rm -f report.html lifeExp_dist.png gdpPercap_dist.png gdpPercap_dist_continent.png gdpPercap_growth_continent.png lifeExp_growth_Africa.png lifeExp_growth_Americas.png lifeExp_growth_Asia.png lifeExp_growth_Europe.png lifeExp_growth_Oceania.png 
	
reg_worst_best.tsv:	pipeline.R
	Rscript -e '$<'

report.html: HW9-report.rmd
	Rscript -e 'rmarkdown::render("$<")'