

# Module UI function
mod_biosecurity_evaluation_norway_ui <- function(id) {
  ns <- shiny::NS(id)
  
  shiny::tagList(
    div(
      style = "margin:20px auto; width:100%; max-width:900px;",
      p(style = "text-align:center;margin-bottom:15px;",
        "Here you can find the  biosecurity averages based on all surveys. These statistics are divided by production type."),
      fluidRow(
        column(width = 6, offset = 1, div(
          style = "width:200px; margin: auto;",
          selectInput(ns("sel_production"), "Select type of production",
                      choices = c("Hatchery" = "hatchery", "On-growing" = "on_growing"),
                      width = "100%")
        )),
        column(width = 5, div(
          style = "width:250px; margin: auto;",
          uiOutput(ns("sel_hatchery_type_ui"))
        ))
      )
    ),
    hr(style = "margin:10px 0;"),
    uiOutput(ns("gauge_ui")),
    hr(style = "margin:10px 0;"),
    uiOutput(ns("viz_ui")),
    if (Sys.getenv("BROWSE") == "TRUE") { shiny::actionButton(ns("browse"), "Browse")}
  )
}

# Module server function
mod_biosecurity_evaluation_norway_server <- function(id, 
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
    
    output$sel_hatchery_type_ui <- renderUI({
      ns <- session$ns
      
      if (input$sel_production == 'hatchery') {
        checkboxGroupInput(ns("sel_hatchery_type"),
                           "Filter Hatchery subset",
                           choices = c("settefisk", "rogn", "postsmolt"),
                           selected = c("settefisk", "rogn", "postsmolt"),
                           inline = TRUE)
      } else { NULL }
    })
    
    data <- reactive({
      req(input$sel_production)
      if (input$sel_production == "on_growing") {
        # if (TRUE) {
          
        req(growout())
        rtn <- growout()$stat_subgroup
      } else {
        req(onland_hatchery()) #, input$sel_hatchery_type)
        sht <- sort(input$sel_hatchery_type)
        if (length(sht) == 3) {
          rtn <- onland_hatchery()$stat_subgroup
        } else if (all(sht == c("postsmolt", "settefisk"))) {
          rtn <- onland_hatchery_sp()$stat_subgroup
        } else if (all(sht == c("rogn", "settefisk"))) {
          rtn <- onland_hatchery_sr()$stat_subgroup
        } else if (all(sht == c("postsmolt", "rogn"))) {
          rtn <- onland_hatchery_rp()$stat_subgroup
        } else if (all(sht == c("settefisk"))) {
          rtn <- onland_hatchery_s()$stat_subgroup
        } else if (all(sht == c("rogn"))) {
          rtn <- onland_hatchery_r()$stat_subgroup
        } else if (all(sht == c("postsmolt"))) {
          rtn <- onland_hatchery_p()$stat_subgroup
        } else {
          rtn <- onland_hatchery()$stat_subgroup
        }
      }
      rtn
    })
    
    data_norway <- reactive({
      req(data())
      dplyr::filter(data(), level == "Norway")
    })
    
    output$gauge_ui <- renderUI({
      ns <- session$ns
      
      tagList(
        div(
          style = "max-width:900px; width:100%; margin:0 auto;",
          fluidRow(
            column(width = 4, plotly::plotlyOutput(ns("overall_biosecurity_plotly"), height = "250px")),
            column(width = 4, plotly::plotlyOutput(ns("external_biosecurity_plotly"), height = "250px")),
            column(width = 4, plotly::plotlyOutput(ns("internal_biosecurity_plotly"), height = "250px"))
          )
        )
      )
    })
    
    output$overall_biosecurity_plotly <- plotly::renderPlotly({
      req(data_norway())
      data_norway() %>% 
        dplyr::filter(stat_subgroup == "total") %>% 
        dplyr::pull(score_perc) %>% 
        plotly_gauge(title = "Overall biosecurity", value = .)
    })
    output$external_biosecurity_plotly <- plotly::renderPlotly({
      req(data_norway())
      data_norway() %>% 
        dplyr::filter(stat_subgroup == "ext") %>% 
        dplyr::pull(score_perc) %>% 
        plotly_gauge(title = "External biosecurity", value = .)
    })
    output$internal_biosecurity_plotly <- plotly::renderPlotly({
      req(data_norway())
      data_norway() %>% 
        dplyr::filter(stat_subgroup == "int") %>% 
        dplyr::pull(score_perc) %>% 
        plotly_gauge(title = "Internal biosecurity", value = .)
    })
    
    
    output$viz_ui <- renderUI({
      req(data_norway())
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
      
      tagList(
        
        fluidRow(
          column(width = 5, leaflet::leafletOutput(ns("map"), height = 700)),
          column(
            width = 7, 
            uiOutput(ns("ft_ui")), 
            div(id = ns("insert_table")),
            fluidRow(column(width = 10, div(
              style = "display:inline-block; float:right;",
              radioButtons(ns("table_graph"), NULL, inline = TRUE,
                           choices = c("Boxplot" = "boxplot", "Density" = "density"))))))
        ),
        hr(style = "margin:30px 0;"),
        fluidRow(
          column(width = 6, plotly::plotlyOutput(ns("radial_ext"))),
          column(width = 6, plotly::plotlyOutput(ns("radial_int")))
        ),
        hr(style = "margin:30px 0;"),
        fluidRow(
          column(
            width = 6,
            div(style = "width:300px; margin-left: auto;",
            selectInput(ns("scatter_cat_x_sel"), "Select X-axis category",
                        choices = sel_chcs, selected = rev(sel_chcs[[1]])[1],
                        width = "100%"))
          ),
          column(
            width = 6,
            div(style = "width:300px;",
            selectInput(ns("scatter_cat_y_sel"), "Select Y-axis category",
                        choices = sel_chcs, selected = rev(sel_chcs[[2]])[1]))
          )
        ),
        plotly::plotlyOutput(ns("scatter_sub_category"))
      )
    })
    
    # ft <- reactive({
    #   req(input$table_graph)
    #   
    #   generate_scoring_flextable(
    #     data_norway(), 
    #     .data_full = data(), 
    #     graph = input$table_graph,
    #     as_html = TRUE) 
    # })
    
    output$ft_ui <- renderUI({ 
      req(input$table_graph)
      generate_scoring_flextable(
        .data      = data_norway(), 
        .data_full = dplyr::filter(data(), level %in% c("Farm", "Norway")), 
        graph      = input$table_graph,
        as_html    = TRUE) 
    })
    
    output$radial_ext <- plotly::renderPlotly({ 
      plotly_radar(data_norway(), internal_external = "external", show_legend = FALSE) 
    })
    output$radial_int <- plotly::renderPlotly({ 
      plotly_radar(data_norway(), internal_external = "internal") 
    })
    
    output$scatter_sub_category <- plotly::renderPlotly({
      
      plotly_category_scatter(
        .data       = dplyr::filter(data(), level %in% c("Farm", "Norway")),
        survey_data = data_norway(),
        x_axis      = input$scatter_cat_x_sel,
        y_axis      = input$scatter_cat_y_sel,
        user        = NULL,
        timestamp   = NULL)
    })
    
    
    output$map <- leaflet::renderLeaflet({
      
      lfl_provider <- settings()$lfl_provider
      
      zone_colors <- data() %>% 
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
          popup = ~popup)
    })
    
    
  })
}
