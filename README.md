# FlightLens

An assessed R package for historical NYC departure-delay exploration.
Development is in progress.

## Intended user and question

A junior aviation analyst reviewing historical operations.
For a selected NYC route and months in 2013, how did recorded
departure-delay rates differ by airline or scheduled departure period?

## Planned components

- Reproducible data preparation.
- Route filtering and delay-summary functions.
- A Shiny app using included package data.
- Tests, roxygen2 documentation and a getting-started vignette.
- A published pkgdown website.

## Explore a comparison

1. Select a departure airport and destination code.
2. Choose the month range; 1 is January and 12 is December.
3. Compare airlines or scheduled local departure periods.
4. Change the delay threshold to test whether the comparison changes.
5. Check observed counts and missingness before interpreting percentages.

A departure counts as delayed when its recorded delay is greater than or equal to the selected threshold. The denominator is non-missing departure delays, not all selected records.

The minimum-count control hides groups with fewer observed delays. Empty routes, invalid minimum counts and selections with no eligible groups produce informative messages.

## Interpretation limits

These are historical descriptions, not current booking recommendations or causal estimates. Airlines may differ in schedules and operating conditions even within the same route.

Missing delays are reported separately and are not treated as on time or confirmed cancellations. The minimum sample count is a display safeguard, not a significance threshold; percentages are presented without inferential uncertainty intervals.
