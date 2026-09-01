*! version 1.0.0
program define merge_generic, rclass
    version 19.0
    ///
    /// merge_generic: Stata translation of SAS %merge / %reduce
    ///
    /// Required named options:
    ///   basedata(string)   : path to Stata .dta file with study rows (pnr and IndexDate) OR dataset already in memory (use "base" to indicate in-memory)
    ///   inlib(string)      : directory containing event datasets (TYPE<set>ALL.dta) or a path to files
    ///   type(string)       : data type (e.g., DIAG)
    ///   IndexDate(string)  : name of the index-date variable in basedata
    ///   datevar(string)    : name of the date variable in the event datasets (if blank, will attempt to read HEADstdgetdatevar global)
    ///   sets(string)       : space- or comma-separated list of sets to process (e.g., "alcorel copd")
    ///   invar(string)      : space- or comma-separated list of input variables in event datasets to extract (one or more)
    ///   outvar(string)     : space- or comma-separated list of output variable names to store results for each invar (must have same count as invar)
    ///
    /// Optional:
    ///   subset(string)     : Stata expression to filter events before computing (e.g., "prioritet <= 2")
    ///   postfix(string)    : string appended to intermediate dataset names (not to variable names)
    ///   CompIndex(string)  : comparator for defining "after" (LT or LE). Default = LT (strictly after)
    ///   inmem              : indicates basedata is already loaded in memory (default is file path)
    ///   outdata(string)    : path to write resulting merged basedata (if omitted, result stays in memory)
    ///
    syntax , BASEDATA(string) INLIB(string) TYPE(string) INDEXDATE(string) DATEVAR(string) ///
            SETS(string) INVAR(string) OUTVAR(string) ///
            [ SUBSET(string) POSTFIX(string) COMPINDEX(string LT) INMEM OUTDATA(string) ]

    // Validate arguments
    local basedata = "`basedata'"
    local inlib = "`inlib'"
    local type = ustrupper("`type'")
    local IndexDate = "`indexdate'"
    local datevar = "`datevar'"
    local sets = subinstr("`sets'","/", " ", .)
    local invar = subinstr("`invar'","/", " ", .)
    local outvar = subinstr("`outvar'","/", " ", .)
    local subset = "`subset'"
    local postfix = "`postfix'"
    local compindex = ustrupper("`compindex'")
    if "`compindex'" == "" local compindex = "LT"

    if "`basedata'" == "" | "`inlib'" == "" | "`type'" == "" | "`IndexDate'" == "" | "`sets'" == "" | "`invar'" == "" {
        di as err "merge_generic: required arguments missing. See syntax."
        exit 198
    }

    // Tokenize sets and invar/outvar
    local sets : subinstr local sets "," " " , all
    local nin_sets : word count `sets'
    local ninvar : word count `invar'
    local noutvar : word count `outvar'
    if `noutvar' != `ninvar' {
        di as err "merge_generic: INVAR and OUTVAR must have the same number of names."
        exit 198
    }

    // Load basedata
    capture preserve
    local had_base_in_memory = 0
    if "`inmem'" != "" {
        // basedata is expected already loaded in memory; user passes basedata name 'base' to keep notation
        local had_base_in_memory = 1
        di as txt "merge_generic: using basedata already in memory"
    }
    else {
        // basedata is a path to .dta file
        capture confirm file "`basedata'"
        if _rc {
            di as err "merge_generic: basedata file `basedata' not found"
            exit 198
        }
        qui: use "`basedata'", clear
    }

    // Ensure pnr and IndexDate exist
    capture confirm variable pnr
    if _rc {
        di as err "merge_generic: variable pnr not found in basedata"
        exit 198
    }
    capture confirm variable `IndexDate'
    if _rc {
        di as err "merge_generic: IndexDate variable `IndexDate' not found in basedata"
        exit 198
    }

    // ensure basedata is unique by pnr + IndexDate
    qui: duplicates report pnr `IndexDate'
    // we won't abort on duplicates, but warn
    qui: count
    local baseN = r(N)
    di as txt "merge_generic: basedata loaded with `baseN' obs."

    // sort basedata
    qui: sort pnr `IndexDate'
    // save a temporary copy for appending variables later
    tempfile basedata_work
    qui: save "`basedata_work'"

    // We'll loop sets and for each set produce a reduced dataset with 1 obs per pnr+IndexDate containing output fields,
    // then merge that into basedata_work.

    // for convenience, turn subset into local expression for later evaluation on event data (assume Stata syntax)
    local subset_expr = "`subset'"

    // compute comparator: if COMPINDEX == LT then afterbase = (event_date > IndexDate)
    local after_condition = ""
    if "`compindex'" == "LT" {
        // event is after base if event_date > IndexDate
        local after_condition = "`datevar' > `IndexDate'"
    }
    else if "`compindex'" == "LE" {
        local after_condition = "`datevar' >= `IndexDate'"
    }
    else {
        di as err "merge_generic: unsupported CompIndex = `compindex' (use LT or LE)"
        exit 198
    }

    // Loop sets
    forvalues s = 1/`nin_sets' {
        local setname : word `s' of `sets'
        local setname = trim("`setname'")
        if "`setname'" == "" continue

        // construct expected event filename: inlib/TYPE<set>ALL.dta
        local dataset_basename = "`type'`setname'ALL"
        local dta_path = "`inlib'/`dataset_basename'.dta"
        local sas_path = "`inlib'/`dataset_basename'.sas7bdat"

        local have_event_file = 0
        if (strlen("`dta_path'")>0) {
            capture confirm file "`dta_path'"
            if !_rc local have_event_file = 1
        }
        if `have_event_file' == 0 {
            capture confirm file "`sas_path'"
            if !_rc local have_event_file = 2
        }
        if `have_event_file' == 0 {
            di as warn "merge_generic: event dataset not found: `dataset_basename' in `inlib' (skipping set `setname')"
            continue
        }

        di as txt "merge_generic: processing set `setname' (dataset: `dataset_basename')"

        // Prepare temporary files
        tempfile ev_dta ev_before_first ev_before_last ev_after_first reduced
        // If SAS file, import to temporary Stata dataset
        if `have_event_file' == 2 {
            capture noisily import sas using "`sas_path'", case(lower) clear
            if _rc {
                di as err "merge_generic: import sas failed for `sas_path' - skipping set `setname'"
                continue
            }
            qui: save "`ev_dta'", replace
        }
        else {
            // use data file directly
            qui: use "`dta_path'", clear
            // save as temp in case we need to re-open
            qui: save "`ev_dta'", replace
        }

        // At this point ev_dta contains event data. Ensure pnr and datevar exist
        qui: use "`ev_dta'", clear
        capture confirm variable pnr
        if _rc {
            di as warn "merge_generic: pnr not found in event dataset `dataset_basename' - skipping"
            continue
        }
        capture confirm variable `datevar'
        if _rc {
            // try common names if datevar blank; attempt heuristics similar to previous ado
            local alt_found = ""
            foreach cand of local avail = "start start_proc adm eksd dato date admission_date" {
                capture confirm variable `cand'
                if _rc==0 {
                    local datevar = "`cand'"
                    local alt_found = 1
                    di as txt "merge_generic: using datevar=`datevar' (heuristic)"
                    break
                }
            }
            if "`alt_found'" == "" {
                di as warn "merge_generic: datevar `datevar' not found in event dataset - skipping"
                continue
            }
        }

        // restrict event dataset by subset expression if provided (assumed Stata syntax)
        if "`subset_expr'" != "" {
            capture noisily keep if `subset_expr'
            if _rc {
                di as warn "merge_generic: subset expression caused error; skipping subset for this set"
                qui: use "`ev_dta'", clear
            }
        }

        // save filtered events to temp file
        qui: save "`ev_dta'", replace

        // Now join events to basedata_work via joinby pnr
        // Load the basedata_work into memory
        qui: use "`basedata_work'", clear
        // perform joinby
        // joinby will create one observation per basedata obs x matching events (if event dataset has multiple events for the pnr, you get multiple rows)
        capture noisily joinby pnr using "`ev_dta'"
        if _rc {
            di as err "merge_generic: joinby failed for set `setname' (rc=`_rc') - skipping"
            // reload basedata_work and continue
            qui: use "`basedata_work'", clear
            continue
        }

        // after joinby, our data contain basedata variables (pnr, IndexDate etc) and event variables including datevar and invars
        // Keep only relevant variables to reduce memory: pnr, IndexDate, datevar, invars
        local keepvars "pnr `IndexDate' `datevar'"
        local invarTok = "`invar'"
        local i = 1
        while "`: word `i' of `invarTok''" != "" {
            local v = "`: word `i' of `invarTok''"
            local keepvars "`keepvars' `v'"
            local ++i
        }
        qui: keep `keepvars'

        // create afterbase indicator: 0 = before (including equal depending on compindex), 1 = after
        if "`compindex'" == "LT" {
            qui: gen byte __after = (`datevar' > `IndexDate')
        }
        else {
            qui: gen byte __after = (`datevar' >= `IndexDate')
        }

        // sort by pnr IndexDate datevar (ascending)
        qui: sort pnr `IndexDate' `datevar'

        // create before-first dataset (first obs in group with __after==0)
        qui: gen long __seq = _n
        // identify within-group sequence
        by pnr `IndexDate' : gen long __within = _n
        by pnr `IndexDate' : gen long __N = _N

        // FIRST BEFORE: keep observations where __after==0 and __within==1 (BUT careful: __within==1 is first observation overall; we must find first among those with __after==0)
        // Alternative robust method: for each group, keep first observation with __after==0: create marker
        qui: by pnr `IndexDate' : gen byte __first_before = 0
        qui: by pnr `IndexDate' : replace __first_before = 1 if __after==0 & (_n == sum(__after==0) - sum(__after==0) + 1) // not straightforward

        // Simpler robust approach: create dataset of before events and pick first/last with by-group operations

        // BEFORE events dataset
        qui: keep if __after==0
        qui: sort pnr `IndexDate' `datevar'
        // if no before events for any groups, create empty file
        capture count
        if r(N) > 0 {
            // first-before
            by pnr `IndexDate' : gen long __seqb = _n
            by pnr `IndexDate' : gen long __Nb = _N
            // first-before: __seqb==1
            qui: keep if __seqb==1
            // rename invars into outcome-specific names: outcome_FI_<outvar>_BF (shorter)
            // build mapping from invar -> outvar
            local i = 1
            while "`: word `i' of `invar''" != "" {
                local vin = "`: word `i' of `invar''"
                local vout = "`: word `i' of `outvar''"
                // safe variable name
                local newname = "`setname'_FI_`vout'_Be_`IndexDate'"
                // shorten newname if > 32 chars: use hashing pattern (take prefix + suffix)
                if strlen("`newname'") > 32 {
                    // shorten to setname_vout_BF
                    local newname = "`setname'_`vout'_BF"
                }
                capture confirm variable `newname'
                if !_rc {
                    // if name already exists, append an index suffix
                    local j = 1
                    while 1 {
                        local try = "`newname'_`j'"
                        capture confirm variable `try'
                        if _rc break
                        local ++j
                    }
                    local newname = "`try'"
                }
                // rename vin -> newname (but only keep newname and pnr & IndexDate)
                quietly rename `vin' `newname'
                // also keep track of names for later merging
                local bf_vars "`bf_vars' `newname'"
                local ++i
            }
            // keep minimal vars
            keep pnr `IndexDate' `bf_vars'
            qui: save "`ev_before_first'", replace
        }
        else {
            // create empty file with pnr IndexDate (from basedata) to preserve structure (no before events)
            qui: use "`basedata_work'", clear
            keep pnr `IndexDate'
            // create placeholder vars for bf variables (empty)
            local i = 1
            while "`: word `i' of `invar''" != "" {
                local vout = "`: word `i' of `outvar''"
                local newname = "`setname'_FI_`vout'_Be_`IndexDate'"
                if strlen("`newname'") > 32 local newname = "`setname'_`vout'_BF"
                gen byte `newname' = .
                local bf_vars "`bf_vars' `newname'"
                local ++i
            }
            qui: save "`ev_before_first'", replace
        }

        // RELOAD events for before-last and after-first processing
        qui: use "`ev_dta'", clear
        // re-create joinby result: joinby pnr using basedata_work
        qui: use "`basedata_work'", clear
        qui: joinby pnr using "`ev_dta'"
        qui: keep pnr `IndexDate' `datevar' `invar'
        qui: gen byte __after = (`datevar' > `IndexDate') if "`compindex'"=="LT" ///
                       else (`datevar' >= `IndexDate')
        qui: sort pnr `IndexDate' `datevar'

        // BEFORE-LAST: events with __after==0, pick last per group
        qui: keep if __after==0
        capture count
        if r(N) > 0 {
            by pnr `IndexDate' : gen long __seq_b = _n
            by pnr `IndexDate' : gen long __Nb = _N
            keep if __seq_b == __Nb
            // rename invars to last-before names
            local i = 1
            while "`: word `i' of `invar''" != "" {
                local vin = "`: word `i' of `invar''"
                local vout = "`: word `i' of `outvar''"
                local newname = "`setname'_LA_`vout'_Be_`IndexDate'"
                if strlen("`newname'") > 32 local newname = "`setname'_`vout'_BL"
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
                quietly rename `vin' `newname'
                local bl_vars "`bl_vars' `newname'"
                local ++i
            }
            keep pnr `IndexDate' `bl_vars'
            qui: save "`ev_before_last'", replace
        }
        else {
            // create empty placeholder
            qui: use "`basedata_work'", clear
            keep pnr `IndexDate'
            local i = 1
            while "`: word `i' of `invar''" != "" {
                local vout = "`: word `i' of `outvar''"
                local newname = "`setname'_LA_`vout'_Be_`IndexDate'"
                if strlen("`newname'") > 32 local newname = "`setname'_`vout'_BL"
                gen byte `newname' = .
                local bl_vars "`bl_vars' `newname'"
                local ++i
            }
            qui: save "`ev_before_last'", replace
        }

        // AFTER-FIRST: events with __after==1, pick first per group
        qui: use "`ev_dta'", clear
        qui: use "`basedata_work'", clear
        qui: joinby pnr using "`ev_dta'"
        qui: keep pnr `IndexDate' `datevar' `invar'
        if "`compindex'" == "LT" {
            qui: gen byte __after = (`datevar' > `IndexDate')
        }
        else {
            qui: gen byte __after = (`datevar' >= `IndexDate')
        }
        qui: keep if __after==1
        capture count
        if r(N) > 0 {
            qui: sort pnr `IndexDate' `datevar'
            by pnr `IndexDate' : gen long __seq_a = _n
            keep if __seq_a==1
            local i = 1
            while "`: word `i' of `invar''" != "" {
                local vin = "`: word `i' of `invar''"
                local vout = "`: word `i' of `outvar''"
                local newname = "`setname'_AF_`vout'_Af_`IndexDate'"
                if strlen("`newname'") > 32 local newname = "`setname'_`vout'_AF"
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
                quietly rename `vin' `newname'
                local af_vars "`af_vars' `newname'"
                local ++i
            }
            keep pnr `IndexDate' `af_vars'
            qui: save "`ev_after_first'", replace
        }
        else {
            qui: use "`basedata_work'", clear
            keep pnr `IndexDate'
            local i = 1
            while "`: word `i' of `invar''" != "" {
                local vout = "`: word `i' of `outvar''"
                local newname = "`setname'_AF_`vout'_Af_`IndexDate'"
                if strlen("`newname'") > 32 local newname = "`setname'_`vout'_AF"
                gen byte `newname' = .
                local af_vars "`af_vars' `newname'"
                local ++i
            }
            qui: save "`ev_after_first'", replace
        }

        // Merge the three reduced files together by pnr IndexDate
        qui: use "`ev_before_first'", clear
        capture noisily merge 1:1 pnr `IndexDate' using "`ev_before_last'"
        // drop merge indicators
        qui: drop _merge
        capture noisily merge 1:1 pnr `IndexDate' using "`ev_after_first'"
        qui: drop _merge
        // keep only one obs per pnr IndexDate with the extracted vars
        qui: keep pnr `IndexDate' `bf_vars' `bl_vars' `af_vars'
        qui: save "`reduced'", replace

        // Merge reduced into basedata_work (1:1 on pnr IndexDate). Load basedata_work and merge
        qui: use "`basedata_work'", clear
        capture noisily merge 1:1 pnr `IndexDate' using "`reduced'"
        if _rc {
            di as err "merge_generic: merge 1:1 failed for set `setname' (rc=`_rc')"
        }
        // Keep original basedata rows (match _merge==1 or 3), drop extra merge var
        qui: drop if _merge==2  // shouldn't happen, but ensure
        qui: drop _merge
        // save updated basedata_work
        qui: save "`basedata_work'", replace

        // Clear temporary locals for next loop
        macro drop bf_vars bl_vars af_vars ev_dta ev_before_first ev_before_last ev_after_first reduced
        // reload basedata_work in memory for next iteration
        qui: use "`basedata_work'", clear
    }

    // Final dataset now in memory (basedata_work). Optionally save to outdata
    if "`outdata'" != "" {
        qui: save "`outdata'", replace
        di as txt "merge_generic: result saved to `outdata'"
    }
    else {
        di as txt "merge_generic: result left in memory (you may save it)."
    }

    // restore original preserve state if user requested in-memory basedata
    if `had_base_in_memory' == 0 {
        // dataset in memory is the result; do not restore original
    }

    return local totalobs = _N
end
