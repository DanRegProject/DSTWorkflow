%macro danaarstab(tab,var,primtab=,startyr=2018,lib=master,dropview=TRUE,postfix=,where=);
	%start_log(&logdir,2_3-DanAarstabeller&tab&postfix);
	%start_timer(masterdata);
	
	%local yr endyr tab2 ds_names;
	
	%LET tab=%UPCASE(&tab);
	%let tab2=&tab;
	%if %length(&tab2._xxxx&postfix)>32 %then %let tab2=%substr(&tab2,1,32-%length(_xxxx&postfix));
	%LET primtab=%UPCASE(&primtab);
	
	%IF %UPCASE(&test)=TRUE %THEN %LET lib=WORK;
	%let endyr=%sysfunc(date(),year4.);
	%LET ds_names=;
	
	%if not %sysfunc(exist(&lib..&tab)) and not %sysfunc(exist(&lib..&tab,"VIEW")) %then %put ERROR: the file &lib..&tab does not exist;
	%else %do;
	    proc sql noprint inobs=&sqlmax;
		%if &primtab eq %then %do;
			select upcase(informat), upcase(format) into :varinformat, :varformat
			from dictionary.columns
			where 	upcase(libname) = upcase("&lib") and
			 		upcase(memname) = upcase("&tab") and
			 		upcase(name) 	= upcase("&var");
		%end;
	    create table work.&tab as 
		    select * from &lib..&tab;
		    %DO yr=&startyr %to &endyr;
				%if &primtab ne and not %sysfunc(exist(&lib..&primtab._&yr)) %then %put ERROR: the file &lib..&primtab._&yr does not exist;
				%else %if &primtab eq and %index(&varinformat,DATE)=0 and %index(&varformat,DATE)=0 %then %put ERROR: the variable &var is not date or datetime;
				%else %do;
				  create table &lib..&tab2._&yr.&postfix as
			        select * 
			        from work.&tab a
					where 
					%IF &primtab eq %then %do;
						%if %index(&varinformat,DATETIME)>0 or %index(&varformat,DATETIME)>0 or 
						    %index(&varinformat,DT)>0 or %index(&varformat,DT)>0 %then year(datepart(a.&var));
						%else year(a.&var);	
						%IF &yr=&startyr %THEN between 1960 and &yr; %else = &yr;
			    	%END;
					%ELSE %do;
				        a.&var in (select distinct &var from &lib..&primtab._&yr)
					%END;
					%if &where ne %then and &where;
			    	;
				%end;
			%end;
	    	drop table work.&tab;
	    	%IF &dropview=TRUE and %sysfunc(exist(&lib..&tab,"VIEW")) %THEN drop view &lib..&tab;;
		quit;
	%END;
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

%danaarstab(lab_dm_forsker, samplingdate, startyr=2008);
%danaarstab(indberetningmedpris, adm, startyr=2018);

