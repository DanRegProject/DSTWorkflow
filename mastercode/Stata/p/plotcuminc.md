```markdown
# plotCuminc Help File

## Description

`plotCuminc` is a Stata program for plotting cumulative incidence values (risk) with optional confidence intervals and at-risk tables. It generates publication-quality graphs showing cumulative incidence curves stratified by group variables, with support for multiple endpoints and customizable formatting.

## Syntax

```stata
plotCuminc <CIstub>, ENDPoints(string) [options]
```

## Arguments

### Required

| Argument | Description |
|----------|-------------|
| `<CIstub>` | Variable stub/prefix for cumulative incidence variables. The program constructs variable names by appending endpoint names (e.g., `CIstub`e`time` for time variables). |

### Required Options

| Option | Description |
|--------|-------------|
| `ENDPoints(string)` | Space-separated list of endpoint identifiers to plot. For each endpoint `e`, variables named `CIstub``e`, `CIstub``e`time`, `CIstub``e`Status, `CIstub``e`lo, and `CIstub``e`hi must exist. |

## Optional Parameters

### Data Processing

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `BY(string)` | string | - | Grouping variable(s) for stratified plots. Can specify multiple variables separated by spaces. Stratification is applied to the legend and plot. |
| `if` | condition | - | Stata `if` qualifier to subset data before plotting. |
| `MINT(real)` | real | 0 | Minimum time value to display on x-axis. |
| `MAXT(real)` | real | 0 | Maximum time value to display on x-axis. If 0 (default), uses maximum value in data. |
| `fewdata(integer)` | integer | 5 | Minimum number of events required to plot a group. Groups with fewer events are hidden to prevent sparse data visualization. |

### Plot Customization

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `LINEOPT(string)` | string | - | Line options for plot command (e.g., `lcolor(blue) lwidth(medium)`). Can specify multiple options separated by separator character (see `sep` option). |
| `PLOTOPT(string)` | string | - | General graph options (e.g., `ylabel(0(0.1)1) xlabel(0(5)30)`). Applied to all plots. |
| `PLOTOPT2(string)` | string | - | Additional plot options specific to individual endpoints, separated by `sep()` character. |
| `TITLE(string asis)` | string asis | - | Graph titles for each endpoint, separated by `sep()` character. Supports `as is` formatting. |
| `SEP(string)` | string | `,` | Separator character/string for multiple values in `title()`, `lineopt()`, `plotopt2()` options. |
| `SAVINGPATH(string)` | string | `.` | Directory path for saving graph files and data. Use `.` for current directory. |
| `NAME(string)` | string | - | Base filename for saving output files. Final files named: `name`CIstub`maxt``e`.{gph,png,pdf,eps} |
| `ORGLEGEND(string)` | string | - | Custom legend text/formatting to display after each plot. |
| `HEADLEV(string)` | string | `**` | Heading level for console output of endpoint information (markdown-style). |
| `QUIETLY` | flag | - | Suppress graph display during execution. Graphs still saved to files. Sets graphics off during processing. |
| `NOFLATLINE` | flag | - | If specified, does not extend the last observation to `MAXT` on the x-axis. |

### Confidence Interval & Survival Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `CI` | flag | - | Include confidence interval bands in plot using `rarea` command around the cumulative incidence estimates. Requires `CIstub``e`lo and `CIstub``e`hi variables. |
| `SURVIVAL` | flag | - | Transform cumulative incidence to survival probabilities (1 - cumulative incidence). Inverts confidence interval bounds accordingly. |

### At-Risk Table Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `ATRISK` | flag | - | Display table of number at risk below the plot at specified time points. Requires `ATRISKTIMES()` option. |
| `ATRISKTIMES(string)` | string | - | Space-separated list of time points at which to display numbers at risk. Required if `atrisk` option specified. |
| `ATRISKPOSX(real)` | real | 0.2 | Horizontal position of at-risk table as fraction of maximum time (negative values place left of origin). |
| `ATRISKPOSY(real)` | real | 0.1 | Vertical position of at-risk table as fraction of maximum cumulative incidence (negative values place below origin). |
| `ATRISKOPT(string)` | string | `size(medsmall)` | Text formatting options for at-risk table (e.g., `size(small) color(navy)`). |
| `ATRISKCAP(string)` | string | `Numbers at risk` | Caption/header text for the at-risk table. |

