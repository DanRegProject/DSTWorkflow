%macro IndicatorDef(type, name, short_txt, code, icd8=, w=, wdays=, crit=, verbose=FALSE);
   %let type=%upcase(&type);
   %global &type.&name &type.L&name ;

   %let &type.&name        = &code;
   %let &type.L&name       = &short_txt;  /* "label" - description */
   %if &type = DIAG %then %do;
      %global &type.&name._ICD8;;
      %let &type.&name._ICD8   = &icd8;  /* list of ICD8 codes */
   %end;

   %if &w ne        %then %do;
      %global &type.&name.W;
      %let &type.&name.W=&w;
   %end;

   %if &wdays ne    %then %do;
      %global &type.&name.D;  %let &type.&name.D=&wdays;
   %end;

   %if "&crit" ne "" %then %do;
      %global &type.&name.C;  %let &type.&name.C=&crit;
   %end;

   %if &verbose=TRUE %then %do;
      /* print names */
      %put &type.&name        = &&&type.&name;
      %put &type.L&name       = &&&type.L&name;

      /* special case for LPR - also including ICD8 */
      %if &type eq DIAG %then %do;
         %put &type.&name._ICD8 = &&&type.&name._ICD8;
      %end;

      %if &w ne        %then %do;
         %put &type.&name.W = &&&type.&name.W;
      %end;

      %if &wdays ne    %then %do;
         %put &type.&name.D = &&&type.&name.D;
      %end;

      %if "&crit" ne "" %then %do;
         %put &type.&name.C = &&&type.&name.C;
      %end;
   %end;
%mend;

%macro datasourceDef(
/* data source header (type in %indicatorDef, %get, %merge) */                                          
   head=,
/* file source header, only if data are distributed along several files, as is the case for hospital discharge data */
   source=,
/* Name (Prefix) of source tables with pnr */                      
   keytbl=,
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
   %global &head.prim &head.&head &head.&head.2 &head.stdgetvar &head.stdgetcodevar &head.stdgetkeyvar &head.stdgetdatevar
   &head.source;
   %let &head.prim=&keytbl;
   %let &head.source=&source;
   %if &keytbl eq and &datatbl ne %then %let &head.prim=&datatbl;
   %if &keytbl ne and &datatbl ne %then %let &head.&head=&datatbl;
   %if &keytbl ne and &datatbl ne and &datatbl2 ne %then %let &head.&head.2=&datatbl2;
   %let &head.stdgetvar = &select; 
   %let &head.stdgetkeyvar = &key; 
   %let &head.stdgetcodevar = &code; 
   %let &head.stdgetdatevar = &date;

   %LET xtragettypes = &xtragettypes &head;
%mend;
