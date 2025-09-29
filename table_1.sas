/* creating table 1 */

data mytable;
    length Col1 $50 Col2 $1 Col3 $1;
    infile datalines dsd dlm=' ';
    input Col1 :$50. Col2 $ Col3 $;
    datalines;
"A drug of interest" A B
"All other drugs" C D
;
run;

/* adjusting header */
proc report data=mytable nowd;
    column Col1 Col2 Col3;
    define Col1 / display ' ';  /* blank header */
    define Col2 / display "Any PT from narrow ME SMQ";
    define Col3 / display "Other events";
run;
