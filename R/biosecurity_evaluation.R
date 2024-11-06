

#' Generate scoring Flextable
#'
#' @param .data 
#'
#' @return
#' @export
#'
#' @examples
generate_scoring_flextable <- function(.data, .data_full, 
                                       user = "", timestamp = lubridate::now(), 
                                       graph = "boxplot", as_html = FALSE) {
  
  data_gg <- .data_full %>% 
    dplyr::mutate(hl = dplyr::case_when(
      user_q1.1 == "norway_average" ~ "norway",
      user_q1.1 == user & user_timestamp == timestamp ~ "my_score",
      TRUE ~ "other")) %>% 
    dplyr::select(stat_subgroup, score_perc, hl) %>% 
    dplyr::group_by(stat_subgroup) %>% 
    tidyr::nest() %>% 
    dplyr::ungroup()
  
  if (!as_html) {
    if (graph == "boxplot") {
      data_gg <- data_gg %>%
        dplyr::mutate(gg = purrr::map2(data, stat_subgroup, function(dt, st) {
          dt_ms <- dt %>% dplyr::mutate(y = 1) %>% dplyr::filter(hl == "my_score")
          
          ggplot2::ggplot(dplyr::filter(dt, hl != "norway")) +
            # ggplot2::geom_point(ggplot2::aes(x = score_perc, y = 1, col = hl)) +
            ggplot2::geom_boxplot(ggplot2::aes(x = score_perc, y = 1)) +
            # ggplot2::geom_point(
            #   data = dt_ms,
            #   ggplot2::aes(x = score_perc, y = y, col = hl),
            #   shape = 21, size = 10) +
            ggplot2::geom_vline(
              data = dt_ms,
              ggplot2::aes(xintercept = score_perc, col = hl),
              linetype = 1, size = 1) +
            ggplot2::scale_color_manual(guide = "none",
                                        values = c("norway" = "darkblue",
                                                   "my_score" = "darkred",
                                                   "other" = "black")) +
            ggplot2::scale_x_continuous(limits = c(0, 100), expand = c(0, 0)) +
            ggplot2::theme_void()
        }))
    } else if (graph == "density") {
      data_gg <- data_gg %>%
        dplyr::mutate(gg = purrr::map2(data, stat_subgroup, function(dt, st) {
          dt_ms <- dt %>% dplyr::mutate(y = 1) %>% dplyr::filter(hl == "my_score")
          dt_nw <- dt %>% dplyr::mutate(y = 1) %>% dplyr::filter(hl == "norway")
          
          ggplot2::ggplot(dplyr::filter(dt, hl != "norway")) +
            # ggplot2::geom_point(ggplot2::aes(x = score_perc, y = 1, col = hl)) +
            ggplot2::geom_density(ggplot2::aes(x = score_perc, y = ..density..),
                                  fill = "#dedede") +
            # ggplot2::geom_point(
            #   data = dt_ms,
            #   ggplot2::aes(x = score_perc, y = y, col = hl),
            #   shape = 21, size = 10) +
            ggplot2::geom_vline(
              data = dt_nw,
              ggplot2::aes(xintercept = score_perc), col = "darkblue",
              linetype = 1, size = 1) +
            ggplot2::geom_vline(
              data = dt_ms,
              ggplot2::aes(xintercept = score_perc), col = "darkred",
              linetype = 1, size = 1) +
            ggplot2::scale_color_manual(guide = "none",
                                        values = c("norway" = "darkblue",
                                                   "my_score" = "darkred",
                                                   "other" = "black")) +
            ggplot2::scale_x_continuous(limits = c(0, 100), expand = c(0, 0)) +
            ggplot2::theme_void()
        }))
    } else {
      data_gg$gg <- list(NULL)
    }
  } else {
    
    img_ts <- gsub('[^0-9\\s]','',lubridate::now())
    # delete everything inside the folder, but keep the folder empty
    unlink(file.path("www", "img_ft", "*"), recursive = TRUE, force = TRUE)
    
    if (graph == "boxplot") {
      data_gg <- data_gg %>%
        dplyr::mutate(gg = purrr::map2_chr(data, stat_subgroup, function(dt, st) {
          dt_ms <- dt %>% dplyr::mutate(y = 1) %>% dplyr::filter(hl == "my_score")
          
          gg <- ggplot2::ggplot(dplyr::filter(dt, hl != "norway")) +
            # ggplot2::geom_point(ggplot2::aes(x = score_perc, y = 1, col = hl)) +
            ggplot2::geom_boxplot(ggplot2::aes(x = score_perc, y = 1)) +
            # ggplot2::geom_point(
            #   data = dt_ms,
            #   ggplot2::aes(x = score_perc, y = y, col = hl),
            #   shape = 21, size = 10) +
            ggplot2::geom_vline(
              data = dt_ms,
              ggplot2::aes(xintercept = score_perc, col = hl),
              linetype = 1, size = 1) +
            ggplot2::scale_color_manual(guide = "none",
                                        values = c("norway" = "darkblue",
                                                   "my_score" = "darkred",
                                                   "other" = "black")) +
            ggplot2::scale_x_continuous(limits = c(0, 100), expand = c(0, 0)) +
            ggplot2::theme_void()
          
          fp <- file.path("img_ft", paste0(st, img_ts, ".png"))
          # unlink(file.path("www", fp))
          ggplot2::ggsave(file.path("www", fp), gg, width = 1, height = 0.15)
          
          fp
        }))
    } else if (graph == "density") {
      data_gg <- data_gg %>%
        dplyr::mutate(gg = purrr::map2_chr(data, stat_subgroup, function(dt, st) {
          dt_ms <- dt %>% dplyr::mutate(y = 1) %>% dplyr::filter(hl == "my_score")
          dt_nw <- dt %>% dplyr::mutate(y = 1) %>% dplyr::filter(hl == "norway")
          
          gg <- ggplot2::ggplot(dplyr::filter(dt, hl != "norway")) +
            # ggplot2::geom_point(ggplot2::aes(x = score_perc, y = 1, col = hl)) +
            ggplot2::geom_density(ggplot2::aes(x = score_perc, y = ..density..),
                                  fill = "#dedede") +
            # ggplot2::geom_point(
            #   data = dt_ms,
            #   ggplot2::aes(x = score_perc, y = y, col = hl),
            #   shape = 21, size = 10) +
            ggplot2::geom_vline(
              data = dt_nw,
              ggplot2::aes(xintercept = score_perc), col = "darkblue",
              linetype = 1, size = 1) +
            ggplot2::geom_vline(
              data = dt_ms,
              ggplot2::aes(xintercept = score_perc), col = "darkred",
              linetype = 1, size = 1) +
            ggplot2::scale_color_manual(guide = "none",
                                        values = c("norway" = "darkblue",
                                                   "my_score" = "darkred",
                                                   "other" = "black")) +
            ggplot2::scale_x_continuous(limits = c(0, 100), expand = c(0, 0)) +
            ggplot2::theme_void()
          
          fp <- file.path("img_ft", paste0(st, img_ts, ".png"))
          # unlink(file.path("www", fp))
          ggplot2::ggsave(file.path("www", fp), gg, width = 1, height = 0.15)
          
          fp
        }))
    } else {
      data_gg$gg <- ""
    }
  }
  
  data_gg <- dplyr::select(data_gg, -data)
  
  ####
  
  n_grps <- dplyr::n_distinct(.data$user_timestamp)
  
  if (n_grps > 2) { return(NULL) }
  
  .data <- dplyr::mutate(.data, score_perc = dplyr::if_else(is.na(score_perc), "", paste0(round(score_perc, 1), "%"))) 
  
  if (n_grps == 2) {
    .data <- .data %>% 
      dplyr::mutate(pivot = dplyr::if_else(user_q1.1 == "norway_average", "value", "value_user")) %>%
      dplyr::select(stat_subgroup, stat_group, stat_title, score_perc, pivot) %>% 
      tidyr::pivot_wider(names_from = pivot, values_from = score_perc)
  }
  
  .data <- dplyr::left_join(.data, data_gg, by = "stat_subgroup")
  
  .data <- tibble::add_row(.data, stat_group = "external", stat_title = "External Biosecurity", .before = which(.data$stat_group == "external")[1])
  .data <- tibble::add_row(.data, stat_group = "internal", stat_title = "Internal Biosecurity", .before = which(.data$stat_group == "internal")[1])
  .data <- tibble::add_row(.data, stat_group = "total", stat_title = "Overall Biosecurity", .before = which(.data$stat_group == "total")[1])
  
  hl_ex <- which(.data$stat_group == "external")[1]
  hl_in <- which(.data$stat_group == "internal")[1]
  hl_tt <- which(.data$stat_group == "total")[1]
  
  hl <- c(which(.data$stat_group == "external")[1],
          which(.data$stat_group == "internal")[1],
          which(.data$stat_group == "total")[1])
  
  bl <- c(dplyr::last(which(.data$stat_group == "external")),
          dplyr::last(which(.data$stat_group == "internal")),
          dplyr::last(which(.data$stat_group == "total")))
  
  if (n_grps == 2) {
    .data <- .data %>% dplyr::select(stat_title, value_user, value, gg)
    value_cols <- 2:3
    max_col    <- 4
    headers    <- c("value" = "Average for Norway", 
                    "value_user" = "My scoring", 
                    "gg" = stringr::str_to_title(graph))
  } else {
    .data <- .data %>% dplyr::select(stat_title, score_perc, gg)
    value_cols <- 2
    max_col    <- 3
    headers    <- c("score_perc" = "Average for Norway", 
                    "gg" = stringr::str_to_title(graph))
  }
  
  # file.path("www", .data$gg)
  
  
  ft <- flextable::flextable(.data)
  
  if (!as_html) {
    ft <- ft %>% 
      flextable::compose(
        j = "gg",
        value = flextable::as_paragraph(flextable::gg_chunk(
          value = ., height = 0.15, width = 1)),
        use_dot = TRUE)
    # flextable::compose(
    #   j = "gg",
    #   value = flextable::as_paragraph(flextable::as_image(
    #     src = .data$gg, width = 1, height = 0.15))) %>%
  }
  
  ft <- ft %>% 
    flextable::width(1, 4) %>% 
    flextable::width(value_cols, 1) %>% 
    flextable::width(max_col, 1) %>% 
    flextable::delete_part(part = "header") %>% 
    flextable::merge_h_range(i = hl, j1 = 1, j2 = max_col) %>% 
    flextable::align(i = hl, align = "center") %>% 
    flextable::align(j = value_cols, align = "right") %>% 
    flextable::italic(i = hl) %>% 
    flextable::bg(i = hl_ex, bg = "#C5E0B4") %>% 
    flextable::bg(i = hl_in, bg = "#C5E0B4") %>% 
    flextable::bg(i = hl_tt, bg = "#C5E0B4") %>% 
    flextable::bold(i = bl) %>% 
    flextable::border_remove() %>% 
    flextable::add_header(values = headers) %>% 
    flextable::align(part = "header", j = c(value_cols, max_col), align = "right")
  
  if (as_html) {
    ft_html <- ft %>%
      flextable::htmltools_value() %>% 
      as.character()
    
    img_fls <- data_gg %>% 
      dplyr::filter(!is.na(gg)) %>% 
      dplyr::pull(gg) 
    
    for (img_fl in img_fls) {
      ft_html <- gsub(
      pattern     = img_fl, 
      replacement = paste0('<img style=',
                           '"vertical-align:middle;width:72pt;height:11pt;" ',
                           'src="', img_fl, '">'), 
      x           = ft_html)
    }
    
    ft <- HTML(ft_html)
  }
  
  ft
}

