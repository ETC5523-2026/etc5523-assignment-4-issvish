#' Filter Flight Records by Route and Months
#'
#' Keep observations for selected origins, destinations and months.
#'
#' @param data A data frame with `origin`, `destination`, and `month`.
#' @param origin Character vector of origin codes; `NULL` keeps all.
#' @param destination Character vector of destination codes; `NULL` keeps all.
#' @param months Integer-valued month numbers from 1 to 12.
#'   `NULL` keeps all months.
#'
#' @return A data frame with the original columns and matching rows.
#'   A zero-length selection or an unobserved route returns zero rows.
#' @export
#'
#' @examples
#' selected <- filter_flights(flight_data, "JFK", "LAX", 6:8)
#' nrow(selected)
filter_flights <- function(data, origin = NULL,
                           destination = NULL, months = NULL) {
  required <- c("origin", "destination", "month")
  if (!is.data.frame(data) || !all(required %in% names(data))) {
    stop("data must contain origin, destination and month.", call. = FALSE)
  }
  for (selection in list(origin, destination)) {
    if (!is.null(selection) &&
        (!is.character(selection) || anyNA(selection))) {
      stop("Airport selections must be character vectors without NA.",
           call. = FALSE)
    }
  }
  if (!is.null(months) &&
      (!is.numeric(months) || anyNA(months) || !all(months %in% 1:12))) {
    stop("months must contain whole month numbers from 1 to 12.",
         call. = FALSE)
  }
  keep <- rep(TRUE, nrow(data))
  if (!is.null(origin)) keep <- keep & data$origin %in% origin
  if (!is.null(destination)) keep <- keep & data$destination %in% destination
  if (!is.null(months)) keep <- keep & data$month %in% months
  data[keep, , drop = FALSE]
}
