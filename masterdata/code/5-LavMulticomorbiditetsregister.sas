/* Start del 4 */
%start_log(&logdir,5-LavMulticomorbiditetsregister);
%start_timer(masterdata); /* measure time for this macro */
/* create utility tables to MCOlib to be used for deriving multicomorbidity indexes  */
/* Definitioner af variable og index laves i mastercode/ICD_ATC_codes/Riskscores.sas */
/* macros to create datawarehouse to calculated riskscores in projects */

/* MAKRO def START */
%macro makemulticotable(score);
    %local I name;
	/* FIND DIAGNOSEDATA */
    %let I=1;
    %if %symexist(DIAG&score.&I) %then %do;
		%get(outlib=work, type=DIAG, sets=
        %do %while(%symexist(DIAG&score.&I));
            %let name = &score.&I;
	        &name
			%let I=%eval(&I+1);
	    %end;
		);
        %reduceLPRmulticotables(&score);
    %end;
    /* FIND RECEPTDATA*/
    %let I=1;
    %if %symexist(LMDB&score.&I) %then %do;
		%get(outlib=work, type=LMDB, sets=
		%do %while(%symexist(LMDB&score.&I));
	        %let name = &score.&I;
			&name 
	    	%let I=%eval(&I+1);
	    %end;
		);
        %reduceMEDImulticotables(&score);
    %end;

%mend;

%macro reduceLPRmulticotables(score);
    %local I sets name recn;
    %let I=1;

    %if %symexist(DIAG&score.&I) %then %do;
        %do %while(%symexist(DIAG&score.&I));
           %let name = DIAG&score.&I;
           %if &&DIAG&score.&I ne %then %do;

            proc sort data=work.DIAG&score.&I.all nodupkey out=work.&score.&I._red;
            *where &projectdate between rec_in and rec_out;
            by pnr start;
            %runquit;

            data work.&score.&I._red;
                length outcome $20. label $50.;
                set work.&score.&I._red;
                %if %symexist(DIAG&score.&I.C) %then where &&DIAG&score.&I.C;;
                wdays=.;
                %if %symexist(DIAG&score.&I.D) %then wdays = &&DIAG&score.&I.D;;

                weight = &&DIAG&score.&I.W;

                outcome="&name";
                label=&&DIAGL&score.&I;
                indate=start; format start date10.;
                %let recn=;
                %if %symexist(update) %then %do;
                    %if &update=TRUE %then %let recn=1;;
                    %end;
                rec_in&recn=today();
                rec_out&recn=&globalend;
                format rec_in&recn rec_out&recn date.;
               * rename hosp_in=indate hosp_out=outdate;
                %if %symexist(update) %then %do;
                    %if &update=TRUE %then id = catx(" ",of outcome hosp_in hosp_out weight);;
                    %end;
                keep pnr outcome label indate weight rec_in&recn rec_out&recn wdays %if %symexist(update) %then %do;

                    %if &update=TRUE %then id; %end;;
                    %runquit;

                    %if %symexist(update) %then %do;
                        %if &update=TRUE %then %do;
                data work.base&score.&I._red;
                    set mcolib.DIAG&score;
                    where outcome="&name";
                    id=catx(" ", of outcome indate weight);
                %runquit;

                proc sort data=work.base&score.&I._red;
                    by pnr %if &update=TRUE %then id; outcome indate ;
                %runquit;

                data work.&score.&I._red;
                    merge work.&score.&I._red(in=a) work.base&score.&I._red(in=b);
                    by pnr id;
                    if b and not a and rec_out>&projectdate then rec_out=&projectdate-1;
                    if a and not b then do; rec_out=rec_out1; rec_in=rec_in1; end;
                    drop rec_in1 rec_out1 id;
                %runquit;

                proc sort data=work.&score.&I._red;
                    by pnr outcome indate  rec_in rec_out;
                %runquit;
          %end;