#' Get value color
#' 
#' Get the color related to a value
#'
#' @param value 
#' @param lower_value 
#' @param upper_value 
#' @param color_low 
#' @param color_middle 
#' @param color_high 
#'
#' @return
#' @export
#'
#' @examples
get_value_color <- function(value, 
                            lower_value  = 30, 
                            upper_value  = 70,
                            color_low    = "#8b0000",
                            color_middle = "#FFFF00",
                            color_high   = "#006400",
                            color_na     = "#cdcdcd",
                            light_colors = FALSE) {
  
  if (light_colors) {
    color_low    <- "#ffcccb"
    color_middle <- "#FFFFE0"
    color_high   <- "#90EE90"
    color_na     <- "#EEEEEE"
  }
  
  dplyr::case_when(
    value < 30   ~ color_low,
    value < 70   ~ color_middle,
    is.na(value) ~ color_na,
    TRUE         ~ color_high)
  
}

#' Plotly Gauge 
#'
#' @param title 
#' @param value 
#'
#' @return
#' @export
#'
#' @examples
plotly_gauge <- function(title, value) {
  
  color_bar <- get_value_color(value)
  
  plotly::plot_ly(
    domain = list(x = c(0, 1), y = c(0, 1)),
    value = value,
    number = list(suffix = "%", font = list(color = "#343434")),
    title = list(text = title),
    type = "indicator",
    mode = "gauge+number",
    gauge = list(
      axis = list(range = list(NULL, 100),
                  tickvals = list(0, 30, 50, 70, 100)),
      bar  = list(color = color_bar, line = list(color = "#343434", width = 1)),
      steps = list(
        list(range = c(0, 30), color = "#ffeded"),
        list(range = c(30, 70), color = "#ffffed"),
        list(range = c(70, 100), color = "#d1fdbf"))#,
      # threshold = list(
      #   line = list(color = "yellow", width = 6),
      #   thickness = 0.75,
      #   value = 66)
    )
  ) %>%
    plotly::layout(margin = list(l=20,r=30))
}



