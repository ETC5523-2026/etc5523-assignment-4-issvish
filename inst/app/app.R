# Source files relative to the app directory managed by shiny::runApp().
source("ui.R", local = TRUE)
source("server.R", local = TRUE)
shiny::shinyApp(ui = ui, server = server)