%end;
          %let sets = &sets work.&score.&I._red;
          %end;
		  %let I=%eval(&I+1);
      %end;
    %end;

    data mcolib.DIAG&score;
        set &sets;
        by pnr outcome;
        if pnr ne "";
		format indate date10.;
    %runquit;

    proc sort data=mcolib.DIAG&score;
        by pnr outcome indate rec_in rec_out weight;
    %runquit;
	%let sets=%sysfunc(tranwrd(&sets,work.,));
	%cleanup;
%mend;


%macro reduceMEDImulticotables(score);
    %local I sets name recn;
    %let I=1;
    %if %symexist(LMDB&score.&I) %then %do;
       %do %while(%symexist(LMDB&score.&I));
           %let name = LMDB&score.&I;
           %if &&LMDB&score.&I ne %then %do;

            proc sort data=work.LMDB&score.&I.all nodupkey out=work.&score.&I._red;
      *      where &projectdate between rec_in and rec_out;
            by pnr eksd ;
            %runquit;

            data work.&score.&I._red;
                set work.&score.&I._red;
                wdays=.;
                %if %symexist(LMDB&score.&I.D) %then wdays = &&LMDB&score.&I.D;;
                weight = &&LMDB&score.&I.W;
                length outcome $20. label $50.;
                outcome="&name";
                label=&&LMDBL&score.&I;

                %let recn=;
                %if %symexist(update) %then %do;
				%if &update=TRUE %then %let recn=1;;
                %end;
				rec_in&recn=today();
                rec_out&recn=&globalend;
                format rec_in&recn rec_out&recn date.;
                %if %symexist(update) %then %do;
				%if &update=TRUE %then id = catx(" ",of outcome eksd weight);;
                %end;
				keep pnr outcome label eksd weight rec_in&recn rec_out&recn wdays
                %if %symexist(update) %then %do;
%if &update=TRUE %then id;
%end;;           %runquit;
%if %symexist(update) %then %do;

           %if &update=TRUE %then %do;
                data work.base&score.&I._red;
                    set mcolib.LMDB&score;
                    where outcome="&name";
                    id=catx(" ", of outcome eksd  weight);
                %runquit;

                proc sort data=work.base&score.&I._red;
                    by pnr %if &update=TRUE %then id; outcome eksd ;
                %runquit;

                data work.&score.&I._red;
                    merge work.&score.&I._red(in=a) work.base&score.&I._red(in=b);
                    by pnr id;
                    if b and not a and rec_out>&projectdate then rec_out=&projectdate-1;
                    if a and not b then to; rec_out=rec_out1; rec_in=rec_in1; end;
                    drop rec_in1 rec_out1 id;
                %runquit;

                proc sort data=work.&score.&I.red;
                    by pnr outcome eksd  rec_in rec_out;
                %runquit;
          %end;
%end;
          %let sets = &sets work.&score.&I._red;
          %end;
		  %let I=%eval(&I+1);
         %end;
    %end;

    data mcolib.LMDB&score;
        set &sets;
        by pnr outcome;
        if pnr ne "";
    %runquit;

    proc sort data=mcolib.LMDB&score;
        by pnr outcome eksd  rec_in rec_out weight;
    %runquit;
	%let sets=%sysfunc(tranwrd(&sets,work.,));
	%cleanup;
%mend;
%macro makemulticotables(score);
    %start_log(&logdir, &score, option=new);
    %start_timer(&score);

    %makemulticotable(&score);

    %end_timer(&score, text=execution time getting all &score tables from scratch);
    %end_log;
%mend;
/* MAKRO def SLUT */


%PUT &MCOlist;
%macro myloop;
%if %upcase(&MCOflag)=TRUE %then %do;
	%let c=1;
	%do %while(%scan(&mcolist,&c) ne );
	    %put %scan(&mcolist,&c);
	    %makemulticotables(%scan(&mcolist,&c));
		%let c=%eval(&c+1);
	%end;
%end;
%mend;
%myloop;
%end_timer(masterdata, text=Measure time for mcomaster);
%end_log;