#' Plotly radar chart
#'
#' @param .data 
#' @param internal_external 
#' @param break_strings 
#' @param show_legend 
#'
#' @return
#' @export
#'
#' @examples
plotly_radar <- function(.data, internal_external = "external", break_strings = 15, show_legend = TRUE) {
  
  # https://stackoverflow.com/questions/55652449/r-plotly-polar-chart-simple-customizing
  
  ttl <- dplyr::if_else(internal_external == "external",
                        "External biosecurity",
                        "Internal biosecurity")
  
  .data$value <- .data$score_perc
  
  data_sub <- .data %>% 
    dplyr::filter(stat_group == internal_external, 
                  stat_subgroup != stringr::str_sub(internal_external, 1, 3)) %>% 
    dplyr::mutate(value_chr = paste0(round(value, 1), "%")) %>% 
    dplyr::mutate(stat_title_brk = purrr::map_chr(stat_title, function(st) {
      insert_string_break(string = st, n_character = break_strings)
      # if (nchar(st) > break_strings) {
      #   loc <- stringr::str_locate_all(st, " ")[[1]][,1]
      #   loc <- loc[which.min(abs(loc - nchar(st) / 2))]
      #   st <- paste0(stringr::str_sub(st, 1, loc - 1), "<br>", stringr::str_sub(st, loc + 1, -1))
      # }
      # st
    }))
  
  data_nw <- dplyr::filter(data_sub, user_q1.1 == "norway_average")
  data_nw <- dplyr::bind_rows(data_nw, dplyr::slice(data_nw, 1))
  
  data_user <- dplyr::filter(data_sub, user_q1.1 != "norway_average")
  data_user <- dplyr::bind_rows(data_user, dplyr::slice(data_user, 1))
  
  m <- list(
    l = 100,
    r = 100,
    b = 50,
    t = 100,
    pad = 20
  )
  
  plotly::plot_ly(type = 'scatterpolar', fill = 'toself', mode = "markers+lines") %>%
    plotly::add_trace(data = data_nw,
                      r = ~value, theta = ~stat_title_brk,
                      marker = list(size = 1, color = "darkblue"),
                      lines = list(color = "darkblue", opacity = 1),
                      fillcolor = paste0('rgba(', paste(col2rgb("darkblue"), collapse = ", "), ', 0.6)'),
                      text = ~value_chr, hoverinfo = "text",
                      name = 'Average for Norway') %>%
    plotly::add_trace(data = data_user,
                      r = ~value, theta = ~stat_title_brk,
                      marker = list(size = 1, color = "darkred"),
                      lines = list(color = "darkred"),
                      fillcolor = paste0('rgba(', paste(col2rgb("darkred"), collapse = ", "), ', 0.6)'),
                      text = ~value_chr, hoverinfo = "text",
                      name = 'My score') %>%
    plotly::layout(
      margin = m,
      title = ttl,
      showlegend = show_legend,
      polar = list(
        radialaxis = list(
          # ticks = "inside",
          ticklabelposition = "inside",
          angle = 35,
          tickangle = 35,
          tickvals = c(20, 40, 60, 80, 100),
          ticktext = paste0(" ", c("20", "40", "60", "80", "100")),
          showline = FALSE,
          ticklen = 0, #tickcolor = plotly::toRGB("#666666"),
          color = "#888888",
          gridcolor = '#999999',
          visible = TRUE,
          range = c(0, 100)
        )),
      legend = list(orientation = "h",   # show entries horizontally
                    xanchor = "right",  # use center of legend as anchor
                    x = 1))
}




