# Prepared NYC Departure Records for 2013

All source flight rows, with airline names and scheduled departure
periods. Missing departure delays are retained, not imputed.

## Usage

``` r
flight_data
```

## Format

A data frame with 336776 rows and nine columns:

- date:

  Scheduled departure date.

- month:

  Month number from 1 to 12.

- origin:

  NYC origin airport code: EWR, JFK or LGA.

- destination:

  Destination airport code.

- carrier:

  Two-letter airline code.

- airline:

  Airline name from the source lookup table.

- scheduled_hour:

  Scheduled local departure hour, 0 to 23.

- period:

  Night (00-05), Morning (06-11), Afternoon (12-17), or Evening (18-23),
  based on scheduled local departure time.

- dep_delay:

  Departure delay in minutes. Negative values mean early departures.
  Missing values are retained.

## Source

Prepared from `nycflights13` version 1.0.2, by Hadley Wickham. The
upstream data are distributed under CC0:
<https://nycflights13.tidyverse.org/>. Original flight data: RITA Bureau
of Transportation Statistics, as recorded at
<https://nycflights13.tidyverse.org/reference/flights.html>.

## Details

The reproducible script is `data-raw/prepare-flights.R` in the
repository. These data describe 2013 operations, not current booking
conditions. A missing delay is not classified as a cancellation or an
on-time departure.

## Examples

``` r
head(flight_data)
#>         date month origin destination carrier                airline
#> 1 2013-01-01     1    EWR         IAH      UA  United Air Lines Inc.
#> 2 2013-01-01     1    LGA         IAH      UA  United Air Lines Inc.
#> 3 2013-01-01     1    JFK         MIA      AA American Airlines Inc.
#> 4 2013-01-01     1    JFK         BQN      B6        JetBlue Airways
#> 5 2013-01-01     1    LGA         ATL      DL   Delta Air Lines Inc.
#> 6 2013-01-01     1    EWR         ORD      UA  United Air Lines Inc.
#>   scheduled_hour          period dep_delay
#> 1              5   Night (00-05)         2
#> 2              5   Night (00-05)         4
#> 3              5   Night (00-05)         2
#> 4              5   Night (00-05)        -1
#> 5              6 Morning (06-11)        -6
#> 6              5   Night (00-05)        -4
table(flight_data$origin)
#> 
#>    EWR    JFK    LGA 
#> 120835 111279 104662 
```
