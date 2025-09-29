/* a file may be imported, but adds complexity to standalone running this code  */

/*
proc import datafile="/home/u50461344/import_from_computer/result_reports_per_year.csv"
    dbms = csv
    out = results_all_icsr_me_prop
    replace;
    getnames = yes; 
run;

proc print data = results_all_icsr_me_prop noobs;
run;
*/

/* providing the input data*/
data results_all_icsr_me_prop;
	input year all_reports proportion_me;
    datalines;
2021 2184169 2.2
2020 741414 3.7
2019 784513 3.5
2018 752382 3.7
2017 575466 2.8
2016 464997 2.8
2015 498832 2.7
2014 492261 2.6
2013 473273 2.5
2012 476834 3.3
2011 373428 3.0
2010 339538 3.0
2009 391262 2.5
2008 632042 2.2
2007 220999 1.3
2006 137244 1.2
2005 86625 1.6
2004 24360 1.1
2003 12403 1.2
2002 59 0.0
;
run;

proc print data = results_all_icsr_me_prop noobs;
run;

/*-------------------------------------------------------------------------------------*/

/* making the basic 2-in-1 plot known as figure 2 */

proc sgplot data = results_all_icsr_me_prop noautolegend;

title "Figure 2. Reports submitted to EudraVigilance";
	vbar year / response = all_reports y2axis
		fillattrs = (color = red);
	vline year / response = proportion_me
		lineattrs = (color = blue);
	xaxis label = "Year";          
	yaxis label = "Proportion of Medication Error reports (%)";
	y2axis label = "All reports submitted to EudraVigilance"; 
run;
