# Getting started with FlightLens

## Purpose

FlightLens helps a junior aviation analyst investigate historical
operations. Its question is: for a selected NYC route and months in
2013, how did recorded departure-delay rates differ by airline or
scheduled departure period?

## Install and launch

Install FlightLens from the [project
repository](https://github.com/ETC5523-2026/etc5523-assignment-4-issvish)
and launch the app. The application uses data included in the installed
package, without downloading records at runtime.

``` r

install.packages("remotes")
remotes::install_github("ETC5523-2026/etc5523-assignment-4-issvish")
flightlens::launch_app()
```

## Use the app

Start with JFK to LAX and all months, then select June through August.
Switch from airlines to scheduled departure periods to investigate
whether the comparison changes.

- **Departure airport:** the NYC origin code.
- **Destination:** the destination airport code.
- **Month range:** inclusive months; 1 is January, 12 is December.
- **Compare:** airlines or scheduled local departure periods.
- **Delay threshold:** minutes at or above which a recorded departure is
  counted as delayed.
- **Minimum observed count:** hides groups with fewer recorded departure
  delays.

Periods are night 00-05, morning 06-11, afternoon 12-17 and evening
18-23. They use scheduled departure hours, not actual departure hours.

## Read the outputs

The bar chart shows the percentage of recorded delays meeting the
threshold. A 15-minute threshold includes a flight delayed exactly 15
minutes.

``` math
\text{Delayed percentage}
=100\times\frac{\text{observed delays at or above the threshold}}
{\text{all observed departure delays}}.
```

The coverage text counts all selected records, observed delays and
missing delays before groups are hidden. The table shows the counts for
each displayed group. Therefore, its counts may not sum to the coverage
text when groups are excluded.

The mean and median are measured in minutes. Missing percentages use all
group records, while delayed percentages use only observed delays.

## Reproduce a route comparison

``` r

summer_route <- filter_flights(
  flight_data, origin = "JFK", destination = "LAX", months = 6:8
)
airline_summary <- summarise_delays(
  summer_route, group = "airline", threshold = 15
)
eligible <- airline_summary[airline_summary$n_observed >= 30, ]
knitr::kable(eligible, digits = 1)
```

| group | n_total | n_observed | n_missing | missing_pct | n_delayed | delayed_pct | mean_delay | median_delay |
|:---|---:|---:|---:|---:|---:|---:|---:|---:|
| American Airlines Inc. | 810 | 808 | 2 | 0.2 | 157 | 19.4 | 12.3 | -2 |
| Delta Air Lines Inc. | 611 | 611 | 0 | 0.0 | 142 | 23.2 | 11.9 | 0 |
| JetBlue Airways | 495 | 495 | 0 | 0.0 | 152 | 30.7 | 16.7 | 1 |
| United Air Lines Inc. | 519 | 517 | 2 | 0.4 | 100 | 19.3 | 10.4 | -1 |
| Virgin America | 457 | 456 | 1 | 0.2 | 107 | 23.5 | 18.5 | 1 |

Among the displayed groups for this route and period, United Air Lines
Inc. had the lowest recorded delayed percentage, 19.3%, using the
15-minute threshold. This describes these observations rather than
proving one airline performs better under identical operating
conditions.

## Compare departure periods

``` r

period_summary <- summarise_delays(
  summer_route, group = "period", threshold = 15
)
knitr::kable(period_summary, digits = 1)
```

| group | n_total | n_observed | n_missing | missing_pct | n_delayed | delayed_pct | mean_delay | median_delay |
|:---|---:|---:|---:|---:|---:|---:|---:|---:|
| Afternoon (12-17) | 1155 | 1151 | 4 | 0.3 | 278 | 24.2 | 14.3 | 0 |
| Evening (18-23) | 677 | 677 | 0 | 0.0 | 300 | 44.3 | 31.0 | 9 |
| Morning (06-11) | 1060 | 1059 | 1 | 0.1 | 80 | 7.6 | 1.8 | -2 |

Compare the observed sample sizes and missingness before comparing
percentages. These period groups combine airlines and are not controlled
estimates of time-of-day effects.

## Test a stricter delay definition

``` r

stricter <- summarise_delays(
  summer_route, group = "airline", threshold = 60
)
comparison <- data.frame(
  airline = airline_summary$group,
  delayed_15_pct = airline_summary$delayed_pct,
  delayed_60_pct = stricter$delayed_pct
)
knitr::kable(comparison, digits = 1)
```

| airline                | delayed_15_pct | delayed_60_pct |
|:-----------------------|---------------:|---------------:|
| American Airlines Inc. |           19.4 |            9.3 |
| Delta Air Lines Inc.   |           23.2 |            5.9 |
| JetBlue Airways        |           30.7 |           10.7 |
| United Air Lines Inc.  |           19.3 |            6.6 |
| Virgin America         |           23.5 |            8.1 |

For a fixed group and observed sample, the 60-minute percentage cannot
exceed the 15-minute percentage. Airline rankings can still change,
which is why changing the threshold is a meaningful interaction.

## Empty and weak states

``` r

empty <- filter_flights(flight_data, origin = character())
nrow(empty)
#> [1] 0
summarise_delays(empty)
#> [1] group        n_total      n_observed   n_missing    missing_pct 
#> [6] n_delayed    delayed_pct  mean_delay   median_delay
#> <0 rows> (or 0-length row.names)
```

In the app, selecting a route without records produces guidance to
change the airports or months. Setting the minimum to 1,000,000 produces
a message to lower it. Zero or a blank minimum produces an
input-validation message.

Groups with few observed delays can have unstable percentages. The
display minimum is not a statistical test, and a single remaining group
cannot support a between-group comparison.

## Data and limitations

The public source is `nycflights13` version 1.0.2, which distributes the
data under CC0 ([dataset
documentation](https://nycflights13.tidyverse.org/)).

The flight data reference attributes the original records to RITA,
Bureau of Transportation Statistics, and defines negative delay values
as early departures ([field
definitions](https://nycflights13.tidyverse.org/reference/flights.html)).

The preparation script retains all rows and missing departure delays.
Missing values are not interpreted as on-time departures or confirmed
cancellations.

These are 2013 observations, not current travel recommendations.
Differences may reflect schedules, weather, airline mix and other
operating conditions. No causal adjustment or confidence intervals are
provided.
