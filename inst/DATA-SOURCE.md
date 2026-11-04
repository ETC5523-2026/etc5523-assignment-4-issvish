# FlightLens data provenance

The source is `nycflights13` version 1.0.2, maintained by Hadley Wickham, which contains 336,776 NYC flight records for 2013 and supporting lookup tables ([nycflights13 documentation](https://nycflights13.tidyverse.org/)).

The upstream flight documentation identifies the RITA Bureau of Transportation Statistics as the original flight data source ([flight data reference](https://nycflights13.tidyverse.org/reference/flights.html)).

## Licensing

The upstream package is distributed under CC0; attribution is retained here even though CC0 does not require it ([source licence](https://nycflights13.tidyverse.org/)).

FlightLens code is MIT-licensed. Its code licence does not replace the source data's CC0 status.

## Preparation

Run `data-raw/prepare-flights.R` from the repository root. It:

- Imports `flights` and `airlines` from the pinned upstream package.
- Checks that airline carrier codes form a unique lookup.
- Matches airline names to flight records without changing row order.
- Constructs dates and four departure periods from scheduled local hours.
- Retains all rows and all missing departure delays.
- Saves the prepared object in `data/flight_data.rda`.
- Writes source version and counts to `data-raw/provenance.txt`.

The app uses the installed package object and does not download data at runtime.

## Field definitions

| Field | Definition |
|---|---|
| date | Scheduled departure date in 2013 |
| month | Month number, 1 to 12 |
| origin | NYC origin airport code: EWR, JFK or LGA |
| destination | Destination airport code |
| carrier | Two-letter airline code |
| airline | Airline name from the lookup table |
| scheduled_hour | Scheduled local departure hour, 0 to 23 |
| period | Night 00-05, morning 06-11, afternoon 12-17, evening 18-23 |
| dep_delay | Recorded departure delay, in minutes |

Negative departure delays mean early departures ([field documentation](https://nycflights13.tidyverse.org/reference/flights.html)).

Missing delays are retained and reported separately. They are not treated as zero, on time, or confirmed cancellations. The prepared data do not include a cancellation-status field.