%macro danaarstab(tab,var,primtab=,startyr=2018,in=master,dropview=TRUE,postfix=,where=);
%start_log(&logdir,2_3-DanAarstabeller&tab&postfix);
%start_timer(masterdata);

%local i j var dsn1 dsn2 dsn3 ds_names;

%LET tab=%UPCASE(&tab);
%LET primtab=%UPCASE(&primtab);

%IF %UPCASE(&test)=TRUE %THEN %LET in=WORK;
%let endyr=%sysfunc(date(),year4.);
%LET ds_names=;
proc sql noprint;
  select distinct memname into :dsn2 separated by ' '
  from dictionary.tables
  where libname=upcase("&in") and prxmatch("/^&tab.([^A-Za-z]|$)/",memname)>0 and upcase(memtype)=upcase("VIEW");

  %IF &primtab eq %THEN %DO; /* ie enten kontakt eller forløb primær tabellerne */
    %let varslut = %sysfunc(tranwrd(&var,start, slut));
    proc sql noprint inobs=&sqlmax;
    create table work.&dsn2 as 
      select * from &in..&dsn2;
      quit;
    %DO yr=&startyr %to &endyr;
      proc sql noprint inobs=&sqlmax;
      create table &in..&dsn2._&yr as
        select * 
        %IF %varexist(work.&dsn2,start)=0 %THEN , datepart(&var) as start;
        %IF %varexist(work.&dsn2,slut)=0 %THEN , datepart(&varslut) as slut; 
        from work.&dsn2
        where year(datepart(&var)) %IF &yr=&startyr %THEN between 1960 and &yr; %else = &yr;;
    %END;
    drop table work.&dsn2;
    %IF &dropview=TRUE %THEN drop view &in..&dsn2;;
  %END;
  %IF &tab ne &primtab and &primtab ne %THEN %DO;
    proc sql noprint;
      select distinct memname into :dsn1 separated by ' '
      from dictionary.tables
      where libname=upcase("&in") and prxmatch("/^&primtab.([^A-Za-z]|$)/",memname)>0 and upcase(memtype)=upcase("DATA");
      create table work.&dsn2 as 
        select * from &in..&dsn2;
	quit;
        %DO yr=&startyr %to &endyr;
          %let dsn1=%sysfunc(tranwrd(&dsn2,&tab,&primtab));
          %let dsn3=substr(&dsn2,1,%length(&dsn2)-%length(&postfix))&postfix;
          proc sql noprint inobs=&sqlmax;
          create table &in..&dsn3._&yr as
            select * 
            from work.&dsn2 as a
            where a.&var in (select &var from &in..&dsn1._&yr)
            %if &where ne %then and &where;
            ;
        %END;
        drop table work.&dsn2;
        %IF &dropview=TRUE %THEN drop view &id..&dsn2;;
  %END;
  quit;
  %END_TIMER(masterdata, text=Measure time for danaarstabeller);
  %end_log;
%MEND;

%let sqlmax=max;
%danaarstab(lpr_a_kontakt,starttid);
%danaarstab(lpr_a_diagnose,kontakt_id,primtab=lpr_a_kontakt);

%danaarstab(lpr_a_procregistrering,kontakt_id,primtab=lpr_a_kontakt,postfix=kontopr,where=(substr(proc,1,1) eq 'K' or substr(prockode_parent,1,1) eq 'K'));
%danaarstab(lpr_a_procregistrering,kontakt_id,primtab=lpr_a_kontakt,postfix=kontube,where=(substr(proc,1,1) ne 'K' and substr(prockode_parent,1,1) ne 'K'));
%danaarstab(lpr_a_resultater,      kontakt_id,primtab=lpr_a_kontakt,postfix=kont);

%danaarstab(lpr_a_forloeb,forl_starttidspunkt);
%danaarstab(lpr_a_procregistrering,forloeb_id,primtab=lpr_a_forloeb,postfix=forlopr,where=(substr(proc,1,1) eq 'K' or substr(prockode_parent,1,1) eq 'K'));
%danaarstab(lpr_a_procregistrering,forloeb_id,primtab=lpr_a_forloeb,postfix=forlube,where=(substr(proc,1,1) ne 'K' and substr(prockode_parent,1,1) ne 'K'));
%danaarstab(lpr_a_resultater,      forloeb_id,primtab=lpr_a_forloeb,postfix=forl);
%danaarstab(lpr_a_forloebsmarkoer, forloeb_id,primtab=lpr_a_forloeb);


