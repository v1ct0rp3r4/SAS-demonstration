/*-------------------------------------------------------------------------------------*/
/* Create the dataset with all the input values via datalines */
/*-------------------------------------------------------------------------------------*/

/* a file may be imported, but adds complexity to standalone running this code  */

/* proc import datafile="/home/u50461344/import_from_computer/matrix_export.csv" */
/*     dbms = csv */
/*     out = heatmap_matrix */
/*     replace; */
/*     getnames = yes;  */
/* run; */

data heatmap_matrix;
  length 
  	drug_name $100;
  infile datalines dsd dlm=' ';
  input 
    drug_name :$100.
    gr7_y86_and_above
    gr6_y65_85
    gr5_y18_64
    gr4_y12_17
    gr3_y3_11
    gr2_m2_y2
    gr1_m0_1
    male
    female
    overall;
  datalines;
"Zoster, live attenuated - J07BK02" 45.9 51.7 54.3 79.1 51.8 56.6 . 30.4 26.6 36.4
"Acetylsalicylic acid - B01AC06" 17.4 22.7 19.5 3.4 7.1 14.4 . 21 16.6 18.1
"Rota virus, pentavalent, live, reassorted - J07BH02" . . 25.7 . . 2.8 2.5 4.1 4.6 6.6
"Papillomavirus (human types 6, 11, 16, 18) - J07BM01" . 47 7.5 2.5 1.5 23.8 . 4.5 4.8 6.5
"Nicotine - N07BA01" 6.3 6.7 5.3 6.6 18.2 11 . 6.4 5.3 5.4
"Insulin glargine - A10AE04" 3.4 4.9 4.7 3.2 2.7 . . 5.2 4.5 4.7
"Insulin lispro - A10AB04" 4.1 5.3 4.8 4.2 3.6 4.9 . 5.3 4.5 4.6
"Insulin aspart - A10AB05" 4.7 4.6 4.5 3.7 2.4 4.8 . 4.9 3.5 4
"Hepatitis b, purified antigen - J07BC01" 9 2.9 2.7 2.1 1.5 1.5 1.7 2.6 2.4 3.8
"Varicella, live attenuated - J07BK01" 4.4 5.8 10.2 1.7 . . 2.3 2.5 2.7 3.6
"Etonogestrel - G03AC08" . 60.4 5.8 3 . . . . 3.6 3.4
"Measles, combinations with mumps and rubella, live attenuated - J07BD52" . 5 3.9 . . . 3.9 1.5 1.9 2.5
"Abatacept - L04AA24" . 2.2 2.7 1.5 1.4 . . 2.4 2.3 2.2
"Golimumab - L04AB06" 1.9 2.8 2.8 . . . . 2.6 2.3 2.2
"Paracetamol - N02BE01" 2 1.6 2 . 2.5 5.2 6.7 2.4 1.8 2.1
"Salmeterol and fluticasone - R03AK06" 2.3 2.4 2.2 . 1.6 2.9 . 2.2 2.2 2.1
"Pneumococcus purified polysaccharides antigen and haemophilus influenzae, conjugated - J07AL52" 1.5 1.5 2.4 2.7 . . 1.9 1.6 1.5 2
"Salbutamol - R03AC02" . 1.8 1.7 2.6 2.3 3.6 . 2.1 1.9 2
"Infliximab - L04AB02" . 1.8 2.7 . . . . 2.3 1.8 1.8
"Certolizumab pegol - L04AB05" . 1.5 2 1.8 . . . 1.2 1.8 1.7
"Hydroxychloroquine - P01BA02" . 1.5 2 . 1.7 . . 1.4 1.7 1.7
"Pneumococcus, purified polysaccharides antigen conjugated - J07AL02" 2.2 2.1 2.8 3.3 . . 2.2 1.5 1.3 1.7
"Sulfasalazine - A07EC01" . 1.4 1.9 . . . . . 1.7 1.6
"Leflunomide - L04AK01" . 1.3 1.9 . 1.6 3.5 . . 1.7 1.6
"Ranitidine - A02BA02" 1.9 3.8 3.9 . 2.2 3.6 . 2 1.9 1.6
"Oxycodone - N02AA05" 2.7 1.9 2.3 3.6 3.1 8.2 . 1.9 1.5 1.6
"Tocilizumab - L04AC07" . . 1.9 . . . . . 1.7 1.5
"Rivaroxaban - B01AF01" 1.3 1.5 1.6 2.4 6.1 10.7 . 1.5 1.5 1.4
"Adalimumab - L04AB04" . 1.2 1.6 . . . . 1.1 1.4 1.3
"Risperidone - N05AX08" 1.8 1.6 1.4 . 1.2 9.6 . 1.5 1.3 1.3
;
run;

