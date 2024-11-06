

# Module UI function
mod_my_biosecurity_ui <- function(id) {
  ns <- shiny::NS(id)
  
  shiny::tagList(
    div(
      style = "border: 0; border_radius: 10px; background-color:#DEEBF7; padding:20px; width : 600px; margin:auto;",
      h2("Login"),
      textInput(ns("email"), "Email"),
      passwordInput(ns("pw"), "Password")
    ),
    if (Sys.getenv("BROWSE") == "TRUE") { shiny::actionButton(ns("browse"), "Browse")}
  )
}

# Module server function
mod_my_biosecurity_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    
    shiny::observeEvent(input$browse, { browser() })
    
  })
}