### Data Export

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `SAVEDATA` | flag | - | Save processed plot data to `.dta` file. File named: `name`CIstub`maxt``e`.dta. Includes original by-variables and `id` variable. |

## Output Files

For each endpoint, the following files are generated (if plotting succeeds):

- `name`CIstub`maxt``e`.gph - Stata graph file
- `name`CIstub`maxt``e`.png - PNG image
- `name`CIstub`maxt``e`.pdf - PDF document
- `name`CIstub`maxt``e`.eps - EPS vector graphic
- `name`CIstub`maxt``e`.dta - Data file (if `savedata` specified)

## Required Variables

For each endpoint `e` specified in `ENDPoints()`, the following variables must exist:

| Variable | Description |
|----------|-------------|
| `CIstub``e` | Cumulative incidence estimate (0-1 scale, or 0-∞ if survival scale) |
| `CIstub``e`time | Follow-up time for each observation |
| `CIstub``e`Status | Event status indicator (1 = event, 0 = no event) |
| `CIstub``e`lo | Lower bound of confidence interval for cumulative incidence |
| `CIstub``e`hi | Upper bound of confidence interval for cumulative incidence |

## Examples

### Basic cumulative incidence plot

```stata
plotCuminc CI, endpoints(MI Stroke)  ///
    name(fig1) savingpath(/home/output)
```

Plots cumulative incidence for MI and Stroke endpoints using variables:
CI`MI`, CI`MI`time, CI`MI`Status, CI`MI`lo, CI`MI`hi (and similarly for Stroke)

### Stratified plot with confidence intervals

```stata
plotCuminc CI, endpoints(MI) by(sex treatment) ///
    ci title("MI Incidence by Sex and Treatment" , "Stratified Analysis") ///
    lineopt(lwidth(thick)) plotopt(ylabel(0(0.1)1)) ///
    name(fig_ci) savingpath(./graphs)
```

Plots MI cumulative incidence stratified by sex and treatment, with confidence interval bands.

### With at-risk table

```stata
plotCuminc incid, endpoints(event1 event2) by(group) ///
    atrisk atrisktimes(0 5 10 15 20) ///
    atriskcap("N subjects at risk") atriskopt(size(small)) ///
    name(fig_atrisk) savingpath(./output) savedata
```

Plots both event endpoints with at-risk tables at times 0, 5, 10, 15, 20 years.
Saves processed data and all graph formats.

### Survival analysis (1-minus cumulative incidence)

```stata
plotCuminc CI, endpoints(death) by(treatment) ///
    survival ci maxt(10) mint(0) ///
    title("Survival Probability") ///
    plotopt(ylabel(0(0.2)1) ytitle("Survival Probability")) ///
    lineopt(lwidth(medium)) ///
    name(survival) savingpath(./figures)
```

Transforms cumulative incidence to survival and plots with custom axis labels.

## Remarks

1. **Variable Construction**: The program builds variable names by concatenating the CIstub with endpoint names. Ensure your cumulative incidence variables follow the naming convention.

2. **Missing Data Handling**: Observations with missing cumulative incidence values are excluded from plots. The program checks this internally with `keep if `CIstub'`e'<.`

3. **Group Detection**: If `BY()` is specified, the program automatically orders legend items by the first appearance of groups in the dataset unless `order()` is explicitly included in `PLOTOPT()`.

4. **Sparse Data Warning**: Groups with fewer than `fewdata` observations (default 5) are not plotted, and a warning is displayed. Adjust `fewdata()` as needed.

5. **Step Function Plotting**: The program uses `connect(stairstep)` for all cumulative incidence curves, reflecting the discrete nature of cumulative incidence.

6. **Confidence Intervals**: CI bands are plotted using `rarea` and follow the scale transformation (e.g., inverted if `survival` specified).

## Author

Flemming Skjøth  
Created: 28 June 2017  
Last Modified: 25 May 2022

## Version

Stata 13.0 or higher

## See Also

- `stset` - Set up survival-time data
- `stcuminc` - Estimate cumulative incidence
- `twoway` - Produce scatter plots, line plots, etc.
- `graph export` - Export Stata graphs to external formats
```

This markdown help file provides a complete reference for the `plotcuminc` function, including:
- Clear descriptions of all parameters
- Required and optional arguments
- Example usage scenarios
- Expected variable naming conventions
- Output file specifications
- Important remarks about functionality
