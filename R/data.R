#' Prepared NYC Departure Records for 2013
#'
#' All source flight rows, with airline names and scheduled departure periods.
#' Missing departure delays are retained, not imputed.
#'
#' @format A data frame with 336776 rows and nine columns:
#' \describe{
#'   \item{date}{Scheduled departure date.}
#'   \item{month}{Month number from 1 to 12.}
#'   \item{origin}{NYC origin airport code: EWR, JFK or LGA.}
#'   \item{destination}{Destination airport code.}
#'   \item{carrier}{Two-letter airline code.}
#'   \item{airline}{Airline name from the source lookup table.}
#'   \item{scheduled_hour}{Scheduled local departure hour, 0 to 23.}
#'   \item{period}{Night (00-05), Morning (06-11), Afternoon (12-17),
#'     or Evening (18-23), based on scheduled local departure time.}
#'   \item{dep_delay}{Departure delay in minutes. Negative values mean early
#'     departures. Missing values are retained.}
#' }
#'
#' @source
#' Prepared from `nycflights13` version 1.0.2, by Hadley Wickham.
#' The upstream data are distributed under CC0:
#' <https://nycflights13.tidyverse.org/>.
#' Original flight data: RITA Bureau of Transportation Statistics,
#' as recorded at <https://nycflights13.tidyverse.org/reference/flights.html>.
#'
#' @details
#' The reproducible script is `data-raw/prepare-flights.R` in the repository.
#' These data describe 2013 operations, not current booking conditions.
#' A missing delay is not classified as a cancellation or an on-time departure.
#'
#' @examples
#' head(flight_data)
#' table(flight_data$origin)
"flight_data"