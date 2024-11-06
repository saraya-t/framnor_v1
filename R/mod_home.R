

# Module UI function
mod_home_ui <- function(id) {
  ns <- shiny::NS(id)
  
  shiny::tagList(  
    fluidRow(column(
      width = 12, 
      div(
        style = "position: relative;",
        img(src = "home_banner.png",
            style = "min-height:180px; min-width: 100%;"),
        div(
          style = "position: absolute; top: 8px; left: 16px;",
          h2(style = "max-width:600px;color: white;",
             "Biosecurity key prevention to prevent the introduction, development and spread of transmissible animal diseases to, from and within an animal population."))
      )
    )),
    fluidRow(column(
      width = 12,
      includeHTML("www/home_1.html")
    )),
    if (Sys.getenv("BROWSE") == "TRUE") { shiny::actionButton(ns("browse"), "Browse")}
  )
}

# Module server function
mod_home_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    
    shiny::observeEvent(input$browse, { browser() })
    
  })
}