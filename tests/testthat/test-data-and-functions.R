test_that("prepared data retain the expected rows and missing values", {
  expect_equal(nrow(flight_data), 336776L)
  expect_named(flight_data, c(
    "date", "month", "origin", "destination", "carrier",
    "airline", "scheduled_hour", "period", "dep_delay"
  ))
  expect_s3_class(flight_data$date, "Date")
  expect_false(anyNA(flight_data$airline))
  expect_gt(sum(is.na(flight_data$dep_delay)), 0)
  expect_true(all(flight_data$month %in% 1:12))
})

test_that("route filtering combines selections and handles empty input", {
  selected <- filter_flights(flight_data, "JFK", "LAX", 6:8)
  expect_gt(nrow(selected), 0)
  expect_true(all(selected$origin == "JFK"))
  expect_true(all(selected$destination == "LAX"))
  expect_true(all(selected$month %in% 6:8))
  expect_equal(filter_flights(flight_data), flight_data)
  expect_equal(nrow(filter_flights(flight_data, origin = character())), 0L)
  expect_equal(nrow(filter_flights(flight_data, "NOT_AN_AIRPORT")), 0L)
  expect_error(filter_flights(flight_data, months = 13), "month")
  expect_error(filter_flights(flight_data, months = 1.5), "month")
  expect_error(filter_flights(flight_data, origin = NA_character_), "Airport")
  expect_error(filter_flights(data.frame(x = 1)), "must contain")
})

test_that("summaries use observed delays and include threshold equality", {
  d <- data.frame(airline = c("A", "A", "A", "A"),
                  dep_delay = c(-5, 15, 30, NA_real_))
  result <- summarise_delays(d)
  expect_equal(result$n_total, 4L)
  expect_equal(result$n_observed, 3L)
  expect_equal(result$n_missing, 1L)
  expect_equal(result$missing_pct, 25)
  expect_equal(result$n_delayed, 2L)
  expect_equal(result$delayed_pct, 200 / 3)
  expect_equal(result$mean_delay, 40 / 3)
  expect_equal(result$median_delay, 15)
})

test_that("all-missing groups and empty inputs have defined results", {
  d <- data.frame(airline = c("A", "B"), dep_delay = c(NA_real_, 10))
  result <- summarise_delays(d)
  expect_equal(result$n_observed, c(0L, 1L))
  expect_true(is.na(result$delayed_pct[1]))
  expect_true(is.na(result$mean_delay[1]))
  empty <- summarise_delays(d[FALSE, ])
  expect_equal(nrow(empty), 0L)
  expect_named(empty, names(result))
})

test_that("invalid summary inputs fail clearly", {
  expect_error(summarise_delays(flight_data, group = "weather"), "group")
  expect_error(summarise_delays(flight_data, threshold = NA_real_), "threshold")
  expect_error(summarise_delays(flight_data, threshold = -1), "threshold")
  expect_error(summarise_delays(flight_data, threshold = c(1, 2)), "threshold")
  expect_error(summarise_delays(data.frame(airline = "A", dep_delay = Inf)),
               "finite")
  expect_error(summarise_delays(data.frame(airline = NA, dep_delay = 1)),
               "labels")
})