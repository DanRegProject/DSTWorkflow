# Risk Set Matching Macro for Case-Control Studies

## Overview
This document provides comprehensive documentation on the risk set matching macro used in case-control studies. This macro is designed to facilitate the matching of cases and controls based on specific risk factors while ensuring a balanced representation of the defined groups.

## Location
The risk set matching macro can be found within the DSTWorkflow repository, specifically located in the file `risksetmatch_help.md`.

## High-Level Behavior
The macro executes the matching process by identifying cases and selecting control subjects from a predefined group based on specified parameters. It considers the proximity of controls to the cases in terms of the defined characteristics.

## Key Parameters
- **case_variable**: The variable used to identify which subjects are cases.
- **control_population**: Defines the population from which controls are selected.
- **matching_criteria**: Criteria used to match controls with cases, such as demographic factors or clinical characteristics.
- **max_distance**: The maximum allowable difference between matched cases and controls.

## Variable Naming Conventions
All variable names should follow the convention of using lowerCamelCase, where the first word starts with a lowercase letter and subsequent words are capitalized. For example, `caseVariable`, `controlPopulation`.

## Preconditions/Requirements
- Ensure that the database containing the data for both cases and controls is accessible.
- The data should have necessary variables defined for matching.
- Adequate sample sizes for both cases and controls to ensure effective matching.

## Return/Side-Effects
- The macro returns a dataset containing matched cases and controls.
- Potential side effects may include altered dataset distributions and changes in sample sizes after applying the filters.

## Error Messages/Warnings
- `No matches found`: Indicates that no controls met the defined matching criteria.
- `Insufficient cases`: Occurs when fewer cases are available than required for matching.
- `Invalid parameters`: Indicates that one or more parameters provided to the macro are incorrect or misformatted.

## Examples with Practical Usage Scenarios
1. **Basic Usage**: To match cases based on age and gender,
   ```
   riskSetMatch(case_variable='age', control_population='population_data', matching_criteria='gender', max_distance=5)
   ```
2. **Advanced Usage**: To perform matching with additional parameters,
   ```
   riskSetMatch(case_variable='condition', control_population='healthy_controls', matching_criteria='age, gender, comorbidities', max_distance=10)
   ```

## Notes and Implementation Details
- Implement the macro in accordance with the STROBE guidelines for observational studies.
- Regularly review and update the documentation to reflect any changes in macro functionality.

## Recommended Checks Before Running
- Verify that all input datasets are complete and correctly formatted.
- Confirm the existence of requisite variables in both cases and controls datasets.

## Troubleshooting Tips
- If no matches are found, review the matching criteria for potential misalignment with the datasets.
- Check for missing values in key variables that may influence the matching process.

## Contact/Maintenance Notes
For further assistance, please contact the DSTWorkflow maintainers at: dstworkflow@danregproject.org. Regular maintenance is scheduled on a quarterly basis to ensure functionality and update processes accordingly. 
