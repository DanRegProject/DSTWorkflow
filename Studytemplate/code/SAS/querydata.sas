/*

*/

%macro initial_data_collection;
    %start_timer(queryinit);
    %start_log(&locallogdir, initialdatacollection);

    %header(path=&projectpath, ajour=&projectdate, dataset=&projectName, initials=&ProjectOwnerinitials,
            reasons=Initial population);

    %describeSASchoices("base population made with &basediag &basemedi &baseopr &baseube", newfile=TRUE);
    /* set newfile in order to create a new empty file */

    /* example base population based on diagnosis, different ways to use input codes (see masterdata.sas) */
    %if "&basediag" ne "" %then %get(outlib=mydata, sets=&basediag, outdata=basepop1, type=DIAG);;
    %if "&basemedi" ne "" %then %get(outlib=mydata, sets=&basemedi, outdata=basepop2, type=LMDB);;
    %if "&baseopr"  ne "" %then %get(outlib=mydata, sets=&baseopr,  outdata=basepop3, type=OPR);;
    %if "&baseube"  ne "" %then %get(outlib=mydata, sets=&baseube,  outdata=basepop4, type=UBE);;
    %if "&basecar"  ne "" %then %get(outlib=mydata, sets=&basecar,  outdata=basepop5, type=CAR);;
    %if "&basepato" ne "" %then %get(outlib=mydata, sets=&basepato, outdata=basepop6, type=PATO);;

    /* reducer til een liste med pnr */
    %macro makepnrlist;
        data mydata.mypop;
            set
                %if %sysfunc(exist(mydata.basepop1)) %then mydata.basepop1;
                %if %sysfunc(exist(mydata.basepop2)) %then mydata.basepop2;
                %if %sysfunc(exist(mydata.basepop3)) %then mydata.basepop3;
                %if %sysfunc(exist(mydata.basepop4)) %then mydata.basepop4;
                %if %sysfunc(exist(mydata.basepop5)) %then mydata.basepop5;
                %if %sysfunc(exist(mydata.basepop6)) %then mydata.basepop6;;

            by pnr;
            if first.pnr;
            keep pnr;
        %runquit;
    %mend;

    %makepnrlist; /* create list of pnr */

    /* mydata.mypop skal tilrettes så der er en indexdato idate der kan referes til;
       %riskSetMatch (mydata.mypop2, mydata.mypop, idate, pop=master_population, nControls = 10,difbirthyear=0,ajour=today(),crit=,concritvar=);
       mydata.mypop2 skal efterfølgende bruges i supplemental, eller omdøbes til mydata.mypop;
    */

    %end_timer(queryinit, text=Initial data in querydata file );
    %end_log;
%mend; /* initial_data_collection */


/* this is where the long lists of data with additional medications and diagnoses are fetched */
%macro supplemental_data;
    %start_log(&locallogdir, supplementaldata);
    %start_timer(querysup);

/* Der trækkes en kopi a data for studiepopulation i mydata.mypop (default) */
/* Årsdatasæt samles i én tabel. Data hentes fra Master og placeres i mydata */
/*
    %subsetdata(pop,head,from,to,inlib=master,outlib=mydata,primtab=key-pnr,append=TRUE);
      * pop      : datasæt med studiepopulationen;
      * head     : tabelgruppe;
      * ibnlib    : libname hvor data læses fra, default=master;
      * outlib    : libname hvor data placeres, default = mydata;
      * primtab   : primær tabelgruppe hvor personident findes, kan være tom;
      * key       : nøgle som binder primtab med head;
      * append    : skal årstabeller samles i et datasæt? default = TRUE;

/* Første del er standard CPR som forventes anvendt i alle studier */
   %subsetdata(mydata.mypop,population);
   %subsetdata(mydata.mypop,vandringer);

   %subsetdata(mydata.mypop,bef);
   %subsetdata(mydata.mypop,dod);
   %subsetdata(mydata.mypop,dodsaasg);

/* Anden del tilvalgte fulde udtræk af grundtabellerne */
%if &HentFuldSOCIO=TRUE %then %do;
      %subsetdata(mydata.mypop,akm);
      %subsetdata(mydata.mypop,faik,primtab=bef,key=familie_id);
      %subsetdata(mydata.mypop,uddf);
%end;
%if &HentFuldSSSY=TRUE %then %do;

      %subsetdata(mydata.mypop,sssy);
      %subsetdata(mydata.mypop,sysi);
