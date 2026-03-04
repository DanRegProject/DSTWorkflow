
# %get() Macro

## Overview

`%get()` is a generic extraction macro used to retrieve register events from the Danish register data warehouse and assemble them into analysis-ready datasets.  
The macro searches one or more register sources for codes defined in a set definition and returns matching records.

The macro is designed to work with the indicator definitions created elsewhere in the workflow (e.g. through `IndicatorDef()` macros). Each indicator defines a list of diagnosis, procedure, or medication codes. `%get()` retrieves all rows in the source registers that match these codes.

Typical use cases include:

- Identifying events belonging to a study population
- Extracting diagnosis or procedure records associated with indicator definitions
- Preparing data for risk score calculations or comorbidity indices
- Building base populations from multiple register sources

The macro can search across multiple register sources and automatically combines results into a single dataset.

---

# Location

`mastercode/SAS/macros/getgeneric.sas`

---

# Syntax

```sas
%get(
    outlib=work,
    sets=,
    fromyear=1997,
    type=,
    indata=,
    outdata=,
    SOURCE=LPR PSYK PRIV LPR3,
    fromdate=,
    todate=,
    getvar=,
    subset=
);
```

---

# Parameters

| Parameter | Description |
|-----------|-------------|
| **outlib** | Library where output datasets will be written. Default = `WORK`. |
| **sets** | List of indicator names to search for. Each name must correspond to a macro variable containing a code list (e.g. `DIAG_STROKE`). |
| **fromyear** | Lower bound year used when filtering source data. Default = 1997. |
| **type** | Type of code to search. Valid values are typically `DIAG`, `OPR`, `UBE`, or additional types defined in `&xtragettypes`. |
| **indata** | Optional dataset containing a population restriction. Only individuals present in this dataset will be considered. |
| **outdata** | Optional dataset name where extracted observations will be appended. |
| **SOURCE** | List of source register families to search. Default: `LPR PSYK PRIV LPR3`. |
| **fromdate** | Optional lower date bound for events. |
| **todate** | Optional upper date bound for events. |
| **getvar** | Optional variable selection passed to the internal extraction macro. |
| **subset** | Optional additional WHERE condition applied to the extracted rows. |

---

# Behavior

## Indicator iteration

The macro loops through each indicator listed in `sets=`. For each indicator:

1. The macro verifies that a macro variable exists containing the code list.
2. The code list is passed to `%findrows()`.
3. `%findrows()` searches the selected source registers for matching codes.

If multiple source registers are used, the results are stacked together.

---

## Source handling

The macro searches one or more register sources defined in `SOURCE=`.

Typical sources include:

- `LPR` – Danish National Patient Register
- `PSYK` – Psychiatric register
- `PRIV` – Private hospital activity
- `LPR3` – New LPR structure

Each source is queried separately, and the results are combined into one dataset.

---

## Output dataset structure

For each indicator `X`, the macro creates:

```
&outlib..&type.X.ALL
```

This dataset contains all observations matching the indicator codes.

If multiple sources contribute data, a variable named:

```
source
```

is added to indicate the originating register.

The dataset is sorted by:

```
pnr
event date variable
code variable
```

The specific date and code variables depend on the `type` definition.

---

## Character length harmonization

When combining results from multiple source tables, character variables may have different lengths.

The macro automatically:

1. Detects character variables with inconsistent lengths
2. Generates a `LENGTH` statement using the maximum length
3. Applies it before stacking datasets

This prevents truncation during dataset merges.

---

# Optional output dataset

If `outdata=` is specified, the macro also creates or updates an aggregated dataset containing:

- Event date
- Selected variables defined by `stdgetvar` for the given `type`

The dataset is automatically deduplicated after all indicators have been processed.

---

# Internal workflow

The macro performs the following steps:

1. Validate required parameters (`sets` and `type`)
2. Normalize indicator names
3. Iterate through each indicator
4. Query each register source using `%findrows()`
5. Combine source datasets
6. Harmonize variable lengths
7. Sort and finalize datasets
8. Optionally append results to `outdata`

Execution time is measured using the internal timer utilities.

---

# Example

Example extraction of diagnosis codes defining a base population:

```sas
%get(
    outlib=mydata,
    sets=&basediag,
    outdata=basepop,
    type=DIAG
);
```

This example:

- searches all register sources
- extracts diagnosis codes defined in `&basediag`
- stores results in `mydata.DIAG_<indicator>.ALL`
- appends simplified results to `mydata.basepop`

---

# Example with population restriction

```sas
%get(
    outlib=mydata,
    sets=&diaglist,
    indata=mydata.population,
    outdata=diag_events,
    type=DIAG,
    fromdate='01JAN2000'd,
    todate='31DEC2020'd
);
```

Only events belonging to individuals in `mydata.population` will be returned.

---

# Error messages

| Message | Meaning |
|-------|--------|
| `get ERROR: Required arguments not specified` | `sets` or `type` missing |
| `get ERROR: Only one type allowed` | `type` contains multiple values |
| `get ERROR: type not recognized` | Unsupported type |
| `get WARNING: <indicator> not defined for <type>` | No code list defined for indicator |

---

# Dependencies

The macro relies on the following internal utilities:

- `%findrows()` – retrieves matching rows from source tables
- `%cleanup()` – removes temporary datasets
- `%nonrep()` – removes duplicate set names
- `%commas()` – formats variable lists
- `%runquit` – wrapper around RUN/QUIT statements
- `%start_timer()` / `%end_timer()` – performance logging

These macros must be available in the SAS macro path.

---

# Notes

- The macro is designed for large register datasets and assumes the presence of indexed event tables.
- Code definitions are expected to follow the project’s indicator naming conventions.
- `%get()` is frequently used in the **initial population definition step** of register studies.

---
