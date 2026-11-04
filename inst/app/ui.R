ui <- shiny::fluidPage(
  shiny::tags$head(
    shiny::tags$link(rel = "stylesheet", href = "styles.css")
  ),
  shiny::tags$a(href = "#results", class = "skip-link", "Skip to results"),
  shiny::div(
    class = "app-heading",
    shiny::p(class = "eyebrow", "HISTORICAL OPERATIONS / NYC / 2013"),
    shiny::h1("FlightLens"),
    shiny::p("Departure delays, with the sample behind every comparison.")
  ),
  shiny::div(
    class = "purpose",
    shiny::p(shiny::strong("For: "),
             "a junior aviation analyst reviewing historical operations."),
    shiny::p(shiny::strong("Question: "),
             paste("For a selected NYC route and months in 2013, how did",
                   "recorded departure-delay rates differ by airline",
                   "or scheduled departure period?"))
  ),
  shiny::sidebarLayout(
    shiny::sidebarPanel(
      width = 3,
      shiny::h2("Define a comparison"),
      shiny::selectInput(
        "origin", "Departure airport",
        c("JFK: John F. Kennedy" = "JFK",
          "EWR: Newark" = "EWR", "LGA: LaGuardia" = "LGA")
      ),
      shiny::selectInput(
        "destination", "Destination airport code",
        sort(unique(flightlens::flight_data$destination)), selected = "LAX"
      ),
      shiny::sliderInput(
        "months", "Month range in 2013", min = 1, max = 12,
        value = c(1, 12), step = 1, sep = ""
      ),
      shiny::selectInput(
        "group", "Compare",
        c("Airlines" = "airline", "Scheduled departure periods" = "period")
      ),
      shiny::sliderInput(
        "threshold", "Delay threshold (minutes)", min = 0,
        max = 120, value = 15, step = 5
      ),
      shiny::numericInput(
        "min_n", "Minimum recorded delays per group",
        value = 30, min = 1, step = 1
      ),
      shiny::helpText(
        "Months: 1 = January, 12 = December.",
        "The destination list includes every source destination, so",
        "some route combinations have no flights."
      ),
      shiny::helpText(
        "Start with a route and months. Switch the comparison, then test",
        "whether the pattern changes under a larger delay threshold.",
        "The minimum count hides groups with too little recorded data."
      )
    ),
    shiny::mainPanel(
      width = 9,
      shiny::div(
        id = "results",
        shiny::h2("Comparison results"),
        shiny::div(class = "coverage", role = "status",
                   shiny::textOutput("coverage")),
        shiny::div(class = "caution", shiny::textOutput("caution")),
        shiny::plotOutput("delay_plot", height = "380px"),
        shiny::div(class = "interpretation", shiny::textOutput("interpretation")),
        shiny::h2("Counts and supporting statistics"),
        shiny::div(class = "table-scroll", shiny::tableOutput("summary_table")),
        shiny::p(
          class = "field-note",
          paste("Records = all selected rows. Observed = non-missing delays.",
                "Missing = unavailable delays. Missing % uses all records.",
                "Delayed % uses observed delays only. Mean and median are minutes.",
                "Negative values indicate early departures.")
        ),
        shiny::tags$details(
          shiny::tags$summary("Fields, missing data and interpretation limits"),
          shiny::p(
            "Origin and destination are airport codes. Airline names use",
            "the historical carrier lookup. Periods use scheduled local",
            "departure hours: night 00-05, morning 06-11, afternoon 12-17,",
            "evening 18-23."
          ),
          shiny::p(
            "Missing delays are not counted as on time or as confirmed",
            "cancellations. The selected minimum is a display safeguard,",
            "not a statistical significance rule."
          ),
          shiny::p(
            "Comparisons are descriptive. Even on the same route, airlines",
            "can differ in schedules and operating conditions. Departure-period",
            "comparisons pool airlines. No uncertainty intervals or causal",
            "adjustments are provided. These 2013 results are not advice",
            "for booking flights today."
          )
        ),
        shiny::tags$footer(
          "Data: nycflights13 1.0.2 / Bureau of Transportation Statistics. ",
          shiny::tags$a(
            href = "https://nycflights13.tidyverse.org/",
            "Source documentation and CC0 licence",
            target = "_blank", rel = "noopener"
          )
        )
      )
    )
  )
)