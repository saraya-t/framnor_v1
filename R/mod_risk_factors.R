

# Module UI function
mod_risk_factors_ui <- function(id) {
  ns <- shiny::NS(id)
  
  shiny::tagList(    
    #p("This table shows the 30 variables found to have a statistically significant association with the occurrence of high mortality."),
    #uiOutput(ns("table_ui")),
    p("Under construction"),
    if (Sys.getenv("BROWSE") == "TRUE") { shiny::actionButton(ns("browse"), "Browse")}
  )
}

# Module server function
mod_risk_factors_server <- function(id, survey_data) {
  shiny::moduleServer(id, function(input, output, session) {
    
    shiny::observeEvent(input$browse, { browser() })
    
    output$table_ui <- renderUI({
      shiny::req(survey_data())
      ns <- session$ns
      
      tagList(
        flextable::flextable(tibble::tibble(
          section = c("Section 1:", "Section 4:"),
          variables = c("Farms are family-owned as the type of business", "Fish are vaccinated"),
          p_value = c(0.034, 0.002),
          or = c(4, 0.19),
          ci_95 = c("1.23-13.02", "0.069-0.53"))) %>%
          flextable::set_header_labels(values = c(
            section = "Section", variables = "Variables", p_value = "p-value", or = "OR", ci_95 = "CI 95%")) %>% 
          flextable::width(1, 1.5) %>%
          flextable::width(2, 4) %>% 
          flextable::htmltools_value()
      )
    })
  })
}
