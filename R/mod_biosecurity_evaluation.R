

# Module UI function
mod_biosecurity_evaluation_ui <- function(id) {
  ns <- shiny::NS(id)
  
  shiny::tagList(  
    fluidRow(
      style = "margin-bottom:30px; display: flex; align-items: center;",
      column(width = 2, img(src = "logo_name.png", width = "300px")),
      column(
        width = 10, offset = 2,
        div(style = "width:160px;height:40px;padding:0 10px;float:left;", actionLink(ns("biosecurity_evaluation_btn"), "Biosecurity Evaluation Tools")),
        div(style = "width:160px;height:40px;padding:0 30px 0 10px;float:left;", actionLink(ns("what_is_biosecurity_btn"), "What is Biosecurity \nin Aquaculture")),
        div(style = "width:150px;height:40px;padding:0 10px;float:left;", actionLink(ns("summary_statistics_btn"), "Summary statistics")),
        div(style = "width:110px;height:40px;padding:0 10px;float:left;", actionLink(ns("risk_factors_btn"), "Risk profiling")),
        div(style = "width:140px;height:40px;padding:0 10px;float:left;", actionLink(ns("home_btn"), "Project Framnor"))
      )
      # column(width = 2, img(src = "logo_name.png", width = "300px")),
      # column(width = 2, offset = 2, actionLink(ns("biosecurity_evaluation_btn"), "Biosecurity Evaluation Tools")),
      # column(width = 2, actionLink(ns("what_is_biosecurity_btn"), "What is Biosecurity in Aquaculture")),
      # column(width = 1, actionLink(ns("summary_statistics_btn"), "Summary statistics")),
      # column(width = 1, actionLink(ns("risk_factors_btn"), "Risk profiling")),
      # column(width = 1, actionLink(ns("home_btn"), "Project Framnor"))
      # column(width = 2, offset = 1, actionButton(ns("my_biosecurity_btn"), "My biosecurity"))
    ),
    tabBox(
      title = "", id = "be", width = 12,
      tabPanel("Statistic for Norway", mod_biosecurity_evaluation_norway_ui(ns("norway"))),
      tabPanel("My scoring", mod_biosecurity_evaluation_user_ui(ns("user")))
    ),
    if (Sys.getenv("BROWSE") == "TRUE") { shiny::actionButton(ns("browse"), "Browse")}
  )
}

# Module server function
mod_biosecurity_evaluation_server <- function(id, 
                                              parent,
                                              survey_data, 
                                              growout, 
                                              onland_hatchery, 
                                              onland_hatchery_s,
                                              onland_hatchery_r,
                                              onland_hatchery_p,
                                              onland_hatchery_sr,
                                              onland_hatchery_sp,
                                              onland_hatchery_rp,
                                              farms_geo,
                                              settings) {
  shiny::moduleServer(id, function(input, output, session) {
    
    shiny::observeEvent(input$browse, { browser() })
    
    shiny::observeEvent(input$home_btn, {                   shiny::updateTabsetPanel(session = parent, inputId = "main_menu", selected = "home") })
    shiny::observeEvent(input$what_is_biosecurity_btn, {    shiny::updateTabsetPanel(session = parent, inputId = "main_menu", selected = "what_is_biosecurity") })
    shiny::observeEvent(input$summary_statistics_btn, {     shiny::updateTabsetPanel(session = parent, inputId = "main_menu", selected = "summary_statistics") })
    shiny::observeEvent(input$risk_factors_btn, {           shiny::updateTabsetPanel(session = parent, inputId = "main_menu", selected = "risk_factors") })
    shiny::observeEvent(input$biosecurity_evaluation_btn, { shiny::updateTabsetPanel(session = parent, inputId = "main_menu", selected = "biosecurity_evaluation") })
    shiny::observeEvent(input$my_biosecurity_btn, {         shiny::updateTabsetPanel(session = parent, inputId = "main_menu", selected = "my_biosecurity") })
    
    
    mod_biosecurity_evaluation_norway_server(
      id                 = "norway", 
      growout            = growout, 
      onland_hatchery    = onland_hatchery,
      onland_hatchery_s  = onland_hatchery_s,
      onland_hatchery_r  = onland_hatchery_r,
      onland_hatchery_p  = onland_hatchery_p,
      onland_hatchery_sr = onland_hatchery_sr,
      onland_hatchery_sp = onland_hatchery_sp,
      onland_hatchery_rp = onland_hatchery_rp,
      farms_geo          = farms_geo,
      settings           = settings)
    mod_biosecurity_evaluation_user_server(
      id              = "user", 
      survey_data     = survey_data,
      growout         = growout, 
      onland_hatchery = onland_hatchery,
      farms_geo       = farms_geo,
      settings        = settings)
  })
}
