

# Module UI function
mod_biosecurity_evaluation_user_ui <- function(id) {
  ns <- shiny::NS(id)
  
  shiny::tagList(
    uiOutput(ns("module_ui")),
    if (Sys.getenv("BROWSE") == "TRUE") { shiny::actionButton(ns("browse"), "Browse")}
  )
}

# Module server function
mod_biosecurity_evaluation_user_server <- function(id, 
                                                   survey_data, 
                                                   growout, 
                                                   onland_hatchery, 
                                                   farms_geo,
                                                   settings) {
  shiny::moduleServer(id, function(input, output, session) {
    
    shiny::observeEvent(input$browse, { browser() })
    
    rv_user <- reactiveValues(user      = "guest", 
                              logged_in = FALSE,
                              email     = "",
                              locnr     = "",
                              timestamp = "")
    
    rv_group <- reactiveVal("")
    
    output$module_ui <- renderUI({
      ns <- session$ns
      
      if (!rv_user$logged_in) {
        uiOutput(ns("login_ui"))
      } else {
        tagList(
          uiOutput(ns("logout_ui")),
          uiOutput(ns("dashboard_ui"))
        )
      }
    })
    
    output$logout_ui <- renderUI({
      ns <- session$ns
      fluidRow(
        style = "margin-bottom:40px;",
        # column(width = 3, offset = 8, p(paste0("Welcome ", isolate(rv_user$email)))),
        column(width = 1, offset = 11, actionButton(ns("logout_btn"), "Logout")))
    })
    
    observeEvent(input$logout_btn, {
      rv_user$user      <- "guest"
      rv_user$email     <- ""
      rv_user$timestamp <- ""
      rv_user$locnr     <- ""
      rv_user$logged_in <- FALSE
    })
    
    
    output$login_ui <- renderUI({
      ns <- session$ns
      
      tagList(
        fluidRow(column(
          width = 6, offset = 3,
          box(
            width = 12, title = "Login",
            textInput(ns("email"), "Email"),
            passwordInput(ns("pw"), "Password"),
            actionButton(ns("login_btn"), "Login")
          )
        ))
      )
    })
    
    observeEvent(input$login_btn, {
      
      if (!input$email %in% survey_data()$Q1.3) {
        showModal(modalDialog(
          title = "Login failed",
          "Wrong email address or password"
        ))
        return(NULL)
      }
      
      if (FALSE) { # Check for password
        showModal(modalDialog(
          title = "Login failed",
          "Wrong email address or password"
        ))
        return(NULL)
      }
      
      usr <- dplyr::filter(survey_data(), Q1.3 == input$email)
      
      if (nrow(usr) > 1) {
        showModal(modalDialog(
          title = "Multiple records",
          "There are multiple records for your email address. The first one in the system is used."
        ))
        
        usr <- dplyr::slice(usr, 1)
      }
      
      rv_user$user      <- usr$Q1.1
      rv_user$email     <- usr$Q1.3
      rv_user$timestamp <- usr$Timestamp
      rv_user$locnr     <- usr$Q2.1
      rv_user$logged_in <- TRUE
      
    })
    
    data_full <- reactive({
      if (rv_group() == "onland_hatchery") {
        onland_hatchery()$stat_subgroup
      } else {
        growout()$stat_subgroup
      }
    })
    
    data <- reactive({
      req(rv_user$logged_in)
      req(onland_hatchery(), growout())
      
      if (rv_user$logged_in) {
        dt <- dplyr::filter(onland_hatchery()$stat_subgroup, level == "Farm", user_q1.1 == rv_user$user, user_timestamp == rv_user$timestamp)
        if (nrow(dt) > 0) {
          rv_group("onland_hatchery")
          dt <- dplyr::bind_rows(dt, dplyr::filter(onland_hatchery()$stat_subgroup, level == "Norway"))
        } else {
          dt <- dplyr::filter(growout()$stat_subgroup, level == "Farm", user_q1.1 == rv_user$user, user_timestamp == rv_user$timestamp)
          if (nrow(dt) > 0) {
            rv_group("growout")
            dt <- dplyr::bind_rows(dt, dplyr::filter(growout()$stat_subgroup, level == "Norway"))
          } else {
            showModal(modalDialog(
              title = "No records in analysed results",
              ""
            ))
            return(NULL)
          }
        }
      } else {
        return(NULL)
      }
      dt
    })
    
    stat_question <- reactive({
      if (rv_user$logged_in) {
        if (rv_group() == "onland_hatchery") {
          req(onland_hatchery())
          dt <- onland_hatchery()$stat_question %>% 
            dplyr::mutate(my_scoring = level == "Farm" & user_q1.1 == rv_user$user & user_timestamp == rv_user$timestamp)
        } else {
          req(growout())
          dt <- growout()$stat_question %>% 
            dplyr::mutate(my_scoring = level == "Farm" & user_q1.1 == rv_user$user & user_timestamp == rv_user$timestamp)
        }
      }
      dt
    })
    
    stat_subgroup <- reactive({
      if (rv_user$logged_in) {
        if (rv_group() == "onland_hatchery") {
          req(onland_hatchery())
          dt <- onland_hatchery()$stat_subgroup %>% 
            dplyr::mutate(my_scoring = level == "Farm" & user_q1.1 == rv_user$user & user_timestamp == rv_user$timestamp)
        } else {
          req(growout())
          dt <- growout()$stat_subgroup %>% 
            dplyr::mutate(my_scoring = level == "Farm" & user_q1.1 == rv_user$user & user_timestamp == rv_user$timestamp)
        }
      }
      dt
    })
    
    
    output$dashboard_ui <- renderUI({
      req(data(), stat_subgroup())
      ns <- session$ns
      
      sel_chcs_df <- data() %>% 
        dplyr::distinct(stat_group, stat_title, stat_subgroup) 
      st_gr <- unique(sel_chcs_df$stat_group)
      sel_chcs <- purrr::map(st_gr, function(st_gr_) {
        sel_chcs_df %>% 
          dplyr::filter(stat_group == st_gr_) %>% 
          dplyr::select(stat_title, stat_subgroup) %>% 
          tibble::deframe()
      })
      names(sel_chcs) <- stringr::str_to_title(st_gr)
      
      ss_opts <- stat_subgroup() %>% 
        dplyr::filter(stringr::str_sub(stat_subgroup, 1, 2) == "su") %>% 
        dplyr::select(stat_group, stat_title, stat_subgroup) %>% 
        dplyr::distinct() %>% 
        dplyr::mutate(stat_group = stringr::str_to_title(stat_group)) %>% 
        dplyr::group_by(stat_group) %>% 
        tidyr::nest() %>% 
        dplyr::mutate(data = purrr::map(data, tibble::deframe)) %>% 
        tibble::deframe()
        
      tagList(
        fluidRow(
          column(width = 5, leaflet::leafletOutput(ns("map"), height = 700)),
          column(
            width = 7, 
            uiOutput(ns("table_ui")),
            fluidRow(column(
              width = 12,
              div(style = "display:inline-block; float:right;",
                  downloadButton("dl_table", "PDF")))
            ))
        ),
        fluidRow(
          column(width = 6, plotly::plotlyOutput(ns("radial_ext"))),
          column(width = 6, plotly::plotlyOutput(ns("radial_int")))
        ),
        # plotly::plotlyOutput(ns("scatter_int_ext")),
        fluidRow(
          column(
            width = 6,
            selectInput(ns("scatter_cat_x_sel"), "Select X-axis category",
                        choices = sel_chcs, selected = rev(sel_chcs[[1]])[1])
          ),
          column(
            width = 6,
            selectInput(ns("scatter_cat_y_sel"), "Select Y-axis category",
                        choices = sel_chcs, selected = rev(sel_chcs[[2]])[1])
          )
        ),
        plotly::plotlyOutput(ns("scatter_sub_category")),
        div(style = "height:50px;"),
        selectInput(ns("ft_scoring_sel"),
                    label = NULL,
                    choices = ss_opts),
        uiOutput(ns("ft_scoring_ui"))
      )
    })
    
    output$table_ui <- renderUI({
      req(data())
      ns <- session$ns
      
      tagList(
        uiOutput(ns("ft_ui")),
        fluidRow(column(width = 10, div(
          style = "display:inline-block; float:right;",
          radioButtons(ns("table_graph"), NULL, inline = TRUE,
                       choices = c("Boxplot" = "boxplot", "Density" = "density")))))
      )
    })
    
    output$ft_ui <- renderUI({
      req(input$table_graph)
      generate_scoring_flextable(.data      = data(), 
                                 .data_full = data_full(), 
                                 user       = rv_user$user,
                                 timestamp  = rv_user$timestamp,
                                 graph      = input$table_graph,
                                 as_html    = TRUE)
    })
    

    

    output$radial_ext <- plotly::renderPlotly({ 
      plotly_radar(data(), internal_external = "external", show_legend = FALSE) 
    })
    output$radial_int <- plotly::renderPlotly({ 
      plotly_radar(data(), internal_external = "internal") 
    })
    

    output$scatter_sub_category <- plotly::renderPlotly({
      .data <- dplyr::filter(data_full(), level %in% c("Farm", "Norway"))
      
      plotly_category_scatter(
        .data       = .data,
        survey_data = data(),
        x_axis      = input$scatter_cat_x_sel,
        y_axis      = input$scatter_cat_y_sel,
        user        = rv_user$user,
        timestamp   = rv_user$timestamp)
      
    })
    
    output$map <- leaflet::renderLeaflet({
      
      lfl_provider <- settings()$lfl_provider
      
      user_loc_nr_ <- data() %>% 
        dplyr::filter(level == "Farm") %>% 
        dplyr::pull(user_loc_nr) %>% 
        unique()
      
      zone_colors <- data_full() %>% 
        dplyr::filter(level == "Zone") %>% 
        dplyr::filter(stat_subgroup == "total") %>% 
        dplyr::select(id = zone, value = score_perc)
      
      nw_zones <- nw_zones %>% 
        dplyr::mutate(id = as.character(id)) %>% 
        dplyr::left_join(zone_colors, by = "id") %>% 
        dplyr::mutate(color = purrr::map_chr(value, get_value_color))
      
      leaflet::leaflet() %>%
        leaflet::addProviderTiles(lfl_provider) %>% 
        leaflet::addPolygons(
          data = nw_zones, 
          color = "#444444", weight = 1, smoothFactor = 0.5,
          opacity = 1.0, fillOpacity = 0.5,
          fillColor = ~color) %>% 
        # On highlight only bring the outline to the front such that markers stay above the fill color
        leaflet::addPolygons(
          data = nw_zones,
          color = "#444444", weight = 1, smoothFactor = 0.5,
          opacity = 1.0, fillOpacity = 0,
          highlightOptions = leaflet::highlightOptions(
            color = "white", weight = 2, bringToFront = TRUE)) %>%
        leaflet::addCircleMarkers(
          data = farms_geo(),
          lng = ~lon, lat = ~lat,
          stroke = FALSE, radius = 1, 
          fillColor = "#FFF", fillOpacity = 0.85,
          popup = ~popup) %>% 
        leaflet::addCircleMarkers(
          data = dplyr::filter(farms_geo(), loc_nr == user_loc_nr_),
          lng = ~lon, lat = ~lat,
          stroke = FALSE, radius = 2, 
          fillColor = "#8b0000", fillOpacity = 0.85)
    })
    
    
    output$ft_scoring_ui <- renderUI({
      req(stat_question(), stat_subgroup(), input$ft_scoring_sel)
      
      stat_question <- stat_question()
      stat_subgroup <- stat_subgroup()
      
      opts <- stat_subgroup %>% 
        dplyr::filter(stringr::str_sub(stat_subgroup, 1, 2) == "su") %>% 
        dplyr::pull(stat_subgroup) %>% 
        unique()
      
      subgroup <- input$ft_scoring_sel
      
      hdrs <- c("col1" = "Question", 
                "col2" = "Answers", 
                "col3" = "Score")
      
      sg_score_text <- stat_subgroup %>% 
        dplyr::filter(stat_subgroup == subgroup, my_scoring) %>% 
        dplyr::transmute(text = paste0(round(score_raw, 1), "/", round(max_score_raw, 1), 
                                       " (", round(score_perc, 1), "%)")) %>% 
        dplyr::pull(text)
      
      ft_data <- stat_question %>% 
        dplyr::filter(stat_subgroup == subgroup, my_scoring) %>% 
        dplyr::mutate(score_text = paste0(round(score, 1), "/", round(max_score, 1))) %>% 
        dplyr::mutate(color = purrr::map_chr(score_perc, ~ get_value_color(., light_colors = TRUE))) %>% 
        dplyr::select(col1 = stat_question, 
                      col2 = answer, 
                      col3 = score_text,
                      color)
      
      flextable::flextable(ft_data, col_keys = c("col1", "col2", "col3")) %>% 
        flextable::delete_part(part = "header") %>% 
        flextable::add_header(values = hdrs) %>%
        flextable::add_footer(col1 = "Subcategory score", 
                              col3 = sg_score_text) %>% 
        flextable::width(1, 6) %>% 
        flextable::width(2, 2) %>% 
        flextable::width(3, 0.5) %>% 
        flextable::bold(i = 1, part = "header") %>% 
        flextable::bold(i = 1, part = "footer") %>% 
        flextable::bg(i = seq_len(nrow(ft_data)), bg = ft_data$color) %>% 
        flextable::htmltools_value()
      
    })
    
  })
}
