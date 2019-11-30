dm ‘log;clear;output;clear;’;
/* Desired location on PC */
libname myLib “H:\Data\WRDSData”;
%let loc = %sysfunc(pathname(myLib));
%LET wrds = wrds.wharton.upenn.edu 4016;
OPTIONS comamid=TCP remote=WRDS;
SIGNON username=”WRDS_username”
password=_prompt_;
rsubmit;
/* Compustat */
data compustat; set comp.funda (keep=gvkey datadate fyear indfmt where=(fyear >= 1995));
proc download data=compustat out=myLib.compustat;
run;
/* CRSP */
data crsp; set crspa.dsf (keep=PERMNO DATE VOL SHROUT BID ASK RET where=(date >= ’01dec1995’d));
proc download data=crsp out=myLib.crsp;
run;
/* ExecuComp */
data execcomp; set comp.anncomp (keep=gvkey INDDESC NONEQ_INCENT);
proc download data=execcomp out=myLib.execcomp;
run;
/* Linking Table */
libname cc ‘/wrds/crsp/sasdata/a_ccm’;
data linkgind; set cc.comphead (keep=gvkey gind);
proc download data=linkgind out=myLib.linkgind;
run;
data linkpermno; set cc.ccmxpf_linktable (keep=gvkey lpermno);
proc download data=linkpermno out=myLib.linkpermno;
run;
endrsubmit;
/* OUT of WRDS Server */
proc export
DATA=myLib.compustat
OUTFILE=”&loc\comp.dta”
DBMS=dta REPLACE;
run;
/* Similarly export for others */
