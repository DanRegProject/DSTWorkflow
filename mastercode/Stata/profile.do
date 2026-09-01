set more off, perm
sysdir set PERSONAL "..\..\macros\Stata"
adopath ++ PERSONAL


/* select program versions  */
global EMACS_VERSION = "GNU Emacs 25.1"
global R_VERSION     = "R-3.3.3"

global EMACSDOWE "C:\Program Files (x86)\\$EMACS_VERSION\bin\emacs.exe"
global RPROGRAM "C:\Program Files\R\\$R_VERSION\bin\x64\R.exe"
global Rcmd "C:\Program Files\R\\$R_VERSION\bin\x64\Rscript.exe"

gl beginhide dis "#+BEGIN_COMMENT"
gl endhide dis "#+END_COMMENT"

/* xxxprim is main table of xxx information, with supplementary information (type) in xxxtype  */
gl LPRprim=ADM
gl LPRdiag=DIAG
gl LPRopr=SKS_OPR /* ie LPR source of OPR type data is found in physical files SKS_OPR */
gl LPRube=SKS_UBE

gl PRIVprim=ADM
gl PRIVdiag=DIAG
gl PRIVopr=SKS_OPR /* ie PRIV source of OPR type data is found in physical files SKS_OPR */
gl PRIVube=SKS_UBE

gl PSYKprim=ADM
gl PSYKdiag=DIAG

gl LPR3grp=LPR_A      /* or LPR_F */
gl LPR3prim=KONTAKT  /* KONTAKTER under LPR_F */
gl LPR3diag=DIAGNOSE  /* DIAGNOSER under LPR_F */
gl LPR3opr=procedurekonopr /*procedurer_kirurgi under LPR_F */
gl LPR3ube=procedurekonube /*procedurer_andre under LPR_F */

/* defined data types except hospital discharge data  in %get()*/
gl xtragettypes = 


* define LPR-based tables used by DIAG/OPR/UBE, examples:

datasourceDef , head(DIAG) source("LPR PRIV PSYK LPR3") keytbl( ) datatbl( ) ///
              key(kontakt_id) code(diag) date(start) ///
              select("pnr start slut prioritet diag diagtype kontakt_id forloeb_id")

datasourceDef , head(UBE) source("LPR PRIV LPR3") keytbl( ) datatbl( ) ///
              key(kontakt_id) code(diag) date(start) ///
              select("pnr start slut procstart proc proctype kontakt_id forloeb_id")


datasourceDef , head(lmdb) source() keytbl(lmdb) datatbl( ) ///
              key() code(atc) date(eksd) ///
              select("pnr eksd atc")
