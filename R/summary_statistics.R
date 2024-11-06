



plot_summary_response <- function(.data, question, question_info) {
  
  pl <- NULL
  
  viz_type <- question_info$viz_type[1]
  
  if (viz_type == "date_list") {
    pl <- plotly::plot_ly() %>% 
      plotly::layout(title = list(text = "No graph available"))
  }
  if (viz_type == "bar") {
    if (question_info$question_type[1] == "ls_1_10") {
      x_axis <- list(title = "", range = c(0.5, 10.5), tickvals = 1:10)
      
      names(.data) <- "var"
      pl <- .data %>% 
        dplyr::count(var, name = "count") %>% 
        dplyr::mutate(text = paste0(count, "<br>(", round(100 * count / sum(count)), "%)")) %>% 
        plotly::plot_ly() %>% 
        plotly::add_bars(x = ~var, y = ~count,
                         text = ~text, textposition = 'auto') %>% 
        plotly::layout(
          title = list(text = paste(nrow(.data), "responses"),
                       font = list(size = 12),
                       xanchor = "left", x = 0.05),
          xaxis = x_axis,
          yaxis = list(title = ""))
    } else {
      x_axis <- list(title = "")
      
      names(.data) <- "var"
      pl_d <- .data %>% 
        dplyr::count(var, name = "count") %>% 
        dplyr::arrange(var) %>% 
        dplyr::mutate(var = as.character(var)) %>% 
        dplyr::mutate(text = paste0(count, "<br>(", round(100 * count / sum(count)), "%)"))
      pl <- plotly::plot_ly(pl_d) %>% 
        plotly::add_bars(x = ~var, y = ~count,
                         text = ~text, textposition = 'auto',
                         width = 0.7 / nrow(pl_d) * 10) %>% 
        plotly::layout(
          title = list(text = paste(nrow(.data), "responses"),
                       font = list(size = 12),
                       xanchor = "left", x = 0.05),
          xaxis = x_axis,
          yaxis = list(title = ""))
    }
    
  }
  if (viz_type == "bar_h") {
    names(.data) <- "var"
    pl_d <- .data %>% 
      dplyr::count(var, name = "count") %>% 
      dplyr::mutate(text = paste0(count, " (", round(100 * count / sum(count)), "%)"))
    
    n_scale <- nrow(pl_d) / 5
    n_width <- 0.7 * min(n_scale, 1)
    
    pl <- plotly::plot_ly(pl_d) %>% 
      plotly::add_bars(y = ~var, x = ~count,
                       text = ~text, textposition = 'auto',
                       orientation = "h",
                       width = n_width) %>% 
      plotly::layout(
        title = list(text = paste(nrow(.data), "responses"),
                     font = list(size = 12),
                     xanchor = "left", x = 0.05),
        xaxis = list(title = ""),
        yaxis = list(title = ""))
  }
  if (viz_type == "pie") {
    pl <- plotly::plot_ly() %>% 
      plotly::add_pie(labels = .data[[1]], values = rep(1, nrow(.data))) %>% 
      plotly::layout(
        title = list(text = paste(nrow(.data), "responses"),
                     font = list(size = 12),
                     xanchor = "left", x = 0.05))
  }
  if (viz_type == "x_bar_y_col") {
    
    # pl_d <- .data %>% 
    #   tidyr::pivot_longer(cols = dplyr::everything(), names_to = "question_var", values_to = "values") %>% 
    #   dplyr::left_join(dplyr::select(question, question_var, question_lvl2, answers_lvl3),
    #                    by = "question_var") %>%
    #   dplyr::mutate(answers_lvl3 = purrr::map_chr(answers_lvl3, ~ insert_string_break(., n_character = 10))) %>% 
    #   dplyr::group_by(answers_lvl3)
    # 
    # n_dis <- dplyr::distinct(pl_d, answers_lvl3, values) %>% nrow()
    # 
    # 
    # plotly::plot_ly(pl_d) %>% 
    #   # plotly::add_bars(x = ~answers_lvl3, split = ~values)
    #   plotly::add_histogram(x = ~answers_lvl3, split = ~values,
    #                         marker = list(line = list(width = 0.7 / n_dis * 10))) %>% 
    #   plotly::layout(
    #     legend = list(orientation = 'h', x = 0, y = 1.1), 
    #     xaxis = list(title = ""))
    
    pl_d <- .data %>% 
      tidyr::pivot_longer(cols = dplyr::everything(), names_to = "question_var", values_to = "values") %>% 
      dplyr::left_join(dplyr::select(question, question_var, question_lvl2, answers_lvl3),
                       by = "question_var") %>%
      dplyr::mutate(answers_lvl3 = purrr::map_chr(answers_lvl3, ~ insert_string_break(., n_character = 10))) %>% 
      dplyr::count(answers_lvl3, values, name = "count") %>% 
      dplyr::mutate(text = paste0(count, " (", round(100 * count / sum(count)), "%)"))
    
    n_bars  <- dplyr::n_distinct(pl_d$answers_lvl3) * dplyr::n_distinct(pl_d$values)
    n_width <- (0.7 / dplyr::n_distinct(pl_d$values)) * dplyr::if_else((n_bars / 10) > 1, 1, (n_bars / 10))
    
    pl <- plotly::plot_ly(pl_d) %>% 
      plotly::add_bars(x = ~answers_lvl3, y = ~count, split = ~values,
                       text = ~count, textposition = 'auto',
                       width = n_width) %>% 
      plotly::layout(
        legend = list(orientation = 'h', x = 0, y = 1.1), 
        xaxis = list(title = ""), yaxis = list(title = ""))
  }
  
  pl
}