/* necessary sorting step  */
proc sort data=heatmap_matrix;
by DESCENDING drug_name;
run;

/* print the table to check  */
proc print data = heatmap_matrix noobs;
run;

/*-------------------------------------------------------------------------------------*/
/* Reshape data to "long" format and sensible column names */
/*-------------------------------------------------------------------------------------*/

proc transpose data=heatmap_matrix out=heatmap_matrix_temp name=strata;
  by DESCENDING drug_name;
run;

data heatmap_matrix_long;
    set heatmap_matrix_temp;
    rename COL1=ROR; 
run;

proc print data = heatmap_matrix_long noobs;
run;

/*-------------------------------------------------------------------------------------*/
/* Reorder dataset to get highest ROR based on stratum "overall" in the heatmap */
/*-------------------------------------------------------------------------------------*/

/* Get values from overall stratum */

/* proc sql; */
/* DROP TABLE ror_overall; */
/* quit; */

proc sql;
  create table ror_overall as
  select drug_name, ROR
  from heatmap_matrix_long
  where strata = "overall";
quit;

/* Sort drugs by ascending value */
proc sort data=ror_overall;
  by ROR;
run;

/* Add an ordering/sorting variable */

/* proc sql; */
/* drop table ror_overall; */
/* quit; */

data ror_overall;
  set ror_overall;
  order_id = _N_;
run;

/* Left join with the original dataset to be sorted */

/* proc sql; */
/* drop table heatmap_sorted; */
/* quit; */

proc sql;
  create table heatmap_sorted as
  select a.*, b.order_id
  from heatmap_matrix_long as a
  left join ror_overall as b
  on a.drug_name = b.drug_name;
quit;

/* Sort by order_id */
proc sort data=heatmap_sorted;
  by order_id;
run;

proc print data = heatmap_sorted;
run;

/*-------------------------------------------------------------------------------------*/
/* Produce the heatmap with sensible column names */
/*-------------------------------------------------------------------------------------*/

/* Give the strata appropriate names */
proc format;
    value $strata_names
"gr7_y86_and_above" = "Above 85 Years"
"gr6_y65_85" = "65-85 Years"
"gr5_y18_64" = "18-64 Years"
"gr4_y12_17" = "12-17 Years"
"gr3_y3_11" = "3-11 Years"
"gr2_m2_y2" =  "2 Months - 2 Years"
"gr1_m0_1" = "0-1 Month"
"male" = "Male"
"female" = "Female"
"overall" = "Entire database";              
run;

/* Change graphics output settings and create the heatmap */
ods graphics / reset width=1200px height=800px imagename="heatmap"; 
proc sgplot data=heatmap_sorted noautolegend;
  heatmapparm 
  	x = strata 
  	y = drug_name 
  	colorresponse = ROR /
  	colormodel=(white yellow red)
  	nomissingcolor;
	text x = strata y = drug_name text=ROR / strip;      
   	xaxis valuesformat=$strata_names. discreteorder=data display=(nolabel);
   	yaxis display=(nolabel);
   	gradlegend;
  		run;
