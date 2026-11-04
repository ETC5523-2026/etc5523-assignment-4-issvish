test_that("the installed app has its expected files", {
  for (f in c("app.R", "ui.R", "server.R", "www/styles.css")) {
    expect_true(file.exists(system.file("app", f, package = "flightlens")))
  }
})

test_that("reactive selections and denominator changes work", {
  env <- new.env(parent = globalenv())
  sys.source(system.file("app", "server.R", package = "flightlens"), env)
  shiny::testServer(env$server, {
    session$setInputs(
      origin = "JFK", destination = "LAX", months = c(1, 12),
      group = "airline", threshold = 15, min_n = 30
    )
    expect_gt(nrow(selected_data()), 0)
    expect_gt(nrow(visible_summary()), 1)
    at_15 <- all_summary()
    session$setInputs(threshold = 60)
    at_60 <- all_summary()
    expect_true(all(at_60$delayed_pct <= at_15$delayed_pct))
    session$setInputs(group = "period")
    expect_true(all(all_summary()$group %in% c(
      "Night (00-05)", "Morning (06-11)",
      "Afternoon (12-17)", "Evening (18-23)"
    )))
    session$setInputs(min_n = 1000000)
    expect_error(visible_summary(), "No groups meet")
    session$setInputs(min_n = 0)
    expect_error(visible_summary(), "positive whole")
    session$setInputs(min_n = 30, origin = "LGA", destination = "LAX")
    expect_equal(nrow(selected_data()), 0L)
    expect_error(visible_summary(), "No flights match")
    session$setInputs(origin = "JFK", months = c(6, 8))
    expect_true(all(selected_data()$month %in% 6:8))
    expect_gt(nrow(visible_summary()), 0)
  })
})