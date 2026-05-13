# riskSetMatch Macro Documentation

## Overview

The `riskSetMatch` macro performs **risk set matching** for case-control studies. It automatically selects age and sex-matched controls from a population dataset for each case, using random sampling. Controls are selected from individuals still at risk of the event at the time of case occurrence.

This macro is particularly useful for epidemiological studies where you need to:
- Match controls to cases by age (birth year) and sex
- Ensure controls are at risk at the case date
- Account for emigration and mortality in the control pool
- Randomly sample a specified number of controls per case

---

## Macro Call

```sas
%riskSetMatch(outdata, basedata, basedate, pop=master.population, nControls=5, 
              difbirthyear=0, ajour=today(), crit=, concritvar=);
```

---

## Parameters

### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `outdata` | Dataset name | Output dataset containing matched case-control pairs. Format: `pnr_case`, `pnr_control`, `&basedate`, and any additional criteria variables. |
| `basedata` | Dataset name | Input dataset of cases. Must contain `pnr` (person number) and `&basedate` (case date) variables. |
| `basedate` | Variable name | Name of the case date variable in `basedata` (e.g., `casedate`, `inclusionDate`). |

### Optional Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `pop` | `master.population` | Population/control pool dataset. Must contain: `pnr`, `sex`, `birthdate`, `deathdate`, `rec_in`, `rec_out`. |
| `nControls` | `5` | Number of controls to match per case. |
| `difbirthyear` | `0` | Tolerance in birth year matching (e.g., `1` allows ±1 year). |
| `ajour` | `today()` | Reference date for determining observation status (inclusion period). |
| `crit` | (empty) | Additional selection criteria as a WHERE clause. Use `&basedate` placeholder for the case date variable (will be converted to `a.t`). |
| `concritvar` | (empty) | Comma-separated list of additional variables to include in output (used with `crit`). |

---

## Output Dataset

The output dataset (`outdata`) contains one row per matched control, with the following variables:

| Variable | Description |
|----------|-------------|
| `pnr_case` | Person number of the case |
| `pnr_control` | Person number of the matched control |
| `&basedate` | Case date |
| `sex` | Sex of the case/control (1=male, 2=female) |
| Additional criteria variables | Any variables specified in `concritvar` |

**Note:** Cases are identifiable by rows where `pnr_case = pnr_control`.

---

## Matching Criteria

Controls are selected if they meet ALL of the following conditions at the case date:

1. **Different person**: `pnr_case ≠ pnr_control`
2. **Same sex**: Controls have the same sex as the case
3. **Similar age**: Birth year within `±difbirthyear` of the case
4. **At risk**: 
   - Control has no event date recorded (event date = missing), OR
   - Control's age at event date > case's age at case date
5. **Not emigrated**: No emigration (udv_dato) before or at the case's age at case date
6. **Alive**: No death (deathdate) before the case's age at case date
7. **Additional criteria**: If specified via `crit` parameter

---

## Examples

### Basic Usage: 5 age- and sex-matched controls per case

```sas
%riskSetMatch(
  outdata=mydata.casecontrol,
  basedata=mydata.cases,
  basedate=indexdate,
  pop=master.population,
  nControls=5
);
```

### Matching with birth year tolerance (±1 year)

```sas
%riskSetMatch(
  outdata=mydata.casecontrol,
  basedata=mydata.cases,
  basedate=indexdate,
  pop=master.population,
  nControls=5,
  difbirthyear=1
);
```

### Matching with additional selection criteria

```sas
%riskSetMatch(
  outdata=mydata.casecontrol,
  basedata=mydata.cases,
  basedate=indexdate,
  pop=master.population,
  nControls=10,
  crit=%str(a.region = b.region),
  concritvar=region
);
```

### Matching with historical data at a specific reference date

```sas
%riskSetMatch(
  outdata=mydata.casecontrol_2015,
  basedata=mydata.cases,
  basedate=casedate,
  pop=master.population,
  nControls=5,
  ajour='01jan2015'd
);
```

---

## Data Requirements

### Case Dataset (`basedata`)
Must contain:
- `pnr` (person number) - unique identifier
- `&basedate` (e.g., `casedate`, `inclusionDate`) - date variable for case event

### Population/Control Dataset (`pop`)
Must contain:
- `pnr` - unique identifier
- `sex` - coded as 1 (male) or 2 (female)
- `birthdate` - date of birth
- `deathdate` - date of death (missing if alive)
- `rec_in` - record start date (observation period start)
- `rec_out` - record end date (observation period end)

### Migration Dataset (`master.vandringer`)
Used internally to exclude individuals who emigrated. Must contain:
- `pnr` - unique identifier
- `indv_dato` - immigration date
- `udv_dato` - emigration date
- `rec_in` - record start date
- `rec_out` - record end date

---

## Algorithm Overview

1. **Extract valid controls**: Select population members present at `ajour` date
2. **Apply birth year range**: Limit to individuals born within `±difbirthyear` of cases
3. **Filter for risk set**: For each case, identify all eligible controls at risk at case date
4. **Randomize**: Assign random numbers to all eligible controls (case gets rank 1)
5. **Sample**: Select first `nControls` controls (by random order) for each case
6. **Repeat by birth year**: Process each birth year separately to ensure proper matching
7. **Combine**: Append results across all birth years

---

## Important Notes

- **Age matching**: Matching is performed on birth year (whole year), not exact age
- **Self-matching prevention**: Cases cannot be matched to themselves
- **Random sampling**: Controls are selected randomly from the eligible pool; repeated macro calls may produce different results
- **Missing dates**: Controls with missing event dates are considered "still at risk"
- **Birth year range**: Macro automatically sets minimum birth year to 1920 to avoid sparse data
- **Temporary datasets**: Internal temporary datasets are automatically deleted after execution

---

## Performance Considerations

- **Large populations**: This macro creates a Cartesian product during the inner join step; performance may slow with very large population datasets
- **Multiple birth years**: Processing occurs separately for each birth year, which can increase runtime for datasets spanning many decades
- **INOBS option**: Uses `INOBS=&sqlmax` to optimize large dataset processing

---

## Troubleshooting

| Issue | Possible Cause | Solution |
|-------|----------------|----------|
| No output records | No eligible controls found | Check birth year range, sex distribution, or event dates in population |
| Fewer controls than requested | Insufficient eligible controls in risk set | Increase `difbirthyear` or `nControls` parameter |
| Unexpected records deleted | Migration or death dates exclude controls | Verify emigration and mortality data |
| Macro errors with criteria | Incorrect `crit` syntax | Use `&basedate` as placeholder; test criteria independently |

---

## Dependencies

This macro requires the following to be available:

- `%start_timer()` - Timer macro for performance tracking
- `%end_timer()` - Timer macro completion
- `%MergePop()` - Population data merging macro
- `%commas()` - Utility macro to format comma-separated lists
- `%runquit()` - Utility macro for conditional PROC QUIT execution

---

## References

- **Case-control matching**: Breslow, N.E. and Day, N.E. (1980). *Statistical Methods in Cancer Research. Volume 1: The Analysis of Case-Control Studies*. IARC Scientific Publications.
- **Risk set sampling**: Risk set matching ensures controls have the same follow-up time potential as cases at the index date.

---

## Author & Version

- **Last Modified**: 2026-05-13
- **Repository**: DanRegProject/DSTWorkflow
- **Macro File**: `mastercode/SAS/macros/risksetmatch.sas`

---

## Revision History

| Date | Version | Changes |
|------|---------|---------|
| 2026-05-13 | 1.0 | Initial documentation |

