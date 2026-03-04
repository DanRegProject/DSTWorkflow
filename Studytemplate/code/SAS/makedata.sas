%start_log(&locallogdir, makedata);
%start_timer(makedata);

/* dette er en skabelon udfyldt til et typisk kohorte studie, forvent nogen justering til
   det aktuelle studie */

data studie;
    set
        %if %sysfunc(exist(mydata.basepop1)) %then mydata.basepop1;
        %if %sysfunc(exist(mydata.basepop2)) %then mydata.basepop2;
        %if %sysfunc(exist(mydata.basepop3)) %then mydata.basepop3;
        %if %sysfunc(exist(mydata.basepop4)) %then mydata.basepop4;
        %if %sysfunc(exist(mydata.basepop5)) %then mydata.basepop5;
        %if %sysfunc(exist(mydata.basepop6)) %then mydata.basepop6;;

    by pnr idate;
%runquit;

/* reduce to first pnr */
data studie;
    set studie;
    by pnr idate;
    idate=opdate;
    if first.pnr;
    format idate date.;
%runquit;

%describeSASchoices("Merge the hospital periods for the base treatment to the dataset", newfile=TRUE, name=makedataSAScomments);

/* create new empty file */
%macro mergedata;
    %smoothhosp(mydata.hospitalsmooth, mydata.hospall, ajour=&projectdate, nofdays=1);

    %if "&diaglist" ne "" %then
    %merge(basedata=studie, inlib=mydata, outlib=mydata,
        indexdate=idate, datevar=start, sets=&diaglist, type=DIAG,
        invar =start slut prioritet diagtype,
        outvar=in   out prio
        postfix=B, subset=(diagtype in ("A", "B")));;

    %if "&oprlist" ne "" %then
    %merge(basedata=studie, inlib=mydata, outlib=mydata,
        indexdate=idate, datevar=start_pro, sets=&diaglist, type=OPR,
        invar =start_pro ,
        outvar=in     ,
        postfix=, subset=);;

    %if "&ubelist" ne "" %then
    %merge(basedata=studie, inlib=mydata, outlib=mydata,
        indexdate=idate, datevar=start_pro, sets=&diaglist, type=UBE,
        invar =start_pro ,
        outvar=in     ,
        postfix=, subset=);;

    %if "&medilist" ne "" %then

    %if "&medilist" ne "" %then
    %merge(basedata=studie, inlib=mydata, outlib=mydata,
    indexdate=idate, datevar=start, sets=&diaglist, type=LMDB,
    invar =eksd npack packsize strnum volume,
    outvar=eksd npack psize str vol,
    postfix=, subset=);;

    %if "&lablist" ne "" %then
    %merge(basedata=studie, inlib=mydata, outlib=mydata,
    indexdate=idate, datevar=start, sets=&diaglist, type=LAB,
    invar =samplingdate results,
    outvar=date res,
    postfix=, subset=);;

    /* makroer til at danne behandlingsperioder ud fra receptdata, variabeldosis eksempel */
    %reduceMediPeriods(mydata.lmdbwarfall,mydata.lmdbwarfper,warf,2,indexdate=idate,tabsperday=,stddosage=2.5,maxdosage=10,mindosage=1,
                   inclusiondays=, subset=, dosedata=);

    %mergePeriods(studie, mydata.lmdbwarfper,idate,warf);

/* flere behandlinger kan kombineres med %jointrt(), Adherence mål med DaysCovered kan beregnes med %DaysCov() */
/* findes i adherencemacros.sas */

   %mergePop(studie, studie, idate, ajour=&projectdate);
%mend;

%mergedata;

/* backup studie */
data mydata.studie;
    set studie;
%runquit;

%macro riskscores;
/* get risk scores and merge them onto studie */
%describeSASchoices("risk calculation looking 1 year back in time", name=makedataSAScomments);

%if "&usecharlson"  eq "TRUE" %then %multicoscore(charlson,    mydata.studie, mydata, idate, periodstart=, ajour=today(), mergebase=TRUE);;
%if "&usesegal"     eq "TRUE" %then %multicoscore(segal,       mydata.studie, mydata, idate, periodstart=, ajour=today(), mergebase=TRUE);;
%if "&usehfrs"      eq "TRUE" %then %multicoscore(hfrs,        mydata.studie, mydata, idate, periodstart=, ajour=today(), mergebase=TRUE);;
%if "&usehasbled"   eq "TRUE" %then %multicoscore(hasbled,     mydata.studie, mydata, idate, periodstart=, ajour=today(), mergebase=TRUE);;
%if "&usechadsvasc" eq "TRUE" %then %multicoscore(cha2ds2vasc, mydata.studie, mydata, idate, periodstart=, ajour=today(), mergebase=TRUE);;
%mend;

%riskscores;

data myfinal.studiept;
    set mydata.studie;
    by pnr;

    format ageidate 3.; /* no decimalpoints in age */
    if birthdate ne . then ageidate = intck('year', birthdate, idate);;
%runquit;

proc export data=myfinal.studiept outfile="&localstatadir\studiept.dta" replace;
run;

%end_timer(makedata, text=entire makedata file);
%end_log;

*%TjekMacro(mydata.seALL, diagnose, pattype diagtype, titletxt='SE diagnosis');
*%TjekMacro(mydata.hfatcall, hfatc, strnum, titletxt='HF medication');
*%TjekMacro(mydata.pciall, opr, pattype oprart, titletxt='PCI operations');