%end;
%if &HentFuldCAR=TRUE %then %do;
      %subsetdata(mydata.mypop,tumor_aarlig);
   *        %subsetdata(mydata.mypop,dimcancergruppering_icd10);
%end;
%if &HentFuldPATO=TRUE %then %do;
      %subsetdata(mydata.mypop,dimpatologiskdiagnose);
      %subsetdata(mydata.mypop,fctpatologiskprocedure);
      %subsetdata(mydata.mypop,fctrekvisition);

%end;
%if &HentFuldLPR=TRUE %then %do;
      %subsetdata(mydata.mypop,lpr_adm);
      %subsetdata(mydata.mypop,lpr_bes,primtab=lpr_adm,key=kontakt_id);
      %subsetdata(mydata.mypop,lpr_diag,primtab=lpr_adm,key=kontakt_id);
   *  %subsetdata(mydata.mypop,lpr_opr,primtab=lpr_adm,key=kontakt_id);
      %subsetdata(mydata.mypop,lpr_sksopr,primtab=lpr_adm,key=kontakt_id);
      %subsetdata(mydata.mypop,lpr_sksube,primtab=lpr_adm,key=kontakt_id);
      %subsetdata(mydata.mypop,priv_adm);
      %subsetdata(mydata.mypop,priv_diag,primtab=priv_adm,key=kontakt_id);
      %subsetdata(mydata.mypop,priv_sksopr,primtab=priv_adm,key=kontakt_id);
      %subsetdata(mydata.mypop,priv_sksube,primtab=priv_adm,key=kontakt_id);
      %subsetdata(mydata.mypop,psyk_adm);
      %subsetdata(mydata.mypop,psyk_diag,primtab=psyk_adm,key=kontakt_id);
      %subsetdata(mydata.mypop,lpr_f_kontakter);
      %subsetdata(mydata.mypop,lpr_f_forloeb);
      %subsetdata(mydata.mypop,lpr_f_diagnoser,primtab=lpr_f_kontakter,key=kontakt_id);
      %subsetdata(mydata.mypop,lpr_f_helbredsforloeb,primtab=lpr_f_forloeb,key=forloeb_id);
      %subsetdata(mydata.mypop,lpr_f_helbredsmarkoerer,primtab=lpr_f_forloeb,key=forloeb_id);
      %subsetdata(mydata.mypop,lpr_f_resultater,primtab=lpr_f_kontakter,key=kontakt_id);
      %subsetdata(mydata.mypop,lpr_f_procedurer_andre,primtab=lpr_f_kontakter,key=kontakt_id);
      %subsetdata(mydata.mypop,lpr_f_procedurer_kirurgi,primtab=lpr_f_kontakter,key=kontakt_id);

%end;

%if &HentFuldLMDB=TRUE %then %do;
      %subsetdata(mydata.mypop,lmdb);
      %subsetdata(mydata.mypop,indberetningmedpris);
   *  %subsetdata(mydata.mypop,laegemiddel);
%end;
%if &HentFuldLAB=TRUE %then %do;
      %subsetdata(mydata.mypop,lab_dm_forsker);
%end;

/* Tredie del tilvalgte selekterede udtræk af grundtabellerne */

%if "&diagall" ne ""     %then %get(outlib=mydata, sets=&diagall, indata=mydata.mypop, type=DIAG);;
%if "&mediall" ne ""     %then %get(outlib=mydata, sets=&mediall, indata=mydata.mypop, type=LMDB);;
%if "&oprall" ne ""      %then %get(outlib=mydata, sets=&oprall,  indata=mydata.mypop, type=OPR );;
%if "&ubeall" ne ""      %then %get(outlib=mydata, sets=&ubeall,  indata=mydata.mypop, type=UBE );;
%if "&laball" ne ""      %then %get(outlib=mydata, sets=&laball,  indata=mydata.mypop, type=LAB );;
%if "&carall" ne ""      %then %get(outlib=mydata, sets=&carall,  indata=mydata.mypop, type=CAR );;
%if "&patoall" ne ""     %then %get(outlib=mydata, sets=&patoall, indata=mydata.mypop, type=PATO);;
%if "&hmediall" ne ""    %then %get(outlib=mydata, sets=&hmediall,indata=mydata.mypop, type=HMDB);;

%end_timer(querysup, text=Supplemental data in querydata file );
%end_log;
%mend; /* Supplemental_data */