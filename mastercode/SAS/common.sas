
%let ProjectNumber     = 012345; /* remove when everyone are using the latest master.sas template */

%let globalend = mdy(12,31,2099);
%let YearInDays = 365.25;
/* table setup */
/* xxxprim is main table of xxx information, with supplementary information (type) in xxxtype  */
%LET LPRprim=ADM;
%LET LPRdiag=DIAG;
%LET LPRopr=SKS_OPR; /* ie LPR source of OPR type data is found in physical files SKS_OPR */
%LET LPRube=SKS_UBE;

%LET PRIVprim=ADM;
%LET PRIVdiag=DIAG;
%LET PRIVopr=SKS_OPR; /* ie PRIV source of OPR type data is found in physical files SKS_OPR */
%LET PRIVube=SKS_UBE;

%LET PSYKprim=ADM;
%LET PSYKdiag=DIAG;

%LET LPR3grp=LPR_A;      /* or LPR_F */
%LET LPR3prim=KONTAKT;   /* KONTAKTER under LPR_F */
%LET LPR3diag=DIAGNOSE;  /* DIAGNOSER under LPR_F */
%LET LPR3opr=procedurekonopr; /*procedurer_kirurgi under LPR_F */
%LET LPR3ube=procedurekonube; /*procedurer_andre under LPR_F */

%LET LMDBprim=LMDB;
%LET LABprim=LAB_DM_FORSKER;
%LET PATOprim=fctrekvisition;
%LET PATOpato=dimpatologiskdiagnose;
%LET PATOpato2=fctpatologiskprocedure;
%LET CARprim=tumor_aarlig;

/* defined data types except hospital discharge data  in %get()*/
%LET xtragettypes = LMDB PATO LAB VAR;

/* Default key variables to link tables in %get()*/
%LET DIAGstdgetkeyvar = kontakt_id;
%LET UBEstdgetkeyvar = kontakt_id;
%LET OPRstdgetkeyvar = kontakt_id;
%LET PATOstdgetkeyvar = dw_ek_rekvisition;

/* Default selected variables extraced in %get()*/
%LET DIAGstdgetvar = pnr start slut prioritet diag diagtype kontakt_id forloeb_id;
%LET UBEstdgetvar = pnr start start_proc proc proctype kontakt_id;
%LET OPRstdgetvar = pnr start start_proc proc proctype kontakt_id;
%LET LMDBstdgetvar = pnr eksd atc;
%LET LABstdgetvar =;
%LET PATOstdgetvar =pnr dw_ek_rekvisition dato_rekvirering diagnose_snomed_kode diagnose_snomed_sekvensnummer instans_undersogende materialenummer anden_specialprocedure hasteprocedure materiale_antal materialetype specielle_analyser;
%LET CARstdgetvar =;

 /* Default code variable used for row selection in %get() */
%LET DIAGstdgetcodevar = diag;
%LET UBEstdgetcodevar = proc;
%LET OPRstdgetcodevar = proc;
%LET LMDBstdgetcodevar = atc;
%LET LABstdgetcodevar = ;
%LET PATOstdgetcodevar = diagnose_snomed_kode;
%LET CARstdgetcodevar = diagnose;

 /* Default date variable used for row selection and ordering in %get() */
%LET DIAGstdgetdatevar = start;
%LET UBEstdgetdatevar = start_proc;
%LET OPRstdgetdatevar = start_proc;
%LET LMDBstdgetdatevar = eksd;
%LET LABstdgetdatevar = ;
%LET PATOstdgetdatevar = dato_rekvirering;
%LET CARstdgetdatevar = ;


libname master   "D:\data\Workdata\&ProjectNumber/data/SAS/Master"              access=readonly ;
libname charlib  "D:\data\Workdata\&ProjectNumber/data/SAS/Master"              access=readonly ;
libname risklib  "D:\data\Workdata\&ProjectNumber/data/SAS/RISKData2"           access=readonly ;
libname mcolib   "D:\data\Workdata\&ProjectNumber/data/SAS/RISKData2"           access=readonly ;

*----------------------------------------------------*
* Allokering af SAS-formater i Danmarks Statistik.   *
* Hostede forskermaskiner.                           *
*----------------------------------------------------;
/* old solution - not  hosted server
libname fmt '\\srvfsenas1\data\formater\SAS formater i Danmarks Statistik\FORMATKATALOG' access=readonly;
options fmtsearch=(fmt.times_personstatistik fmt.brancher
    fmt.uddannelser fmt.geokoder);
*/
libname fmt '\\srvfsenas3\formater\SAS formater i Danmarks Statistik\FORMATKATALOG' access=readonly;
options fmtsearch=(fmt.times_personstatistik fmt.times_erhvervsstatistik fmt.times_bbr
                   fmt.statistikbank fmt.brancher fmt.uddannelser fmt.disced fmt.disco fmt.sundhed fmt.geokoder);

options compress=YES;
options mprint merror spool;

%let sqlmax = max;


/* here follows the inclusion of all published macros */
%include "&localmacropath/macros/getgeneric.sas";
%include "&localmacropath/macros/mergegeneric.sas";
%include "&localmacropath/macros/mergepop.sas";
%include "&localmacropath/macros/subsetdata.sas";

%include "&localmacropath/macros/excldiag.sas";
%include "&localmacropath/macros/RiskSetMatch.sas";
%include "&localmacropath/macros/qualdiag.sas";
%include "&localmacropath/macros/macroutilities.sas";
%include "&localmacropath/macros/multicoscore.sas";
%include "&localmacropath/macros/smoothhosp.sas";
%include "&localmacropath/macros/checklog.sas";
%include "&localmacropath/macros/datacheck.sas";

%include "&localmacropath/icd_atc_codes/LMDBkoder.sas";
%include "&localmacropath/icd_atc_codes/DIAGkoder.sas";
%include "&localmacropath/icd_atc_codes/OPRkoder.sas";
%include "&localmacropath/icd_atc_codes/UBEkoder.sas";
%include "&localmacropath/icd_atc_codes/Riskscores.sas";

%include "&localmacropath/formats/format.sas";

options source2; /*ensures that log from %include is also added to the logfile*/;
options dlcreatedir; /* create directory if not existing when using libname option */
