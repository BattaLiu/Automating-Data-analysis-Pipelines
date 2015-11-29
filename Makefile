all:	HW9-report.html

gap_sort.tsv lifeExp_dist.png gdpPercap_dist.png gdpPercap_dist_continent.png gdpPercap_growth_continent.png:	download.R
	Rscript '$<'
	rm Rplots.pdf
	

reg_life_year.tsv reg_worst_best.tsv:	analysis.R gap_sort.tsv
	Rscript '$<'
	
lifeExp_growth_Africa.png lifeExp_growth_Americas.png lifeExp_growth_Asia.png lifeExp_growth_Europe.png lifeExp_growth_Oceania.png:	figures.R gap_sort.tsv reg_worst_best.tsv
	Rscript '$<'
	rm Rplots.pdf

HW9-report.html: HW9-report.rmd lifeExp_dist.png gdpPercap_dist.png gdpPercap_dist_continent.png gdpPercap_growth_continent.png lifeExp_growth_Africa.png lifeExp_growth_Americas.png lifeExp_growth_Asia.png lifeExp_growth_Europe.png lifeExp_growth_Oceania.png
	Rscript -e 'rmarkdown::render("$<")'
	
clean:	
	rm -f report.html lifeExp_dist.png gdpPercap_dist.png gdpPercap_dist_continent.png gdpPercap_growth_continent.png lifeExp_growth_Africa.png lifeExp_growth_Americas.png lifeExp_growth_Asia.png lifeExp_growth_Europe.png lifeExp_growth_Oceania.png gap_sort.tsv reg_life_year.tsv reg_worst_best.tsv
	
	
	