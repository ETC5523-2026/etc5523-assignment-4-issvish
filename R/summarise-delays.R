#' Summarise Recorded Departure Delays
#'
#' Compute counts, missingness and departure-delay summaries for each group.
#'
#' @param data A data frame with `dep_delay` and the selected grouping column.
#' @param group One of `"airline"`, `"period"`, `"origin"` or `"month"`.
#' @param threshold Non-negative delay threshold in minutes. A delay equal
#'   to the threshold counts as delayed.
#'
#' @return A data frame with one row per observed group and columns:
#' \describe{
#'   \item{group}{Group label, stored as character.}
#'   \item{n_total}{All selected records in the group.}
#'   \item{n_observed}{Records with a non-missing departure delay.}
#'   \item{n_missing}{Records with a missing departure delay.}
#'   \item{missing_pct}{Missing delays as a percentage of all group records.}
#'   \item{n_delayed}{Observed delays greater than or equal to the threshold.}
#'   \item{delayed_pct}{Delayed records as a percentage of observed delays.}
#'   \item{mean_delay}{Mean recorded delay in minutes.}
#'   \item{median_delay}{Median recorded delay in minutes.}
#' }
#'
#' @details
#' Missing values do not enter delay percentages or numerical summaries.
#' Groups with no observed delays have `NA` for these statistics.
#' Empty input returns a zero-row data frame with the same columns.
#' Results are descriptive, not causal estimates or current recommendations.
#' @export
#'
#' @examples
#' selected <- filter_flights(flight_data, "JFK", "LAX", 6:8)
#' summarise_delays(selected, group = "airline", threshold = 15)
summarise_delays <- function(data, group = "airline", threshold = 15) {
  allowed <- c("airline", "period", "origin", "month")
  if (!is.character(group) || length(group) != 1L ||
      is.na(group) || !group %in% allowed) {
    stop("group must be airline, period, origin or month.", call. = FALSE)
  }
  if (!is.data.frame(data) ||
      !all(c(group, "dep_delay") %in% names(data))) {
    stop("data must contain the grouping column and dep_delay.", call. = FALSE)
  }
  if (!is.numeric(threshold) || length(threshold) != 1L ||
      !is.finite(threshold) || threshold < 0) {
    stop("threshold must be one finite non-negative number.", call. = FALSE)
  }
  if (!is.numeric(data$dep_delay) ||
      any(!is.finite(data$dep_delay) & !is.na(data$dep_delay))) {
    stop("dep_delay must contain finite numbers or NA.", call. = FALSE)
  }
  if (anyNA(data[[group]])) {
    stop("Group labels must not be missing.", call. = FALSE)
  }
  empty <- data.frame(
    group = character(), n_total = integer(), n_observed = integer(),
    n_missing = integer(), missing_pct = double(), n_delayed = integer(),
    delayed_pct = double(), mean_delay = double(), median_delay = double()
  )
  if (nrow(data) == 0L) return(empty)
  
  labels <- as.character(data[[group]])
  parts <- lapply(sort(unique(labels)), function(label) {
    x <- data$dep_delay[labels == label]
    observed <- x[!is.na(x)]
    n <- length(observed)
    data.frame(
      group = label,
      n_total = length(x),
      n_observed = n,
      n_missing = sum(is.na(x)),
      missing_pct = 100 * mean(is.na(x)),
      n_delayed = sum(observed >= threshold),
      delayed_pct = if (n > 0L) 100 * mean(observed >= threshold) else NA_real_,
      mean_delay = if (n > 0L) mean(observed) else NA_real_,
      median_delay = if (n > 0L) stats::median(observed) else NA_real_
    )
  })
  result <- do.call(rbind, parts)
  rownames(result) <- NULL
  result
}
