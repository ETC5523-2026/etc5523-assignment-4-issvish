# FlightLens

Historical NYC departure-delay comparisons in an installable R package. The package includes prepared data, reusable functions and a Shiny app.

**Author:** Vishal Sampath  
**GitHub username:** `issvish`  
**Repository:** [ETC5523-2026/etc5523-assignment-4-issvish](https://github.com/ETC5523-2026/etc5523-assignment-4-issvish)

## User and question

**Intended user:** a junior aviation analyst reviewing historical operations.

**Question:** For a selected NYC route and months in 2013, how did recorded departure-delay rates differ by airline or scheduled departure period?

## Install and launch

Install the package from its GitHub repository and launch the app:

```r
install.packages("remotes")
remotes::install_github("ETC5523-2026/etc5523-assignment-4-issvish")
flightlens::launch_app()
```

The app uses `flightlens::flight_data`, included in the installed package. No CSV or external data service is read at app startup.

## Explore a comparison

1. Select a departure airport and destination code.
2. Choose the month range; 1 is January and 12 is December.
3. Compare airlines or scheduled local departure periods.
4. Change the delay threshold to test whether the comparison changes.
5. Check observed counts and missingness before interpreting percentages.

A departure counts as delayed when its recorded delay is greater than or equal to the selected threshold. The denominator is non-missing departure delays, not all selected records.

The minimum-count control hides groups with fewer observed delays. Empty routes, invalid minimum counts and selections with no eligible groups produce informative messages.

## Use the functions

```r
library(flightlens)

summer_route <- filter_flights(
  flight_data, origin = "JFK", destination = "LAX", months = 6:8
)
summarise_delays(summer_route, group = "airline", threshold = 15)
summarise_delays(summer_route, group = "period", threshold = 60)
```

`filter_flights()` selects routes and months. `summarise_delays()` reports total, observed, missing and delayed counts, percentages, mean delay and median delay.

## Data and preparation

The package prepares all 336,776 flight records from `nycflights13` version 1.0.2 and joins its airline lookup table; the upstream package is distributed under CC0 ([nycflights13](https://nycflights13.tidyverse.org/)).

The original flight data are attributed to RITA, Bureau of Transportation Statistics in the [upstream flight reference](https://nycflights13.tidyverse.org/reference/flights.html).

Reproduce the included data from the repository root:

```r
remotes::install_version("nycflights13", version = "1.0.2", upgrade = "never")
source("data-raw/prepare-flights.R")
```

All rows and missing delay values are retained. Airline names are matched by carrier code, dates are constructed and departure periods are derived from scheduled local hours.

See `inst/DATA-SOURCE.md` for the data dictionary and `data-raw/provenance.txt` for source version and preparation counts. The data remain CC0; package code is MIT-licensed.

## Documentation

The intended [package website](https://ETC5523-2026.github.io/etc5523-assignment-4-issvish/) address uses the repository's organisation and name. Public availability must be verified after publication.

The generated website includes function and dataset reference pages and a getting-started vignette covering installation, launch, app controls and interpretation.

## Interpretation limits

These are historical descriptions, not current booking recommendations or causal estimates. Airlines may differ in schedules and operating conditions even within the same route.

Missing delays are reported separately and are not treated as on time or confirmed cancellations. The minimum sample count is a display safeguard, not a significance threshold; percentages are presented without inferential uncertainty intervals.

## Development

```r
devtools::document()
devtools::test()
devtools::check()
pkgdown::build_site()
```

Publish the generated `docs/` folder through GitHub Pages by selecting **Deploy from a branch**, branch **main**, and folder **/docs** in the repository's Pages settings. Check the public URL and installed package before submission.

## AI-use declaration

I completed this assignment independently, using **ChatGPT** as a supporting tool to clarify concepts, explore ideas and troubleshoot specific challenges throughout the development process.

AI assistance included:
- Suggesting code organisation, the structure of the pkgdown website, additional documentation pages and improvements to the Shiny application layout.
- Troubleshooting error messages encountered during pushing my work to the remote repository
- Troubleshooting R and Shiny errors relating to package development, dataset creation, package installation and pkgdown website generation.
- Refining documentation wording and helping identify potential implementation errors.

I remained responsible for dataset selection, analysis, application development, testing and the final submission. All AI-generated suggestions were reviewed, checked and, where appropriate, revised in RStudio before being incorporated into the submitted package. AI was used to support, rather than replace, my own understanding, judgement and work.