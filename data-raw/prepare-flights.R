# Run from the package root, not from inside data-raw/.
# Preparation is pinned to this version for repeatability.
stopifnot(file.exists("DESCRIPTION"))
if (!requireNamespace("nycflights13", quietly = TRUE)) {
  stop("Install nycflights13 version 1.0.2 before running this script.")
}
if (as.character(utils::packageVersion("nycflights13")) != "1.0.2") {
  stop("Use remotes::install_version('nycflights13', version = '1.0.2').")
}

raw <- as.data.frame(nycflights13::flights)
airlines <- as.data.frame(nycflights13::airlines)
stopifnot(
  nrow(raw) == 336776L,
  !anyDuplicated(airlines$carrier),
  all(raw$carrier %in% airlines$carrier)
)

airline_names <- airlines$name[match(raw$carrier, airlines$carrier)]
hour <- as.integer(raw$hour)
stopifnot(all(hour >= 0L & hour <= 23L))

period <- cut(
  hour,
  breaks = c(0, 6, 12, 18, 24),
  right = FALSE,
  labels = c("Night (00-05)", "Morning (06-11)",
             "Afternoon (12-17)", "Evening (18-23)")
)

flight_data <- data.frame(
  date = as.Date(sprintf("%04d-%02d-%02d", raw$year, raw$month, raw$day)),
  month = as.integer(raw$month),
  origin = raw$origin,
  destination = raw$dest,
  carrier = raw$carrier,
  airline = airline_names,
  scheduled_hour = hour,
  period = as.character(period),
  dep_delay = raw$dep_delay,
  stringsAsFactors = FALSE
)

# STAGE_04: validate, save and record provenance.
stopifnot(
  nrow(flight_data) == nrow(raw),
  !anyNA(flight_data$airline),
  !anyNA(flight_data$period),
  !anyNA(flight_data$date),
  identical(flight_data$dep_delay, raw$dep_delay),
  all(flight_data$month %in% 1:12)
)

dir.create("data", showWarnings = FALSE)
save(flight_data, file = "data/flight_data.rda", compress = "xz", version = 2)

writeLines(
  c(
    "Source: nycflights13::flights and nycflights13::airlines",
    "Source package version: 1.0.2",
    "Source licence: CC0",
    paste("Rows:", nrow(flight_data)),
    paste("Missing departure delays:", sum(is.na(flight_data$dep_delay))),
    "Preserved all flight rows and missing delay values.",
    "Joined airline names by carrier code; derived dates and scheduled periods.",
    "Periods use scheduled local departure hour, not actual departure time.",
    "Source documentation: https://nycflights13.tidyverse.org/"
  ),
  "data-raw/provenance.txt"
)
