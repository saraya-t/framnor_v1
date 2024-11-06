

# Module UI function
mod_summary_statistics_ui <- function(id) {
  ns <- shiny::NS(id)
  
  shiny::tagList(
    p("In this section you can select  a category from the survey and the questions that comprise it to get a summary of the responses"),
    uiOutput(ns("summary_response_ui")),
    if (Sys.getenv("BROWSE") == "TRUE") { shiny::actionButton(ns("browse"), "Browse")}
  )
}

# Module server function
mod_summary_statistics_server <- function(id, survey_data, question, question_info) {
  shiny::moduleServer(id, function(input, output, session) {
    
    shiny::observeEvent(input$browse, { browser() })
    
    
    output$summary_response_ui <- renderUI({
      shiny::req(survey_data(), question(), question_info())
      ns <- session$ns
      
      q_prod     <- sort(na.omit(unique(survey_data()$Q2.6)))
      q_prod_sel <- q_prod
      
      non_na_cols <- survey_data() %>% 
        dplyr::filter(Q2.6 %in% q_prod_sel) %>% 
        purrr::map_lgl(~ all(is.na(.)))
      non_na_cols <- names(non_na_cols[!non_na_cols])
      
      non_na_question <- non_na_cols %>% 
        stringr::str_sub(2, -1) %>% 
        purrr::map_chr(~ paste(stringr::str_split(., stringr::fixed("."))[[1]][1:2], collapse = ".")) %>% 
        unique()
        
      q <- question_info() %>% 
        dplyr::filter(section != 1) %>%
        dplyr::filter(question_lvl2_id != "2.1") %>% 
        dplyr::filter(question_lvl2_id %in% non_na_question) 
      
      # q <- question() %>% 
      #   dplyr::filter(section != 1) %>%
      #   dplyr::filter(question_var %in% non_na_cols) 
      
      q_cat <- q %>% 
        dplyr::distinct(section_title, section) %>% 
        dplyr::select(section_title, section) %>% # Re-order,because distinct doesn't
        tibble::deframe()
      q_cat_sel <- q_cat[1]
      
      q_chs <- q %>% 
        dplyr::filter(section == q_cat_sel) %>%
        dplyr::select(question_lvl2, question_lvl2_id) %>% 
        tibble::deframe()
      q_chs_sel <- q_chs[1]
      # q_chs <- q %>% 
      #   dplyr::filter(section == q_cat_sel) %>%
      #   dplyr::select(question, question_var) %>% 
      #   tibble::deframe()
      
      tagList(
        fluidRow(
          column(width = 3, shiny::div(
            style = "width:100%; max-width:600px; padding-left:8px;",
            checkboxGroupInput(ns("sel_production"), "Select type of production",
                               choices = q_prod, selected = q_prod_sel,
                               width = "100%"))),
          column(width = 9, shiny::div(
            style = "width:100%; max-width:1000px;",
            selectizeInput(ns("sel_category"), "Select a category",
                           choices = q_cat, selected = q_cat_sel, multiple= FALSE,
                           width = "100%", size = 10),
            selectizeInput(ns("sel_question"), "Select a question",
                           choices = q_chs, selected = q_chs_sel, multiple= FALSE,
                           width = "100%", size = 10)))
        ),
        div(
          style = "background-color:white;",
        uiOutput(ns("summary_response_plot_title")),
        div(plotly::plotlyOutput(ns("summary_response_plot"), height = "100%"), align = "center")
        )
      )
    })
    
    question_production <- eventReactive(input$sel_production, {
      req(survey_data)

      non_na_cols <- survey_data() %>% 
        dplyr::filter(Q2.6 %in% input$sel_production) %>% 
        purrr::map_lgl(~ all(is.na(.)))
      
      non_na_cols <- names(non_na_cols[!non_na_cols])
      
      non_na_question <- non_na_cols %>% 
        stringr::str_sub(2, -1) %>% 
        purrr::map_chr(~ paste(stringr::str_split(., stringr::fixed("."))[[1]][1:2], collapse = ".")) %>% 
        unique()
      
      q <- question_info() %>% 
        dplyr::filter(section != 1) %>%
        dplyr::filter(question_lvl2_id != "2.1") %>% 
        dplyr::filter(question_lvl2_id %in% non_na_question) 
    })
    
    observeEvent(question_production(), {
      
      q_cat <- question_production() %>% 
        dplyr::distinct(section_title, section) %>% 
        dplyr::select(section_title, section) %>% # Re-order,because distinct doesn't
        tibble::deframe()
      
      if (input$sel_category %in% q_cat) { 
        # Keep the same category selected if available
        q_cat_sel <- input$sel_category
      } else {
        q_cat_sel <- q_cat[1]
      }
      
      updateSelectizeInput(session, "sel_category", choices = q_cat, selected = q_cat_sel)
    })
    
    observeEvent(input$sel_category, {
      
      q_chs <- question_production() %>% 
        dplyr::filter(section == input$sel_category) %>%
        dplyr::select(question_lvl2, question_lvl2_id) %>% 
        tibble::deframe()
      q_chs_sel <- q_chs[1]
      # q_chs <- question_production() %>% 
      #   dplyr::filter(section == input$sel_category) %>%
      #   dplyr::select(question, question_var) %>% 
      #   tibble::deframe()
      
      updateSelectizeInput(session, "sel_question", choices = q_chs, selected = q_chs_sel)
    })
    
    plot_data <- reactive({
      shiny::req(survey_data(), input$sel_production)
      survey_data <- dplyr::filter(survey_data(), Q2.6 %in% input$sel_production)
      # Avoid error message if selection process fails
      if (nrow(survey_data) == 0) { return(NULL) }
      survey_data
    })
    
    output$summary_response_plot_title <- renderUI({
      question_info() %>% 
        dplyr::filter(question_lvl2_id == input$sel_question) %>% 
        dplyr::pull(question_lvl2) %>% 
        h4(style = "text-align:left;") %>% 
        div(style = "width:100%;background-color:white;padding:20px 70px 20px; margin-bottom:-20px;")
    })
    
    output$summary_response_plot <- plotly::renderPlotly({
      shiny::req(plot_data(), input$sel_question)
      
      question_info_ <- dplyr::filter(question_info(), question_lvl2_id == input$sel_question) 
      # viz_type_ <- dplyr::filter(question_info(), question_lvl2_id == input$sel_question) %>% dplyr::pull(viz_type)
      question_      <- dplyr::filter(question(), question_lvl2_id == input$sel_question) 
      
      .data <- plot_data()[dplyr::filter(question(), question_lvl2_id == input$sel_question) %>% dplyr::pull(question_var)]
        
      plot_summary_response(.data, question_, question_info_)
        
      # ggplot2::ggplot(plot_data) +
      #   ggplot2::geom_bar(ggplot2::aes_string(x = input$sel_question, fill = input$sel_question),
      #                     show.legend = FALSE)
    })
    
    
  })
}