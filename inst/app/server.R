server <- function(input, output, session) {
  selected_data <- shiny::reactive({
    shiny::req(input$origin, input$destination, input$months)
    flightlens::filter_flights(
      flightlens::flight_data,
      origin = input$origin,
      destination = input$destination,
      months = seq.int(input$months[1], input$months[2])
    )
  })
  
  all_summary <- shiny::reactive({
    shiny::req(input$group, !is.null(input$threshold))
    flightlens::summarise_delays(
      selected_data(), group = input$group, threshold = input$threshold
    )
  })
  
  visible_summary <- shiny::reactive({
    n <- input$min_n
    shiny::validate(shiny::need(
      is.numeric(n) && length(n) == 1L &&
        is.finite(n) && n >= 1 && n == floor(n),
      "Enter a positive whole number for the minimum recorded delays."
    ))
    shiny::validate(shiny::need(
      nrow(selected_data()) > 0,
      "No flights match this route and month range. Change an airport or widen the months."
    ))
    result <- all_summary()
    result <- result[result$n_observed >= n, , drop = FALSE]
    shiny::validate(shiny::need(
      nrow(result) > 0,
      "No groups meet the minimum recorded count. Lower the minimum or broaden the selection."
    ))
    if (input$group == "period") {
      order_levels <- c("Night (00-05)", "Morning (06-11)",
                        "Afternoon (12-17)", "Evening (18-23)")
      result <- result[order(match(result$group, order_levels)), , drop = FALSE]
    } else {
      result <- result[order(result$delayed_pct, result$group), , drop = FALSE]
    }
    result
  })
  
  output$coverage <- shiny::renderText({
    d <- selected_data()
    paste0(
      format(nrow(d), big.mark = ","), " selected records | ",
      format(sum(!is.na(d$dep_delay)), big.mark = ","), " recorded delays | ",
      format(sum(is.na(d$dep_delay)), big.mark = ","), " missing delays"
    )
  })
  
  output$caution <- shiny::renderText({
    result <- visible_summary()
    hidden <- nrow(all_summary()) - nrow(result)
    paste(
      paste0(nrow(result), " groups displayed; ", hidden, " below the minimum."),
      if (nrow(result) == 1L) {
        "Only one group remains: there is no between-group comparison."
      } else if (any(result$n_observed < 30)) {
        "At least one group has fewer than 30 observed delays; interpret cautiously."
      } else {
        "Compare missingness and counts alongside percentages."
      }
    )
  })
  
  output$delay_plot <- shiny::renderPlot({
    result <- visible_summary()
    plot_data <- data.frame(
      label = factor(result$group, levels = rev(result$group)),
      delayed_pct = result$delayed_pct
    )
    ggplot2::ggplot(
      plot_data,
      ggplot2::aes(x = delayed_pct, y = label)
    ) +
      ggplot2::geom_col(fill = "#285D8C", width = 0.6) +
      ggplot2::geom_text(
        ggplot2::aes(label = sprintf("%.1f%%", delayed_pct)),
        hjust = -0.12, size = 4
      ) +
      ggplot2::scale_x_continuous(
        limits = c(0, 110), breaks = c(0, 50, 100),
        labels = function(x) paste0(x, "%")
      ) +
      ggplot2::scale_y_discrete(
        labels = function(x) vapply(
          x, function(label) paste(strwrap(label, width = 20), collapse = "\n"),
          character(1)
        )
      ) +
      ggplot2::labs(
        title = paste0("At least ", input$threshold, " minutes late"),
        x = NULL,
        y = NULL,
        caption = "Percentage of recorded departure delays.\nMissing delays are excluded."
      ) +
      ggplot2::theme_minimal(base_size = 12) +
      ggplot2::theme(
        panel.grid.major.y = ggplot2::element_blank(),
        panel.grid.minor = ggplot2::element_blank(),
        plot.title.position = "plot",
        plot.caption.position = "plot",
        plot.caption = ggplot2::element_text(hjust = 0, size = 9)
      )
  }, res = 110, alt = "Horizontal bars comparing delayed percentages; exact values and counts appear in the table.")
  
  output$interpretation <- shiny::renderText({
    result <- visible_summary()
    lowest <- min(result$delayed_pct)
    names_lowest <- paste(result$group[result$delayed_pct == lowest],
                          collapse = ", ")
    sprintf(
      paste("Among displayed groups, %s had the lowest recorded delayed",
            "percentage (%.1f%%) at this threshold.",
            "This describes the selected 2013 observations, not a causal ranking."),
      names_lowest, lowest
    )
  })
  
  output$summary_table <- shiny::renderTable({
    result <- visible_summary()
    result <- result[c(
      "group", "n_total", "n_observed", "n_missing", "missing_pct",
      "delayed_pct", "mean_delay", "median_delay"
    )]
    names(result) <- c(
      "Group", "Records", "Observed", "Missing", "Missing %",
      "Delayed %", "Mean (min)", "Median (min)"
    )
    result
  }, digits = 1, striped = TRUE, bordered = FALSE, spacing = "s")
}