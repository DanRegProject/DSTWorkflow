
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

/* defined data types except hospital discharge data  in %get()*/
%LET xtragettypes = ;
/* For datasources DIAG, OPR, UBE data are distributed on several tables                   */
/* hence table information is not given fully in datasourceDef, but specifically as above. */
%datasourceDef(
/* data source header (type in %indicatorDef, %get, %merge) */                                          
   head=DIAG,
/* Name (Prefix) of source tables with pnr */                      
   keytbl=,
/* Name (Prefix) of source tables with data if not in keytbl, optional */ 
   datatbl=,
/* Name (Prefix) of source tables with supplemental data, optional */ 
   datatbl2=,
/* Internal key variable linking keytbl and datatbl/datatbl2, optional */    
   key=kontakt_id,
/* Code variable optionally used to restrict on codes, optional */ 
   code=diag,
/* Date variable optionally used to restrict on period, optional */ 
   date=start,
/* Minimum standard variables to extract, optional */
/* further may be added in %get                    */
   select=pnr start slut prioritet diag diagtype kontakt_id forloeb_id
);
%datasourceDef(
/* data source header (type in %indicatorDef, %get, %merge)*/                                          
   head=OPR,
/* Name (Prefix) of source tables with pnr */                      
   keytbl=,
/* Name (Prefix) of source tables with data if not in keytbl, optional */ 
   datatbl=,
/* Name (Prefix) of source tables with supplemental data, optional */ 
   datatbl2=,
/* Internal key variable linking keytbl and datatbl/datatbl2, optional */    
   key=kontakt_id,
/* Code variable optionally used to restrict on codes, optional */ 
   code=proc,
/* Date variable optionally used to restrict on period, optional */ 
   date=start_proc,
/* Minimum standard variables to extract, optional */
/* further may be added in %get                    */
   select=pnr start start_proc proc proctype kontakt_id
);
%datasourceDef(
/* data source header (type in %indicatorDef, %get, %merge)*/                                          
   head=UBE,
/* Name (Prefix) of source tables with pnr */                      
   keytbl=,
/* Name (Prefix) of source tables with data if not in keytbl, optional */ 
   datatbl=,
/* Name (Prefix) of source tables with supplemental data, optional */ 
   datatbl2=,
/* Internal key variable linking keytbl and datatbl/datatbl2, optional */    
   key=kontakt_id,
/* Code variable optionally used to restrict on codes, optional */ 
   code=proc,
/* Date variable optionally used to restrict on period, optional */ 
   date=start_proc,
/* Minimum standard variables to extract, optional */
/* further may be added in %get                    */
   select=pnr start start_proc proc proctype kontakt_id
);
%datasourceDef(
/* data source header (type in %indicatorDef, %get, %merge)*/                                          
   head=LMDB,
/* Name (Prefix) of source tables with pnr */                      
   keytbl=LMDB,
/* Name (Prefix) of source tables with data if not in keytbl, optional */ 
   datatbl=,
/* Name (Prefix) of source tables with supplemental data, optional */ 
   datatbl2=,
/* Internal key variable linking keytbl and datatbl/datatbl2, optional */    
   key=,
/* Code variable optionally used to restrict on codes, optional */ 
   code=atc,
/* Date variable optionally used to restrict on period, optional */ 
   date=eksd,
/* Minimum standard variables to extract, optional */
/* further may be added in %get                    */
   select=pnr eksd atc
);
%datasourceDef(
/* data source header (type in %indicatorDef, %get, %merge)*/                                          
   head=LAB,
/* Name (Prefix) of source tables with pnr */                      
   keytbl=LAB_DM_FORSKER,
/* Name (Prefix) of source tables with data if not in keytbl, optional */ 
   datatbl=,
/* Name (Prefix) of source tables with supplemental data, optional */ 
   datatbl2=,
/* Internal key variable linking keytbl and datatbl/datatbl2, optional */    
   key=,
/* Code variable optionally used to restrict on codes, optional */ 
   code=,
/* Date variable optionally used to restrict on period, optional */ 
   date=,
/* Minimum standard variables to extract, optional */
/* further may be added in %get                    */
   select=
);
%datasourceDef(
/* data source header (type in %indicatorDef, %get, %merge)*/                                          
   head=PATO,
/* Name (Prefix) of source tables with pnr */                      
   keytbl=fctrekvisition,
/* Name (Prefix) of source tables with data if not in keytbl, optional */ 
   datatbl=dimpatologiskdiagnose,
/* Name (Prefix) of source tables with supplemental data, optional */ 
   datatbl2=fctpatologiskprocedure,
/* Internal key variable linking keytbl and datatbl/datatbl2, optional */    
   key=dw_ek_rekvisition,
/* Code variable optionally used to restrict on codes, optional */ 
   code=diagnose_snomed_kode,
/* Date variable optionally used to restrict on period, optional */ 
   date=dato_rekvirering,
/* Minimum standard variables to extract, optional */
/* further may be added in %get                    */
   select=pnr dw_ek_rekvisition dato_rekvirering diagnose_snomed_kode diagnose_snomed_sekvensnummer instans_undersogende materialenummer anden_specialprocedure hasteprocedure materiale_antal materialetype specielle_analyser
);
%datasourceDef(
/* data source header (type in %indicatorDef, %get, %merge)*/                                          
   head=CAR,
/* Name (Prefix) of source tables with pnr */                      
   keytbl=tumor_aarlig,
/* Name (Prefix) of source tables with data if not in keytbl, optional */ 
   datatbl=,
/* Name (Prefix) of source tables with supplemental data, optional */ 
   datatbl2=,
/* Internal key variable linking keytbl and datatbl/datatbl2, optional */    
   key=,
/* Code variable optionally used to restrict on codes, optional */ 
   code=diagnose,
/* Date variable optionally used to restrict on period, optional */ 
   date=,
/* Minimum standard variables to extract, optional */
/* further may be added in %get                    */
   select=
);

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
