# Launch the FlightLens Shiny App

Explore historical departure delays using data included in this package.

## Usage

``` r
launch_app(...)
```

## Arguments

- ...:

  Arguments passed to
  [`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html), such
  as `port` or `launch.browser`.

## Value

The result of
[`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html), called
for its side effect of starting the application.

## Examples

``` r
if (interactive()) {
  launch_app()
}
```
