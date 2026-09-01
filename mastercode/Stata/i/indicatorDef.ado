*! version 1.0.0
program define indicatorDef, rclass
    version 19.0
    // indicatorDef: register an indicator like the SAS %IndicatorDef macro
    //
    // Required options (named):
    //   type(string)    : data type, e.g. DIAG, OPR (will be uppercased)
    //   name(string)    : short indicator name (used to form global name)
    //   short(string)   : human-readable short/label text
    //   code(string)    : space- or comma-separated list of code prefixes
    //
    // Optional:
    //   icd8(string)    : ICD8 code list (only relevant for type=DIAG)
    //   w(string)       : weight value
    //   wdays(string)   : wdays value
    //   crit(string)    : criterion expression
    //   verbose(string) : TRUE/FALSE (default FALSE)
    syntax , TYPE(string) NAME(string) SHORT(string) CODE(string) ///
            [ ICD8(string) W(string) WDAYS(string) CRIT(string) VERBOSE(string) ]

    // normalize
    local type = ustrupper("`type'")
    local name_in = "`name'"
    local shorttxt = trim("`short'")
    local codes = trim("`code'")
    local icd8 = trim("`icd8'")
    local w = trim("`w'")
    local wdays = trim("`wdays'")
    local crit = trim("`crit'")
    local verbose = ustrupper(trim("`verbose'"))

    if "`verbose'" == "" local verbose = "FALSE"

    // ensure name forms a valid Stata global identifier suffix: replace non-alnum with underscore
    // also collapse repeated underscores
    tempname safe
    local safe = ustrregexra("`name_in'", "[^A-Za-z0-9]", "_")
    // collapse multiple underscores
    local safe = ustrregexra("`safe'", "_{2,}", "_")
    // strip leading/trailing underscores
    if substr("`safe'",1,1) == "_" local safe = substr("`safe'",2,.)
    if substr("`safe'",-1,1) == "_" local safe = substr("`safe'",1,strlen("`safe'")-1)
    if "`safe'" == "" local safe = "`name_in'"

    // Build global names
    local g_codes = "`type'`safe'"
    local g_label = "`type'L`safe'"

    // store the code list and label
    capture global `g_codes'
    global `g_codes' "`codes'"

    capture global `g_label'
    global `g_label' "`shorttxt'"

    // If DIAG type and icd8 provided: store as TYPE<name>_ICD8
    if "`icd8'" != "" {
        if "`type'" == "DIAG" {
            local g_icd8 = "`g_codes'_ICD8"
            capture global `g_icd8'
            global `g_icd8' "`icd8'"
        }
        else {
            // still allow user to store icd8 if desired, but warn
            local g_icd8 = "`g_codes'_ICD8"
            capture global `g_icd8'
            global `g_icd8' "`icd8'"
        }
    }

    // store optional attributes if provided: W -> _W, WDAYS -> _D, CRIT -> _C
    if "`w'" != "" {
        local g_w = "`g_codes'_W"
        capture global `g_w'
        global `g_w' "`w'"
    }
    if "`wdays'" != "" {
        local g_d = "`g_codes'_D"
        capture global `g_d'
        global `g_d' "`wdays'"
    }
    if "`crit'" != "" {
        local g_c = "`g_codes'_C"
        capture global `g_c'
        global `g_c' "`crit'"
    }

    // Append to xtragettypes (global) if not already present
    local curxt : global xtragettypes
    if "`curxt'" == "" {
        capture global xtragettypes
        global xtragettypes "`type'"
    }
    else {
        // split and test for presence
        local found = 0
        tokenize "`curxt'"
        while "`1'" != "" {
            if "`1'" == "`type'" local found = 1
            macro shift
        }
        if `found' == 0 {
            capture global xtragettypes
            global xtragettypes "`curxt' `type'"
        }
    }

    // Verbose output
    if "`verbose'" == "TRUE" {
        di as txt "indicatorDef: registered indicator for type=`type' name=`name_in' (safe=`safe')"
        di as txt "  $`g_codes'    = \"`=strtrim($`g_codes')'\""
        di as txt "  $`g_label'    = \"`=strtrim($`g_label')'\""
        if "`icd8'" != "" di as txt "  $`g_codes'_ICD8 = \"`=strtrim($`g_codes'_ICD8')'\""
        if "`w'" != "" di as txt "  $`g_codes'_W = \"`=strtrim($`g_codes'_W')'\""
        if "`wdays'" != "" di as txt "  $`g_codes'_D = \"`=strtrim($`g_codes'_D')'\""
        if "`crit'" != "" di as txt "  $`g_codes'_C = \"`=strtrim($`g_codes'_C')'\""
        di as txt "  $xtragettypes = \"`xtragettypes'\""
    }

    // return globals created (for programmatic checks)
    return local gcode "`g_codes'"
    return local glabel "`g_label'"
end
