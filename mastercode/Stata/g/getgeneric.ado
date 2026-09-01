*! version 1.1.0
program define get_sas19, rclass
    version 19.0

    // Primary interface
    // - masterdir: directory containing SAS files (master library)
    // - type: data type (DIAG, OPR, UBE, etc) - used to lookup HEAD globals
    // - sets: comma/space-separated indicator names or literal code prefixes
    // - outdata: output .dta path
    //
    // Optional:
    // - files: filename pattern or list (if omitted, the code will search masterdir using datasourceDef HEAD/source prefixes)
    // - codevar, datevar, keyvar: override variable names (otherwise read from HEADstdget*)
    // - getvar: additional vars to import (comma-separated)
    // - fromyear/fromdate/todate: date window (fromyear default 1997)
    // - case(lower|preserve|upper): passed to import sas (default lower)
    syntax , MASTERDIR(string) TYPE(string) SETS(string) OUTDATA(string) ///
            [ FILES(string) CODEVAR(string) DATEVAR(string) KEYVAR(string) ///
              GETVAR(string) FROMYEAR(integer 1997) FROMDATE(string) TODATE(string) CASE(string lower) ]

    // normalize inputs
    local masterdir = subinstr("`masterdir'","""","",.)
    local type = ustrupper("`type'")
    local setspec = "`sets'"
    local outdata = "`outdata'"
    local filesopt = "`files'"
    local codevar_opt = lower("`codevar'")
    local datevar_opt = lower("`datevar'")
    local keyvar_opt = lower("`keyvar'")
    local getvar_opt = "`getvar'"
    local caseopt = lower("`case'")
    if "`caseopt'"=="" local caseopt = "lower"

    // helper: safe-name normalization (same logic as indicatorDef.ado)
    // converts non-alnum -> underscore, collapse multiple underscores, strip leading/trailing underscores
    tempname _tmp
    capture program drop _safe_name
    program define _safe_name, rclass
        args raw
        local s = ustrregexra("`raw'", "[^A-Za-z0-9]", "_")
        local s = ustrregexra("`s'", "_{2,}", "_")
        if substr("`s'",1,1) == "_" local s = substr("`s'",2,.)
        if substr("`s'",-1,1) == "_" local s = substr("`s'",1,strlen("`s'")-1)
        if "`s'" == "" local s = "`raw'"
        return local result "`s'"
    end

    // ----- Resolve code prefixes from setspec: prefer indicatorDef globals -----
    local prefixes ""
    // split setspec into tokens
    local tmpsets = "`setspec'"
    local tmpsets : subinstr local tmpsets "," " " , all
    tokenize "`tmpsets'"
    while "`1'" != "" {
        local token = "`1'"
        // normalize token to safe form and lookup global: TYPE + safe(token)
        qui: _safe_name "`token'"
        local safe = r(result)
        local gname = "`type'`safe'"
        // try to read global
        local codestr : global `gname'
        if "`codestr'" != "" {
            // global found - codes are space or comma separated; normalize commas to spaces
            local codestr : subinstr local codestr "," " " , all
            // append codes to prefixes
            local codeslist = "`codestr'"
            // split and append unique
            tokenize "`codeslist'"
            while "`1'" != "" {
                local c = lower("`1'")
                // strip surrounding quotes if any
                if substr("`c'",1,1) == "\"" & substr("`c'",-1,1) == "\"" local c = substr("`c'",2,strlen("`c'")-2)
                // append if not already present
                if strpos(" `prefixes' "," `c' ") == 0 local prefixes "`prefixes' `c'"
                macro shift
            }
        }
        else {
            // no indicator global, treat token as literal list of prefixes (possibly comma/space separated)
            local t = "`token'"
            local t : subinstr local t "," " " , all
            tokenize "`t'"
            while "`1'" != "" {
                local c = lower("`1'")
                if strpos(" `prefixes' "," `c' ") == 0 local prefixes "`prefixes' `c'"
                macro shift
            }
        }
        macro shift
    }

    if "`prefixes'" == "" {
        di as err "get_sas19: no code prefixes resolved from sets=`setspec'"
        exit 198
    }

    // build regex altlist for code prefix matching (escape minimal special chars)
    local altlist ""
    foreach p of local prefixes {
        local pclean = ustrregexra("`p'", "[^A-Za-z0-9]", "")
        if "`pclean'" == "" continue
        if "`altlist'" == "" local altlist "`pclean'"
        else local altlist "`altlist'|`pclean'"
    }
    local code_pattern = "^(?:" + "`altlist'" + ")"

    // ----- Resolve list of SAS files to scan -----
    local filelist ""
    if "`filesopt'" != "" {
        // user provided explicit files or pattern
        if (strpos("`filesopt'","*") | strpos("`filesopt'","?")) {
            // pattern relative to masterdir
            local filelist : dir "`masterdir'" files "`filesopt'"
            if "`filelist'" == "" {
                di as err "get_sas19: no files found in `masterdir' matching `filesopt'"
                exit 198
            }
        }
        else if (strpos("`filesopt'",",") ) {
            local tmp = "`filesopt'"
            local tmp : subinstr local tmp "," " " , all
            tokenize "`tmp'"
            while "`1'" != "" {
                local f = "`1'"
                // make absolute if needed
                if substr("`f'",1,1) == "/" | substr("`f'",2,1) == ":" local filelist "`filelist' `f'"
                else local filelist "`filelist' `masterdir'/`f'"
                macro shift
            }
        }
        else {
            // single filename
            if substr("`filesopt'",1,1) == "/" | substr("`filesopt'",2,1) == ":" local filelist "`filesopt'"
            else local filelist "`masterdir'/`filesopt'"
        }
    }
    else {
        // No explicit files: search masterdir using HEADsource and stype+ftype globals (SAS-style)
        // Need HEADsource global (e.g., DIAGsource)
        local headsource : global `type'source
        if "`headsource'" == "" {
            di as err "get_sas19: HEADsource global not found for type=`type' (call datasourceDef in profile.do)"
            exit 198
        }
        // parse sources (space separated)
        local headsource : subinstr local headsource "," " " , all
        tokenize "`headsource'"
        while "`1'" != "" {
            local stype = "`1'"
            local stype_u = ustrupper("`stype'")
            // ftype: if TYPE==stype then prim else TYPE (mimic SAS logic)
            local ftype = "`type'"
            if ustrupper("`stype'") == "`type'" local ftype = "prim"
            // build global name for table prefix: stype + lower(ftype) (e.g., LPRprim, LPRdiag)
            local gtab = "`stype_u'" + lower("`ftype'")
            // attempt to read that global; try variations if not present
            local prefix : global `gtab'
            if "`prefix'" == "" {
                // try uppercase ftype
                local gtab2 = "`stype_u'" + ustrupper("`ftype'")
                local prefix : global `gtab2'
            }
            if "`prefix'" == "" {
                // fallback to stype itself as prefix
                local prefix = "`stype_u'"
            }
            // search files in masterdir where filename contains prefix (case-insensitive)
            // use dir expansion with pattern *prefix*.sas7bdat
            local pat = "*" + lower("`prefix'") + "*.sas7bdat"
            // dir does case-sensitive on filesystem; build pattern with wildcard only and then filter in loop
            local candidates : dir "`masterdir'" files "*.sas7bdat"
            foreach cand of local candidates {
                // case-insensitive check
                if strpos(lower("`cand'"), lower("`prefix'")) > 0 {
                    if strpos(" `filelist' "," `masterdir'/`cand' ") == 0 local filelist "`filelist' `masterdir'/`cand'"
                }
            }
            macro shift
        }
    }

    if "`filelist'" == "" {
        di as err "get_sas19: no SAS files found to process under `masterdir'"
        exit 198
    }

    // ----- Determine variable names to import (namelist) -----
    // Prefer user overrides; otherwise read HEADstdgetvar / HEADstdgetcodevar / HEADstdgetdatevar / HEADstdgetkeyvar
    local head_stdgetvar : global `type'stdgetvar
    local head_stdgetcodevar : global `type'stdgetcodevar
    local head_stdgetdatevar : global `type'stdgetdatevar
    local head_stdgetkeyvar : global `type'stdgetkeyvar

    // prefer explicit options, else HEAD defaults
    local want_codevar = cond("`codevar_opt'" != "", "`codevar_opt'", lower("`head_stdgetcodevar'"))
    local want_datevar = cond("`datevar_opt'" != "", "`datevar_opt'", lower("`head_stdgetdatevar'"))
    local want_keyvar = cond("`keyvar_opt'" != "", "`keyvar_opt'", lower("`head_stdgetkeyvar'"))

    // build list from head_stdgetvar plus user getvar
    local namelist_tokens ""
    if "`head_stdgetvar'" != "" {
        local hv = "`head_stdgetvar'"
        local hv : subinstr local hv "," " " , all
        tokenize "`hv'"
        while "`1'" != "" {
            local namelist_tokens "`namelist_tokens' `1'"
            macro shift
        }
    }
    if "`getvar_opt'" != "" {
        local gv = "`getvar_opt'"
        local gv : subinstr local gv "," " " , all
        tokenize "`gv'"
        while "`1'" != "" {
            // append if not already
            if strpos(" `namelist_tokens' "," `1' ") == 0 local namelist_tokens "`namelist_tokens' `1'"
            macro shift
        }
    }
    // ensure key/code/date variables are included
    if "`want_keyvar'" != "" & strpos(" `namelist_tokens' "," `want_keyvar' ") == 0 local namelist_tokens "`namelist_tokens' `want_keyvar'"
    if "`want_codevar'" != "" & strpos(" `namelist_tokens' "," `want_codevar' ") == 0 local namelist_tokens "`namelist_tokens' `want_codevar'"
    if "`want_datevar'" != "" & strpos(" `namelist_tokens' "," `want_datevar' ") == 0 local namelist_tokens "`namelist_tokens' `want_datevar'"

    // prepare date numeric bounds (Stata daily dates). SAS/Stata share origin (1960-01-01)
    local have_date_filter = 0
    local fnum = ""
    local tnum = ""
    if "`fromdate'" != "" {
        if regexm("`fromdate'","^[0-9]{4}-[0-9]{2}-[0-9]{2}$") local fnum = `=date("`fromdate'","YMD")'
        else if regexm("`fromdate'","^[0-9]{4}$") local fnum = `=mdy(1,1,`fromdate')'
        else {
            di as err "get_sas19: cannot parse fromdate=`fromdate' (use YYYY-MM-DD or YYYY)"
            exit 198
        }
        local have_date_filter = 1
    }
    else if `fromyear' != . {
        local fnum = `=mdy(1,1,`fromyear')'
        local have_date_filter = 1
    }

    if "`todate'" != "" {
        if regexm("`todate'","^[0-9]{4}-[0-9]{2}-[0-9]{2}$") local tnum = `=date("`todate'","YMD")'
        else if regexm("`todate'","^[0-9]{4}$") local tnum = `=mdy(12,31,`todate')'
        else {
            di as err "get_sas19: cannot parse todate=`todate' (use YYYY-MM-DD or YYYY)"
            exit 198
        }
        local have_date_filter = 1
    }

    // ----- Loop files and import filtered observations -----
    local first = 1
    local totalobs = 0

    foreach f of local filelist {
        local filepath = "`f'"
        di as txt "get_sas19: scanning `filepath' ..."

        // Try to import just the required variables and rows using import sas with an if-clause.
        // Build the code-regex clause using the (case-insensitive) lower(...) and regexm.
        // Note: we import with case(lower) so variable names can be referred in lower-case namelist.
        // Build the actual code variable name to use in expression: prefer want_codevar else try heuristics after header read.

        // Read first observation to learn available variable names
        capture noisily import sas using "`filepath'", case(`caseopt') clear in 1/1
        if _rc {
            di as err "get_sas19: initial import failed for `filepath' (rc=`_rc'); skipping file."
            continue
        }
        // list available variables
        ds, has(varlist)
        local avail : colnames

        // find actual codevar in available vars (case has been normalized by caseopt)
        local actual_codevar ""
        if "`want_codevar'" != "" {
            foreach v of local avail {
                if lower("`v'") == lower("`want_codevar'") {
                    local actual_codevar "`v'"
                    break
                }
            }
        }
        if "`actual_codevar'" == "" {
            // heuristics
            foreach cand in diag proc code procedure diagnose proc_code {
                foreach v of local avail {
                    if lower("`v'") == "`cand'" {
                        local actual_codevar "`v'"
                        exit
                    }
                }
            }
        }
        if "`actual_codevar'" == "" {
            di as err "get_sas19: no code variable found in `filepath' (pass codevar() to specify); skipping"
            continue
        }

        // find actual date var if desired
        local actual_datevar ""
        if "`want_datevar'" != "" {
            foreach v of local avail {
                if lower("`v'") == lower("`want_datevar'") {
                    local actual_datevar "`v'"
                    break
                }
            }
        }
        if "`actual_datevar'" == "" & `have_date_filter' {
            foreach cand in start start_proc adm eksd dato date admission_date admdate adm_dt {
                foreach v of local avail {
                    if lower("`v'") == "`cand'" {
                        local actual_datevar "`v'"
                        break
                    }
                }
                if "`actual_datevar'" != "" break
            }
        }

        // Build actual namelist to pass to import sas (use variable names exactly as available)
        local namelist_final ""
        // iterate namelist_tokens and pick those present in avail
        tokenize "`namelist_tokens'"
        while "`1'" != "" {
            foreach v of local avail {
                if lower("`v'") == lower("`1'") {
                    // append actual var name v (case preserved as import will create lower-case if case(lower))
                    if strpos(" `namelist_final' "," `v' ") == 0 local namelist_final "`namelist_final' `v'"
                }
            }
            macro shift
        }
        // ensure actual_codevar included
        if "`actual_codevar'" != "" & strpos(" `namelist_final' "," `actual_codevar' ") == 0 local namelist_final "`namelist_final' `actual_codevar'"
        if "`actual_datevar'" != "" & strpos(" `namelist_final' "," `actual_datevar' ") == 0 local namelist_final "`namelist_final' `actual_datevar'"

        // build if expression
        local ifexpr = "regexm(lower(`actual_codevar'),\"`code_pattern'\")"
        if `have_date_filter' & "`actual_datevar'" != "" {
            if "`fnum'" != "" & "`tnum'" != "" local ifexpr = "`ifexpr' & `actual_datevar' >= `fnum' & `actual_datevar' <= `tnum'"
            else if "`fnum'" != "" local ifexpr = "`ifexpr' & `actual_datevar' >= `fnum'"
            else if "`tnum'" != "" local ifexpr = "`ifexpr' & `actual_datevar' <= `tnum'"
        }

        // Now perform filtered import using namelist and ifexpr
        di as txt "get_sas19: importing variables:`namelist_final' if `ifexpr' using `filepath' (case=`caseopt')"
        capture noisily import sas `namelist_final' if `ifexpr' using "`filepath'", case(`caseopt') clear
        if _rc {
            // fallback: try import of variables only then filter in Stata
            di as warn "get_sas19: filtered import failed (rc=`_rc'), performing full namelist import then filtering in memory (may use more memory)."
            capture noisily import sas `namelist_final' using "`filepath'", case(`caseopt') clear
            if _rc {
                di as err "get_sas19: import failed for `filepath' (rc=`_rc') - skipping file"
                continue
            }
            // perform filter in Stata
            gen byte __keep = regexm(lower(`actual_codevar'), "`code_pattern'") 
            if `have_date_filter' & "`actual_datevar'" != "" {
                replace __keep = 0 if !missing(`actual_datevar') & (`actual_datevar' < `fnum' | `actual_datevar' > `tnum')
            }
            keep if __keep==1
            drop __keep
        }

        // skip if no obs
        count
        if r(N) == 0 {
            di as result "get_sas19: 0 matching rows in `filepath' (skipping)"
            clear
            continue
        }

        // Save or append
        if `first' {
            quietly save "`outdata'", replace
            local totalobs = r(N)
            local first = 0
            di as result "get_sas19: wrote `outdata' with `=_N' obs (from `filepath')"
        }
        else {
            tempfile chunk
            quietly save "`chunk'", replace
            quietly use "`outdata'", clear
            quietly append using "`chunk'"
            quietly save "`outdata'", replace
            local totalobs = `totalobs' + r(N)
            di as result "get_sas19: appended `=_N' obs from `filepath' (total ~ `totalobs')"
        }

        clear
    }

    di as txt "get_sas19 completed. approx total obs = `totalobs'."
    return scalar totalobs = `totalobs'
end
