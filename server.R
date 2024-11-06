

server = function(input, output, session) { 
  
  shiny::observeEvent(input$browse, { browser() })
  
  language <- reactive({ "en" })
  settings <- reactive({ list(lfl_provider = lfl_provider_) })
  
  observeEvent(input$main_menu, {
    if (input$main_menu == "home") {
      if (input$sidebar) { updateSidebar("sidebar", session) }
    } else {
      if (!input$sidebar) { updateSidebar("sidebar", session) }
    }
  })
  
  observeEvent({
    input$sidebar
    !input$sidebar
  }, {
    if (input$sidebar) {
      updateActionButton(session = session, inputId = "refresh_btn", label = "Refresh data")
    } else {
      updateActionButton(session = session, inputId = "refresh_btn", label = "")
    }
  })
  
  # DATA #####
  
  datafile    <- reactive({ local_data_file })
  googlesheet <- reactive({ googlesheet_url })
  
  master_tables <- reactive({
    stat_subgroups_total_weights_growout           <- readRDS("input/stat_subgroups_total_weights_growout.Rds")
    stat_subgroups_int_ext_weights_growout         <- readRDS("input/stat_subgroups_int_ext_weights_growout.Rds")
    stat_subgroups_growout                         <- readRDS("input/stat_subgroups_growout.Rds")
    stat_questions_growout                         <- readRDS("input/stat_questions_growout.Rds")
    stat_subgroups_total_weights_onland_hatchery   <- readRDS("input/stat_subgroups_total_weights_onland_hatchery.Rds")
    stat_subgroups_int_ext_weights_onland_hatchery <- readRDS("input/stat_subgroups_int_ext_weights_onland_hatchery.Rds")
    stat_subgroups_onland_hatchery                 <- readRDS("input/stat_subgroups_onland_hatchery.Rds")
    stat_questions_onland_hatchery                 <- readRDS("input/stat_questions_onland_hatchery.Rds")
    
    list(stat_subgroups_total_weights_growout           = stat_subgroups_total_weights_growout,
         stat_subgroups_int_ext_weights_growout         = stat_subgroups_int_ext_weights_growout,
         stat_subgroups_growout                         = stat_subgroups_growout,
         stat_questions_growout                         = stat_questions_growout,
         stat_subgroups_total_weights_onland_hatchery   = stat_subgroups_total_weights_onland_hatchery,
         stat_subgroups_int_ext_weights_onland_hatchery = stat_subgroups_int_ext_weights_onland_hatchery,
         stat_subgroups_onland_hatchery                 = stat_subgroups_onland_hatchery,
         stat_questions_onland_hatchery                 = stat_questions_onland_hatchery)
  })
  
  question_info <- reactive({
    req(question())
    question_info_ %>% 
      dplyr::left_join(
        question() %>% 
          dplyr::select(question_lvl2_id, question_lvl2, section, section_title) %>% 
          dplyr::distinct(question_lvl2_id, .keep_all = TRUE),
        by = "question_lvl2_id")
  })
  
  question <- reactive({
    input$refresh_btn
    if (Sys.getenv("LOCAL_DATA") == "FALSE") {
      xl <- googlesheets4::read_sheet(googlesheet(), sheet = "Form Responses 1", n_max = 0) %>% 
        handle_duplicate_googlsheet_names()
    } else {
      xl <- readxl::read_excel(datafile(), sheet = "Form Responses 1", n_max = 0)
    }
    xl %>% 
      dplyr::select(-Timestamp) %>% 
      names() %>% 
      tibble::tibble(question = .) %>% 
      dplyr::mutate(question_id = stringr::word(question, 1)) %>% 
      # Fix typos, like '17.2.'
      dplyr::mutate(question_id = dplyr::if_else(!stringr::str_sub(question_id, -1, -1) %in% as.character(0:9),
                                                 stringr::str_sub(question_id, 1, -2), question_id)) %>% 
      dplyr::mutate(section = stringr::word(question, 1, sep = stringr::fixed("."))) %>% 
      dplyr::group_by(question_id) %>% 
      dplyr::mutate(names_n = dplyr::n()) %>% 
      dplyr::mutate(name_extra = as.character(seq_len(dplyr::n()))) %>% 
      dplyr::ungroup() %>% 
      dplyr::mutate(question_id  = dplyr::if_else(names_n == 1, question_id, paste0(question_id, ".", name_extra))) %>% 
      dplyr::mutate(question_var = paste0("Q", question_id)) %>% 
      dplyr::select(question, question_var, question_id, section) %>% 
      dplyr::left_join(
        dplyr::select(question_sections_all, section, section_title = section_title_nw),
        by = "section") %>% 
      dplyr::mutate(question_lvl2    = purrr::map_chr(question, ~ stringr::str_split(., stringr::fixed(" ["))[[1]][1])) %>% 
      dplyr::mutate(question_lvl2_id = purrr::map_chr(question, ~ stringr::str_split(., " ")[[1]][1])) %>% 
      dplyr::mutate(answers_lvl3 = purrr::map_chr(question, ~ stringr::str_sub(stringr::str_split(., stringr::fixed(" ["))[[1]][2], 1, -2)))
  })
  
  survey_data <- reactive({
    req(question())
    input$refresh_btn
    if (Sys.getenv("LOCAL_DATA") == "FALSE") {
      survey_data <- googlesheets4::read_sheet(googlesheet(), sheet = "Form Responses 1") %>% 
        handle_duplicate_googlsheet_names()
    } else {
      survey_data <- readxl::read_excel(datafile(), sheet = "Form Responses 1")
    }
    
    names(survey_data)[-1] <- question()$question_var
    
    survey_data
  })
  
  farms_active <- reactive({
    if (Sys.getenv("LOCAL_GIS_FISKERIDIR") == "TRUE") {
      readRDS("input/lokaliter_local.Rds") %>% dplyr::select(loc_nr)
    } else {
      get_lokaliter(vars = c("loc_nr" = "loknr"), types = "c")
    }
  })
  
  farms_geo <- reactive({
    farms_all <- readr::read_table2("input/sonetilhorighet.txt", 
                                    locale = readr::locale(decimal_mark = ",")) %>% 
      dplyr::mutate_if(is.character, ~ gsub('"', '', .))
    names(farms_all) <- c("loc_nr", "zone", "east_utm", "north_utm", "lon", "lat")
    
    farms_geo <- farms_active() %>% 
      dplyr::left_join(farms_all, by = "loc_nr") %>% 
      dplyr::mutate(popup = paste0("Loc nr: ", loc_nr, "<br>Zone: ", zone)) %>% 
      dplyr::select(loc_nr, zone, lon, lat, popup)
    farms_geo
  })
  
  # # Quickrun for debugging
  # survey_data   = survey_data()
  # question      = question()
  # farms_geo     = farms_geo()
  # type          = "growout"
  # language      = language()

  growout <- reactive({ 
    req(survey_data())
    calculate_stats(survey_data   = survey_data(), 
                    question      = question(),
                    master_tables = master_tables(),
                    farms_geo     = farms_geo(),
                    type          = "growout",
                    language      = language())
  })
  
  onland_hatchery <- reactive({ 
    req(survey_data())
    calculate_stats(survey_data     = survey_data(), 
                    question        = question(),
                    master_tables   = master_tables(),
                    farms_geo       = farms_geo(),
                    type            = "onland_hatchery",
                    production_type = "all",
                    language        = language())
  })
  
  onland_hatchery_s <- reactive({
    req(survey_data())
    calculate_stats(survey_data     = survey_data(),
                    question        = question(),
                    master_tables   = master_tables(),
                    farms_geo       = farms_geo(),
                    type            = "onland_hatchery",
                    production_type = "settefisk",
                    language        = language())
  })
  
  onland_hatchery_r <- reactive({
    req(survey_data())
    calculate_stats(survey_data     = survey_data(),
                    question        = question(),
                    master_tables   = master_tables(),
                    farms_geo       = farms_geo(),
                    type            = "onland_hatchery",
                    production_type = "rogn",
                    language        = language())
  })
  
  onland_hatchery_p <- reactive({
    req(survey_data())
    calculate_stats(survey_data     = survey_data(),
                    question        = question(),
                    master_tables   = master_tables(),
                    farms_geo       = farms_geo(),
                    type            = "onland_hatchery",
                    production_type = "postsmolt",
                    language        = language())
  })
  
  onland_hatchery_sr <- reactive({
    req(survey_data())
    calculate_stats(survey_data     = survey_data(),
                    question        = question(),
                    master_tables   = master_tables(),
                    farms_geo       = farms_geo(),
                    type            = "onland_hatchery",
                    production_type = c("settefisk", "rogn"),
                    language        = language())
  })
  
  onland_hatchery_rp <- reactive({
    req(survey_data())
    calculate_stats(survey_data     = survey_data(),
                    question        = question(),
                    master_tables   = master_tables(),
                    farms_geo       = farms_geo(),
                    type            = "onland_hatchery",
                    production_type = c("rogn", "postsmolt"),
                    language        = language())
  })
  
  onland_hatchery_sp <- reactive({
    req(survey_data())
    calculate_stats(survey_data     = survey_data(),
                    question        = question(),
                    master_tables   = master_tables(),
                    farms_geo       = farms_geo(),
                    type            = "onland_hatchery",
                    production_type = c("settefisk", "postsmolt"),
                    language        = language())
  })
  
  
  
  #####
  # MODULES #####
  
  mod_home_server("home")
  
  mod_what_is_biosecurity_server("what_is_biosecurity")
  
  mod_summary_statistics_server(
    id            = "summary_statistics",
    survey_data   = survey_data,
    question      = question,
    question_info = question_info)
  
  mod_risk_factors_server(
    id          = "risk_factors",
    survey_data = survey_data)
  
  mod_biosecurity_evaluation_server(
    id                 = "biosecurity_evaluation", 
    parent             = session, 
    survey_data        = survey_data,
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
  
  #####
}
