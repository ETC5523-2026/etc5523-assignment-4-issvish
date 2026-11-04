# Summarise Recorded Departure Delays

Compute counts, missingness and departure-delay summaries for each
group.

## Usage

``` r
summarise_delays(data, group = "airline", threshold = 15)
```

## Arguments

- data:

  A data frame with `dep_delay` and the selected grouping column.

- group:

  One of `"airline"`, `"period"`, `"origin"` or `"month"`.

- threshold:

  Non-negative delay threshold in minutes. A delay equal to the
  threshold counts as delayed.

## Value

A data frame with one row per observed group and columns:

- group:

  Group label, stored as character.

- n_total:

  All selected records in the group.

- n_observed:

  Records with a non-missing departure delay.

- n_missing:

  Records with a missing departure delay.

- missing_pct:

  Missing delays as a percentage of all group records.

- n_delayed:

  Observed delays greater than or equal to the threshold.

- delayed_pct:

  Delayed records as a percentage of observed delays.

- mean_delay:

  Mean recorded delay in minutes.

- median_delay:

  Median recorded delay in minutes.

## Details

Missing values do not enter delay percentages or numerical summaries.
Groups with no observed delays have `NA` for these statistics. Empty
input returns a zero-row data frame with the same columns. Results are
descriptive, not causal estimates or current recommendations.

## Examples

``` r
selected <- filter_flights(flight_data, "JFK", "LAX", 6:8)
summarise_delays(selected, group = "airline", threshold = 15)
#>                    group n_total n_observed n_missing missing_pct n_delayed
#> 1 American Airlines Inc.     810        808         2   0.2469136       157
#> 2   Delta Air Lines Inc.     611        611         0   0.0000000       142
#> 3        JetBlue Airways     495        495         0   0.0000000       152
#> 4  United Air Lines Inc.     519        517         2   0.3853565       100
#> 5         Virgin America     457        456         1   0.2188184       107
#>   delayed_pct mean_delay median_delay
#> 1    19.43069   12.32302           -2
#> 2    23.24059   11.87561            0
#> 3    30.70707   16.73535            1
#> 4    19.34236   10.42166           -1
#> 5    23.46491   18.48904            1
```
