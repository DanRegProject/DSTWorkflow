/*  name=datasourcedef.ado
    Stata ado: datasourceDef

    Purpose
    -------
    Replicates the behavior of the SAS %datasourceDef(...) macro in Stata.
    Use this in your Stata profile.do (analogous to common.sas) to declare
    the data-source metadata that the get_sas19 procedure will later use.

    What it does
    ------------
    Given arguments similar to the SAS macro, datasourceDef records a set of
    globals describing a datasource "head" (e.g., DIAG, OPR, LMDB). The same
    naming conventions as in the SAS macros are used so you can keep the same
    identifiers when scripting and when producing a mapping CSV for get_sas19.

    Globals created (for head=DIAG, as an example)
      - DIAGprim             (value of keytbl, or datatbl if keytbl empty)
      - DIAGsource           (the source list string given)
      - DIAGDIAG             (set to datatbl if keytbl and datatbl both provided)
      - DIAGDIAG2            (set to datatbl2 if provided)
      - DIAGstdgetvar        (select=... list)
      - DIAGstdgetkeyvar     (key=... value)
      - DIAGstdgetcodevar    (code=... value)
      - DIAGstdgetdatevar    (date=... value)
      - xtragettypes         (global list appended with HEAD)

    Usage
    -----
    Example (in profile.do or interactive):
      datasourceDef , head(DIAG) ///
                     source("LPR PRIV PSYK LPR3") ///
                     keytbl( ) datatbl( ) datatbl2( ) ///
                     key(kontakt_id) code(diag) date(start) ///
                     select("pnr start slut prioritet diag diagtype kontakt_id forloeb_id")

    Notes
    -----
    - Heads are uppercased internally so 'diag' and 'DIAG' are equivalent.
    - The syntax requires named options as shown above.
    - After calling this for each head, get_sas19 can use these globals (or
      a SAS-generated mapping CSV produced from these globals) to find files
      and variable names.
*/

program define datasourceDef, rclass
    version 19.0

    // Accept named options similar to the SAS macro signature
    syntax , HEAD(string) SOURCE(string) ///
            [ KEYTBL(string) DATATBL(string) DATATBL2(string) ///
              KEY(string) CODE(string) DATE(string) SELECT(string) ]

    // normalize and uppercase the head
    local head = ustrupper("`head'")

    // prepare values (keep exactly what's supplied, allow blanks)
    local source = "`source'"
    local keytbl = "`keytbl'"
    local datatbl = "`datatbl'"
    local datatbl2 = "`datatbl2'"
    local key = "`key'"
    local code = "`code'"
    local date = "`date'"
    local select = "`select'"

    // decide prim: if keytbl is empty and datatbl provided, prim := datatbl
    local primval = "`keytbl'"
    if "`primval'" == "" & "`datatbl'" != "" {
        local primval = "`datatbl'"
    }

    // set globals following SAS naming conventions: HEADprim, HEADsource, HEADHEAD, HEADHEAD2, HEADstdget*
    // e.g., for head=DIAG create globals DIAGprim DIAGsource DIAGDIAG DIAGDIAG2 DIAGstdgetvar ...
    // prim
    capture global `head'prim
    global `head'prim "`primval'"

    // source
    capture global `head'source
    global `head'source "`source'"

    // if both keytbl and datatbl supplied (non-empty), set HEADHEAD to datatbl
    if "`keytbl'" != "" & "`datatbl'" != "" {
        capture global `head'`head'
        global `head'`head' "`datatbl'"
    }

    // if keytbl & datatbl & datatbl2 provided, set HEADHEAD2
    if "`keytbl'" != "" & "`datatbl'" != "" & "`datatbl2'" != "" {
        capture global `head'`head'2
        global `head'`head'2 "`datatbl2'"
    }

    // stdgetvar, stdgetkeyvar, stdgetcodevar, stdgetdatevar
    capture global `head'stdgetvar
    global `head'stdgetvar "`select'"

    capture global `head'stdgetkeyvar
    global `head'stdgetkeyvar "`key'"

    capture global `head'stdgetcodevar
    global `head'stdgetcodevar "`code'"

    capture global `head'stdgetdatevar
    global `head'stdgetdatevar "`date'"

    // update the global xtragettypes list by appending HEAD (keep order)
    local curxt : global xtragettypes
    if "`curxt'" == "" {
        global xtragettypes "`head'"
    }
    else {
        // avoid duplicates
        local found = 0
        foreach t of local curxt {
            if "`t'" == "`head'" local found = 1
        }
        if `found' == 0 {
            global xtragettypes "`curxt' `head'"
        }
    }

    // Informative display (concise)
    di as txt "datasourceDef: registered head `head'"
    di as txt "  `head'prim = \"`=`head'prim''\""
    di as txt "  `head'source = \"`=`head'source''\""
    if "`keytbl'" != "" & "`datatbl'" != "" {
        di as txt "  `head'`head' = \"`=`head'`head'''\""
    }
    if "`keytbl'" != "" & "`datatbl'" != "" & "`datatbl2'" != "" {
        di as txt "  `head'`head'2 = \"`=`head'`head'2'''\""
    }
    di as txt "  `head'stdgetvar = \"`=`head'stdgetvar''\""
    di as txt "  `head'stdgetkeyvar = \"`=`head'stdgetkeyvar''\""
    di as txt "  `head'stdgetcodevar = \"`=`head'stdgetcodevar''\""
    di as txt "  `head'stdgetdatevar = \"`=`head'stdgetdatevar''\""
    di as txt "  xtragettypes = \"`xtragettypes'\""

    // return success
    return local head "`head'"
end