#' Plotting category scatter
#'
#' @param .data onland_hatchery or growout results dataframe
#' @param survey_data 
#' @param x_axis 
#' @param y_axis 
#' @param user 
#' @param timestamp 
#'
#' @return
#' @export
#'
#' @examples
plotly_category_scatter <- function(.data, survey_data, x_axis, y_axis, user = NULL, timestamp = NULL) {
  
  lookup <- survey_data %>% 
    dplyr::distinct(stat_title, stat_subgroup) %>% 
    dplyr::select(stat_subgroup, stat_title) %>% 
    tibble::deframe()
  
  .data$value <- .data$score_perc
  survey_data$value <- survey_data$score_perc
  
  if (is.null(user) | is.null(timestamp)) {
    .data <- .data %>% 
      dplyr::mutate(hl = dplyr::if_else(level == "Norway", "Norway Average", ""))
    hl_color <- "darkblue"
  } else {
    .data <- .data %>% 
      dplyr::filter(level == "Farm") %>%
      dplyr::mutate(hl = dplyr::if_else(user_q1.1 == user & user_timestamp == timestamp, "My score", ""))
    hl_color <- "darkred"
  }
  
  # Bind rows with coord = x/y such that the same category can be on both axes
  .data <- dplyr::bind_rows(
    .data %>% 
      dplyr::filter(stat_subgroup == x_axis) %>%
      dplyr::mutate(coord = "x"),
    .data %>% 
      dplyr::filter(stat_subgroup == y_axis) %>%
      dplyr::mutate(coord = "y")) %>% 
    tidyr::pivot_wider(id_cols = c(value, user_q1.1, user_timestamp, hl),
                       names_from = coord, values_from = value) %>%
    dplyr::mutate(text = paste0(
      hl, "<br>", lookup[x_axis], ": ", round(x, 1), "<br>",
      lookup[y_axis], ":", round(y, 1))) 
  
  
  plotly::plot_ly(x = ~x, y = ~y, text = ~text, hoverinfo = "text") %>% 
    plotly::add_markers(
      data = dplyr::filter(.data, hl == ""),
      marker = list(
        color = paste0('rgba(', paste(col2rgb("black"), collapse = ", "), ', 0.6)'),
        size = 5,
        line = list(
          color = "black",
          width = 1
        ))) %>%
    plotly::add_markers(
      data = dplyr::filter(.data, hl != ""),
      marker = list(
        color = paste0('rgba(', paste(col2rgb(hl_color), collapse = ", "), ', 0.6)'),
        size = 7,
        line = list(
          color = paste0('rgba(', paste(col2rgb(hl_color), collapse = ", "), ', 1)'),
          width = 1
        ))
    ) %>% 
    plotly::layout(
      showlegend = FALSE, 
      xaxis = list(title = lookup[x_axis], range = c(0, 105)),
      yaxis = list(title = lookup[y_axis], range = c(0, 105)))
}
