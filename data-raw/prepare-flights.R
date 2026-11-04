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

# match() is a many-to-one lookup that preserves flight row order.
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