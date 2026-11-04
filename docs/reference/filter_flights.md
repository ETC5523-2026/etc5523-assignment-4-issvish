# Filter Flight Records by Route and Months

Keep observations for selected origins, destinations and months.

## Usage

``` r
filter_flights(data, origin = NULL, destination = NULL, months = NULL)
```

## Arguments

- data:

  A data frame with `origin`, `destination`, and `month`.

- origin:

  Character vector of origin codes; `NULL` keeps all.

- destination:

  Character vector of destination codes; `NULL` keeps all.

- months:

  Integer-valued month numbers from 1 to 12. `NULL` keeps all months.

## Value

A data frame with the original columns and matching rows. A zero-length
selection or an unobserved route returns zero rows.

## Examples

``` r
selected <- filter_flights(flight_data, "JFK", "LAX", 6:8)
nrow(selected)
#> [1] 2892
```
