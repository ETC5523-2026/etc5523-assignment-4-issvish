#' Launch the FlightLens Shiny App
#'
#' Explore historical departure delays using data included in this package.
#'
#' @param ... Arguments passed to [shiny::runApp()], such as `port`
#'   or `launch.browser`.
#' @return The result of [shiny::runApp()], called for its side effect
#'   of starting the application.
#' @export
#'
#' @examples
#' if (interactive()) {
#'   launch_app()
#' }
launch_app <- function(...) {
  path <- system.file("app", package = "flightlens")
  if (!nzchar(path)) {
    stop("App files were not found. Reinstall flightlens.", call. = FALSE)
  }
  shiny::runApp(appDir = path, ...)
}