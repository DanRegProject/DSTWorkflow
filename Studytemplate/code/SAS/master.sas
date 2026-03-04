/*

*/
*options mprint merror symbolgen mlogic macrogen ;
/* global path is general */
%let GlobalProject     = xxxxx;
%let globalprojectpath = X:\Projekter\&GlobalProject;

/* project specific names and paths */
%let ProjectName          = PXXX_yyyyyy;
%let ProjectOwnerInitials = QQQ;              /* replace */
%let projectdescription   = Template project; /* replace */
%let ProjectDate          = today();  /* replace */

%let ProjectPath          = &globalprojectpath/projects/&ProjectName;

%let ProjectStartYear     = 1977; /* look at data from &projectStartYear */

%let macropath     = &globalprojectpath/Mastercode/SAS;
%let localfinaldir = &projectpath/data/SAS;
%let localworkdir  = &projectpath/tempdata/SAS;
%let localstatadir = &projectpath/data/Stata;
%let localcodedir  = &projectpath/code/SAS;
%let locallogdir   = &projectpath/out;
%let localdir      = &projectpath/;

%let create_log     = TRUE; /* set to TRUE if you want the log in a textfile in &locallogdir */
%let create_timelog = TRUE;  /* set to TRUE if you want to monitor  execution time */

%include "&macropath/common.sas";

libname mydata "&localworkdir";
libname myfinal "&localfinaldir";

options mprint merror;
%let sqlmax    = max;

%start_log(&locallogdir, master, option=new );
%start_timer(master);

/* create header with information from top of file */
%header(path=&projectpath, ajour=&ProjectDate, dataset=&ProjectName, initials=&ProjectOwnerInitials, reason=&projectdescription);
/* local code definitions should be entered in this file */
%include "&localcodedir/local_codes.sas";

/* set to TRUE if you want to include ICD-8*/
%let useICD8   = FALSE;

/* list the information needed for creating the base population */
/* examples of how to select the main population codes, use a single table or combine e.g. LPR and ATC  */
%let basediag    = ;    /* LPR example */
%let baselmdb    = ;    /* ATC example */
%let baseOPR     = ;
%let baseUBE     = ;
%let baseLAB     = ;
%let baseCAR     = ;
%let basePATO    = ;

/***************************** Additional data *****************************************************/
/* examples of the lists - replace with the information you need for your study */

%let diaglist  = ;
%let diaglist1 = ;
%let medlist   = ;
/* operations */
%let oprlist   = ;
/* investigations */
%let ubelist   = ;
%let lablist   = ;

%let diagtil =;
%let ubetil =;
%let oprtil =;

/* combine in one macro variable */

/* edit if more macrovariables are defined above */
%let diagall  = ;
%let mediall  = ;
%let oprall   = ;
%let ubeall   = ;
%let laball   = ;
%let carall   = ;
%let patoall  = ;

%let HentFuldSOCIO = FALSE;
%let HentFuldSSSY  = FALSE;
%let HentFuldCAR   = FALSE;
%let HentFuldPATO  = FALSE;
%let HentFuldLPR   = FALSE;
%let HentFuldLAB   = FALSE;
%let HentFuldLMDB  = FALSE;

/* multicomorbidity indexes */
%let usecharlson   = FALSE; /* or TRUE */
%let usesegal      = FALSE; /* or TRUE */
%let usehfrs       = FALSE; /* or TRUE */
%let usechadsvasc  = FALSE; /* or TRUE */
%let usehasbled    = FALSE; /* or TRUE */

%macro makedoc;
    /* generate txt files for article */
    /* prefix, output folder, list of medicin/diagnosis etc., output filename */
    %if "&mediall" ne "" %then %create_datalist(atc, &locallogdir, &mediall , medilist);;
    %if "&diagall" ne "" %then %create_datalist(lpr, &locallogdir, &diagall , diaglist);; icd8=&useicd8);;
    %if "&oprall" ne "" %then %create_datalist(opr, &locallogdir, &oprall , oprlist);;
    %if "&ubeall" ne "" %then %create_datalist(ube, &locallogdir, &ubeall , ubelist);;
    %if "&laball" ne "" %then %create_datalist(lab, &locallogdir, &laball , lablist);;
    %if "&carall" ne "" %then %create_datalist(car, &locallogdir, &carall , carlist);;
    %if "&patoall" ne "" %then %create_datalist(pato, &locallogdir, &patoall , patolist);;

    %if "&useCharlson" eq "TRUE" %then %create_datalist(charlson, &locallogdir, , charlson);;
    %if "&usesegal" eq "TRUE" %then %create_datalist(segal, &locallogdir, , segal);;
    %if "&usehfrs" eq "TRUE" %then %create_datalist(hfrs, &locallogdir, , hfrs);;
    %if "&usechadsvasc" eq "TRUE" %then %create_datalist(cha2ds2vasc, &locallogdir, , cha2dsvasc);;
    %if "&usehasbled" eq "TRUE" %then %create_datalist(hasbled, &locallogdir, , hasbled);;

    %if "&usehasbled" eq "TRUE" or "&usechadsvasc" eq "TRUE" %then %do;
        %create_datalist(hypertensionDiag, &locallogdir, , hypdiag);;
        %create_datalist(hypertensionMedi, &locallogdir, , hypmedi);;
        %create_datalist(CombHypertensionMedi, &locallogdir, , comphypmedi);;
    %end;
    %if "&usechadsvasc" eq "TRUE" %then %do;
        %create_datalist(HeartFailDiag, &locallogdir, , HFdiag);;
        %create_datalist(HeartFailMedi, &locallogdir, , HFmedi);;
        %create_datalist(DiabetesDiag, &locallogdir, , Diabdiag);;
        %create_datalist(DiabetesMedi, &locallogdir, , Diabmedi);;
    %end;
%mend;

%makedoc;

%end_timer(master, text=master file until query and makedata);
%end_log;

%include "&localcodedir/QueryData.sas";
/* divide datacollection into two steps, uncomment in order to use them */
/* base population - run 1 time */
%Initial_data_collection;
/* supplemental data for basepopulation - run 1 time (requires Initial_data_collection) */
%supplemental_data;

/* create the studypt table */
%include "&localcodedir/makedata.sas";

%checklog(log=&locallogdir);
