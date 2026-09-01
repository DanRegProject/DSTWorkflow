*! version 1.2.0
program define merge_events, rclass
    version 19.0
    /*
    merge_events: Stata translation of SAS %merge / %reduce for event tables.

    Required named options:
      basedata(string)   : path to .dta file with study rows OR "base" if already in memory
      inlib(string)      : directory containing event files (TYPE<set>ALL.dta or .sas7bdat)
      type(string)       : data type prefix, e.g. DIAG
      IndexDate(string)  : index date variable name in basedata
      datevar(string)    : event date variable name in event datasets
      sets(string)       : space/comma-separated set names (e.g., "alcorel copd")
      invar(string)       : space/comma-separated input var names in event datasets
      outvar(string)      : space/comma-separated output var names (same count as invar)

    Optional:
      subset(string)     : Stata expression to filter events before reducing (e.g., "prioritet <= 2")
      postfix(string)    : appended to intermediate names (not used in final var names)
      CompIndex(string)  : LT or LE (default LT) -- defines "after" relation
      inmem              : if present, indicates basedata is already loaded in memory
      outdata(string)    : path to save final merged basedata (if absent, result left in memory)

    Notes:
    - This program expects event files named TYPE<set>ALL.dta (preferred) or TYPE<set>ALL.sas7bdat under inlib.
    - Dates: IndexDate and event datevar are auto-detected and harmonized to day-based numeric
      (days since 1960) using heuristics for SAS dates/datetimes and Stata tc.
    - Output variable names are generated as sanitized names derived from type, set and requested outvar.
    */

    // Parse syntax
    syntax , BASEDATA(string) INLIB(string) TYPE(string) INDEXDATE(string) DATEVAR(string) ///
            SETS(string) INVAR(string) OUTVAR(string) ///
            [ SUBSET(string) POSTFIX(string) COMPINDEX(string LT) INMEM OUTDATA(string) ]

    // normalize inputs
    local basedata = "`basedata'"
    local inlib = subinstr("`inlib'","""","",.)
    local type = ustrupper("`type'")
    local IndexDate = "`indexdate'"
    local datevar = "`datevar'"
    local sets = "`sets'"
    local invar = "`invar'"
    local outvar = "`outvar'"
    local subset = "`subset'"
    local postfix = "`postfix'"
    local compindex = ustrupper("`compindex'")
    if "`compindex'" == "" local compindex = "LT"

    // validate minimal args
    if "`basedata'" == "" | "`inlib'" == "" | "`type'" == "" | "`IndexDate'" == "" | "`datevar'" == "" | "`sets'" == "" | "`invar'" == "" | "`outvar'" == "" {
        di as err "merge_events: missing required arguments; see help"
        exit 198
    }

    // tokenize sets/invar/outvar
    local sets : subinstr local sets "," " " , all
    local invar : subinstr local invar "," " " , all
    local outvar : subinstr local outvar "," " " , all
    local nsets = wordcount("`sets'")
    local ninvar = wordcount("`invar'")
    local noutvar = wordcount("`outvar'")
    if `ninvar' != `noutvar' {
        di as err "merge_events: INVAR and OUTVAR must have same number of names"
        exit 198
    }

    // load basedata
    local in_memory_flag = 0
    if "`inmem'" != "" {
        local in_memory_flag = 1
        di as txt "merge_events: using basedata already in memory"
    }
    else {
        capture confirm file "`basedata'"
        if _rc {
            di as err "merge_events: basedata file `basedata' not found"
            exit 198
        }
        quietly use "`basedata'", clear
    }

    // ensure pnr and IndexDate present
    capture confirm variable pnr
    if _rc {
        di as err "merge_events: variable pnr not found in basedata"
        exit 198
    }
    capture confirm variable `IndexDate'
    if _rc {
        di as err "merge_events: IndexDate variable `IndexDate' not found in basedata"
        exit 198
    }

    // create working copy of basedata
    quietly sort pnr `IndexDate'
    tempfile base_work
    quietly save "`base_work'"

    // ---------------------------------------------------------------------
    // Helper program: _safevar returns sanitized variable name in r(result)
    // ---------------------------------------------------------------------
    capture program drop _safevar
    program define _safevar, rclass
        args raw
        local s = ustrregexra("`raw'", "[^A-Za-z0-9]", "_")
        local s = ustrregexra("`s'", "_{2,}", "_")
        if substr("`s'",1,1) == "_" local s = substr("`s'",2,.)
        if substr("`s'",-1,1) == "_" local s = substr("`s'",1,strlen("`s'")-1)
        if strlen("`s'") > 32 local s = substr("`s'",1,20) + "_" + substr("`s'",-10,.)
        return local result "`s'"
    end

    // ---------------------------------------------------------------------
    // Harmonize IndexDate (in base_work) to a day-based variable index_day
    // ---------------------------------------------------------------------
    quietly use "`base_work'", clear

    // if IndexDate is numeric, inspect magnitude to detect SAS datetime, Stata tc, or days
    capture confirm numeric variable `IndexDate'
    if _rc == 0 {
        quietly summarize `IndexDate', meanonly
        local maxI = r(max)
        if `maxI' > 1e11 {
            di as txt "merge_events: IndexDate appears to be Stata datetime (tc, ms). Creating IndexDate_day."
            capture confirm variable `IndexDate'_orig_dt
            if _rc != 0 quietly gen double `IndexDate'_orig_dt = `IndexDate'
            quietly gen double IndexDate_day = floor(`IndexDate'_orig_dt/86400000)
            local index_for_comp = "IndexDate_day"
        }
        else if `maxI' > 1e6 {
            di as txt "merge_events: IndexDate appears to be SAS datetime (seconds). Creating IndexDate_day."
            capture confirm variable `IndexDate'_orig_dt
            if _rc != 0 quietly gen double `IndexDate'_orig_dt = `IndexDate'
            quietly gen double IndexDate_day = floor(`IndexDate'_orig_dt/86400)
            local index_for_comp = "IndexDate_day"
        }
        else {
            // assume day-based numeric date already
            local index_for_comp = "`IndexDate'"
        }
    }
    else {
        // string IndexDate: attempt ISO parse
        capture confirm string variable `IndexDate'
        if _rc == 0 {
            di as txt "merge_events: IndexDate is string; attempting ISO parse to IndexDate_day."
            capture confirm variable `IndexDate'_orig_dt
            if _rc != 0 quietly gen strL `IndexDate'_orig_dt = `IndexDate'
            quietly gen double IndexDate_day = .
            quietly replace IndexDate_day = date(trim(`IndexDate'_orig_dt), "YMD") if regexm(trim(`IndexDate'_orig_dt'), "^\d{4}-\d{2}-\d{2}$")
            quietly replace IndexDate_day = floor((clock(trim(`IndexDate'_orig_dt'), "YMDhms")/1000)/86400) if missing(IndexDate_day) & regexm(trim(`IndexDate'_orig_dt'), "^\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2}")
            local index_for_comp = "IndexDate_day"
        }
        else {
            // unknown type - fallback to original
            local index_for_comp = "`IndexDate'"
        }
    }

    // ensure index_for_comp exists
    capture confirm variable `index_for_comp'
    if _rc {
        di as err "merge_events: failed to create index date variable `index_for_comp'"
        exit 198
    }

    // Save base_work with index_day
    quietly save "`base_work'", replace

    // ---------------------------
    // Main loop over sets
    // ---------------------------
    local total_sets_processed = 0
    forval si = 1/`nsets' {
        local set = word("`sets'", `si')
        if "`set'" == "" continue
        di as txt "merge_events: processing set `set' ..."

        // expected filenames
        local basefname = "`type'`set'ALL"
        local dtafile = "`inlib'/`basefname'.dta"
        local sasfile = "`inlib'/`basefname'.sas7bdat"

        local havefile = 0
        capture confirm file "`dtafile'"
        if _rc == 0 local havefile = 1
        else {
            capture confirm file "`sasfile'"
            if _rc == 0 local havefile = 2
        }
        if `havefile' == 0 {
            di as warn "merge_events: event file not found for set `set' - skipping"
            continue
        }

        // import event file into temporary ev file
        tempfile ev ev_bf ev_bl ev_af reduced
        if `havefile' == 1 {
            quietly use "`dtafile'", clear
        }
        else {
            capture noisily import sas using "`sasfile'", case(lower) clear
            if _rc {
                di as err "merge_events: import sas failed for `sasfile' - skipping `set'"
                continue
            }
        }

        // ensure pnr exists
        capture confirm variable pnr
        if _rc {
            di as warn "merge_events: pnr missing in event file for `set' - skipping"
            continue
        }

        // ensure datevar exists or discover alternative
        local event_datevar = ""
        foreach v of varlist _all {
            // we won't iterate like this; instead check requested datevar presence
        }
        capture confirm variable `datevar'
        if _rc {
            // try common alternatives
            local found_date = 0
            foreach cand in start start_proc adm eksd dato date admission_date admdate adm_dt {
                capture confirm variable `cand'
                if _rc==0 {
                    local datevar = "`cand'"
                    local found_date = 1
                    di as txt "merge_events: using datevar=`datevar' (heuristic)"
                    break
                }
            }
            if `found_date' == 0 {
                di as warn "merge_events: datevar `datevar' not found in event file - skipping set `set'"
                continue
            }
        }

        // apply subset filter if provided (assume Stata syntax)
        if "`subset'" != "" {
            capture noisily keep if `subset'
            if _rc {
                di as warn "merge_events: subset expression failed on events for `set' - ignoring subset"
                // reload full dataset
                if `havefile' == 1 {
                    quietly use "`dtafile'", clear
                }
                else {
                    capture noisily import sas using "`sasfile'", case(lower) clear
                    if _rc {
                        di as err "merge_events: re-import failed for `sasfile' - skipping `set'"
                        continue
                    }
                }
            }
        }

        // Harmonize event date variable to event_day in the event dataset
        capture confirm numeric variable `datevar'
        if _rc == 0 {
            quietly summarize `datevar', meanonly
            local maxD = r(max)
            if `maxD' > 1e11 {
                di as txt "merge_events: detected Stata tc (ms) in event date `datevar' -> creating `datevar'_day"
                capture confirm variable `datevar'_orig_dt
                if _rc != 0 quietly gen double `datevar'_orig_dt = `datevar'
                quietly gen double `datevar'_day = floor(`datevar'_orig_dt/86400000)
                local event_for_comp = "`datevar'_day"
            }
            else if `maxD' > 1e6 {
                di as txt "merge_events: detected SAS datetime (sec) in event date `datevar' -> creating `datevar'_day"
                capture confirm variable `datevar'_orig_dt
                if _rc != 0 quietly gen double `datevar'_orig_dt = `datevar'
                quietly gen double `datevar'_day = floor(`datevar'_orig_dt/86400)
                local event_for_comp = "`datevar'_day"
            }
            else {
                local event_for_comp = "`datevar'"
            }
        }
        else {
            // string: try parse ISO formats
            capture confirm string variable `datevar'
            if _rc == 0 {
                di as txt "merge_events: parsing string event date `datevar' to `datevar'_day"
                capture confirm variable `datevar'_orig_dt
                if _rc != 0 quietly gen strL `datevar'_orig_dt = `datevar'
                quietly gen double `datevar'_day = .
                quietly replace `datevar'_day = date(trim(`datevar'_orig_dt), "YMD") if regexm(trim(`datevar'_orig_dt'), "^\d{4}-\d{2}-\d{2}$")
                quietly replace `datevar'_day = floor((clock(trim(`datevar'_orig_dt'), "YMDhms")/1000)/86400) if missing(`datevar'_day) & regexm(trim(`datevar'_orig_dt'), "^\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2}")
                local event_for_comp = "`datevar'_day"
            }
            else {
                di as warn "merge_events: cannot interpret event date `datevar' in set `set' - skipping"
                continue
            }
        }

        // save event temporary
        quietly tempfile evtmp
        quietly save "`evtmp'", replace

        // join events to base_work
        quietly use "`base_work'", clear
        capture noisily joinby pnr using "`evtmp'"
        if _rc {
            di as err "merge_events: joinby pnr failed for set `set' (rc=`_rc') - skipping"
            quietly use "`base_work'", clear
            continue
        }

        // keep only necessary vars: pnr, index_for_comp, event_for_comp, invars
        // index_for_comp is a local name string; ensure it exists in memory (it was created in base_work)
        capture confirm variable `index_for_comp'
        if _rc {
            di as err "merge_events: index date variable `index_for_comp' not found after join - abort"
            exit 198
        }

        // build keep list
        local keepvars "pnr `index_for_comp' `event_for_comp'"
        forval i=1/`ninvar' {
            local vin = word("`invar'", `i')
            capture confirm variable `vin'
            if _rc {
                // if missing in joined data, create a missing var to keep structure
                quietly gen byte `vin' = .
            }
            local keepvars "`keepvars' `vin'"
        }
        quietly keep `keepvars'

        // create __after flag using harmonized names
        if "`compindex'" == "LT" {
            quietly gen byte __after = (`index_for_comp' < `event_for_comp')
        }
        else {
            quietly gen byte __after = (`index_for_comp' <= `event_for_comp')
        }

        // compute per-group tmp variables for min/max
        quietly gen double __tmp_before = `event_for_comp' if __after==0
        quietly gen double __tmp_after  = `event_for_comp' if __after==1

        bysort pnr `index_for_comp': egen __min_before = min(__tmp_before)
        bysort pnr `index_for_comp': egen __max_before = max(__tmp_before)
        bysort pnr `index_for_comp': egen __min_after  = min(__tmp_after)

        // FIRST BEFORE: keep observations where event_for_comp == __min_before (and not missing)
        quietly keep if !missing(__min_before) & `event_for_comp' == __min_before
        // ensure one row per group: keep first when duplicates
        by pnr `index_for_comp' ( `event_for_comp' ) : gen byte __seq = _n
        quietly keep if __seq == 1

        // rename invars to BF names and keep pnr/index
        local bf_vars ""
        forval i=1/`ninvar' {
            local vin = word("`invar'", `i')
            local vout = word("`outvar'", `i')
            // propose new name
            quietly _safevar "`type'`set'_FI_`vout'_Be_`IndexDate'"
            local newname = r(result)
            // ensure uniqueness
            capture confirm variable `newname'
            if !_rc {
                local j = 1
                while 1 {
                    local try = "`newname'_`j'"
                    capture confirm variable `try'
                    if _rc break
                    local ++j
                }
                local newname = "`try'"
            }
            capture noisily rename `vin' `newname'
            local bf_vars "`bf_vars' `newname'"
        }
        quietly keep pnr `index_for_comp' `bf_vars'
        quietly save "`ev_bf'", replace

        // RELOAD joined data for last-before
        quietly use "`evtmp'", clear
        // join again to base_work for grouping
        quietly use "`base_work'", clear
        quietly joinby pnr using "`evtmp'"
        quietly keep pnr `index_for_comp' `event_for_comp' `invar'
        // compute __tmp_before again (in case)
        quietly gen double __tmp_before2 = `event_for_comp' if `event_for_comp' < .
        // keep only rows equal to group's __max_before
        bysort pnr `index_for_comp': egen __maxb = max(cond(!missing(`event_for_comp') & `event_for_comp' < ., `event_for_comp', .))
        quietly keep if !missing(__maxb) & `event_for_comp' == __maxb
        by pnr `index_for_comp' : gen byte __seq2 = _n
        quietly keep if __seq2 == 1

        // rename invars to BL names
        local bl_vars ""
        forval i=1/`ninvar' {
            local vin = word("`invar'", `i')
            local vout = word("`outvar'", `i')
            quietly _safevar "`type'`set'_LA_`vout'_Be_`IndexDate'"
            local newname = r(result)
            capture confirm variable `newname'
            if !_rc {
                local j = 1
                while 1 {
                    local try = "`newname'_`j'"
                    capture confirm variable `try'
                    if _rc break
                    local ++j
                }
                local newname = "`try'"
            }
            capture noisily rename `vin' `newname'
            local bl_vars "`bl_vars' `newname'"
        }
        quietly keep pnr `index_for_comp' `bl_vars'
        quietly save "`ev_bl'", replace

        // AFTER-FIRST
        quietly use "`evtmp'", clear
        quietly use "`base_work'", clear
        quietly joinby pnr using "`evtmp'"
        quietly keep pnr `index_for_comp' `event_for_comp' `invar'
        quietly keep if !missing(__min_after) | 1==1 // ensure variable exists - we'll compute below
        // compute group's min_after and keep rows equal to it
        bysort pnr `index_for_comp': egen __mina = min(cond(!missing(`event_for_comp') & (`event_for_comp' >= .), `event_for_comp', .))
        quietly keep if !missing(__mina) & `event_for_comp' == __mina
        by pnr `index_for_comp' : gen byte __seq3 = _n
        quietly keep if __seq3 == 1

        // rename invars to AF names
        local af_vars ""
        forval i=1/`ninvar' {
            local vin = word("`invar'", `i')
            local vout = word("`outvar'", `i')
            quietly _safevar "`type'`set'_AF_`vout'_Af_`IndexDate'"
            local newname = r(result)
            capture confirm variable `newname'
            if !_rc {
                local j = 1
                while 1 {
                    local try = "`newname'_`j'"
                    capture confirm variable `try'
                    if _rc break
                    local ++j
                }
                local newname = "`try'"
            }
            capture noisily rename `vin' `newname'
            local af_vars "`af_vars' `newname'"
        }
        quietly keep pnr `index_for_comp' `af_vars'
        quietly save "`ev_af'", replace

        // Combine reduced parts bf/bl/af into single reduced dataset by pnr/index
        quietly use "`ev_bf'", clear
        capture noisily merge 1:1 pnr `index_for_comp' using "`ev_bl'"
        quietly drop _merge
        capture noisily merge 1:1 pnr `index_for_comp' using "`ev_af'"
        quietly drop _merge
        quietly save "`reduced'", replace

        // Merge reduced into base_work
        quietly use "`base_work'", clear
        capture noisily merge 1:1 pnr `index_for_comp' using "`reduced'"
        if _rc {
            di as err "merge_events: merging reduced set `set' into base failed (rc=`_rc')"
        }
        // drop merge indicator(s) and keep base rows
        capture drop _merge
        quietly save "`base_work'", replace

        local total_sets_processed = `total_sets_processed' + 1

        // reload base_work for next iteration
        quietly use "`base_work'", clear
    } // end for sets

    // final save or leave in memory
    if "`outdata'" != "" {
        quietly save "`outdata'", replace
        di as txt "merge_events: result saved to `outdata' (sets processed = `total_sets_processed')"
    }
    else {
        di as txt "merge_events: result left in memory (sets processed = `total_sets_processed')"
    }

    return scalar sets_processed = `total_sets_processed'
end
