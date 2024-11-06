
#' Calculate stats
#' 
#' Calculate the question and subgroup statistics for growout or onland hatchery survey data
#'
#' @param survey_data 
#' @param question 
#' @param master_tables 
#' @param farms_geo 
#' @param type 
#' @param production_type 
#' @param language 
#'
#' @return
#' @export
#'
#' @examples
calculate_stats <- function(survey_data,
                            question,
                            master_tables,
                            farms_geo       = NULL,
                            type            = "growout",
                            production_type = "all",
                            language        = "en") {
  
  assertthat::assert_that(type %in% c("growout", "onland_hatchery"))
  
  # Names with question id 
  names(survey_data)[-1] <- question$question_id
  
  
  if (type == "growout") {
    
    survey_data <- dplyr::filter(survey_data, `2.6` == "Produksjon av matfisk")
    
    stat_subgroups_total_weights   <- master_tables$stat_subgroups_total_weights_growout
    stat_subgroups_int_ext_weights <- master_tables$stat_subgroups_int_ext_weights_growout
    stat_subgroups                 <- master_tables$stat_subgroups_growout
    stat_questions                 <- master_tables$stat_questions_growout
    
  } else if (type == "onland_hatchery") {
    
    filter_string <- character(0)
    if ("all" %in% production_type) {
      filter_string <- c("Produksjon av settefisk",
                         "Produksjon av rogn",
                         "Produksjon av postsmolt")
    } else {
      if ("settefisk" %in% tolower(production_type)) { 
        filter_string <- c(filter_string, "Produksjon av settefisk")
      } 
      if ("rogn" %in% tolower(production_type)) { 
        filter_string <- c(filter_string, "Produksjon av rogn")
      } 
      if ("postsmolt" %in% tolower(production_type)) { 
        filter_string <- c(filter_string, "Produksjon av postsmolt")
      } 
    }
    if (length(filter_string) == 0) {
      # In case of a mistake in production_type filter all
      message("production_type not set properly, filtering all production types")
      filter_string <- c("Produksjon av settefisk",
                         "Produksjon av rogn",
                         "Produksjon av postsmolt")
    }
    
    survey_data <- dplyr::filter(survey_data, `2.6` %in% filter_string)
    
    stat_subgroups_total_weights   <- master_tables$stat_subgroups_total_weights_onland_hatchery
    stat_subgroups_int_ext_weights <- master_tables$stat_subgroups_int_ext_weights_onland_hatchery
    stat_subgroups                 <- master_tables$stat_subgroups_onland_hatchery
    stat_questions                 <- master_tables$stat_questions_onland_hatchery
    
  } else {
    return(NULL)
  }
  
  # Currently no english questions available, hence set to Norwegian when not many available
  if (language == "en") {
    if (sum(stat_questions$stat_question_en == "") < 50) {
      stat_questions$stat_question <- stat_questions$stat_question_en
    } else {
      stat_questions$stat_question <- stat_questions$stat_question_nw
    }
  } else  {
    stat_questions$stat_question <- stat_questions$stat_question_nw
  }

  # Apply the scoring functions to the farms survey data
  sq_score <- stat_questions %>%
    # dplyr::filter(stat_subgroup == "su1.1") %>% # For inspection
    dplyr::mutate(score_raw = purrr::map(score_func, ~ .(survey_data))) %>%
    dplyr::mutate(answer = purrr::map(answer_func, ~ .(survey_data))) %>% 
    tidyr::unnest(cols = c(score_raw, answer)) %>% 
    dplyr::select(-score_func, -answer_func) %>% 
    dplyr::group_by(stat_subgroup, stat_qn) %>% 
    dplyr::mutate(user_timestamp = survey_data$Timestamp,
                  user_loc_nr    = as.character(survey_data$`2.1`),
                  user_q1.1      = as.character(survey_data$`1.1`)) %>% 
    dplyr::ungroup() %>% 
    dplyr::mutate(score = score_raw * weight) %>% 
    dplyr::mutate(level = "Farm")
  
  # Calculate and bind zone and norway average score
  sq_score <- dplyr::bind_rows(
    sq_score,
    calculate_stat_question_per_zone(sq_score, farms_geo = farms_geo),
    calculate_stat_question_norway(sq_score))
  
  # Calculate max and percentage score
  sq_score <- sq_score %>% 
    dplyr::mutate(max_score = weight,
                  score_perc = round(100 * score / max_score, 1))
  
  # Select to rearrange column order
  sq_score <- sq_score %>% 
    dplyr::select(level, stat_subgroup, zone, 
                  dplyr::contains("user"), 
                  stat_question, stat_qn, answer,
                  score_raw, weight, score, max_score, score_perc)
  
  # Sub group score is the sum of scores within the subgroup
  ss_score <- sq_score %>% 
    dplyr::group_by(stat_subgroup, level, user_loc_nr, user_timestamp, user_q1.1, zone) %>% 
    dplyr::summarise(
      score_raw     = sum(score, na.rm = TRUE),
      max_score_raw = sum(max_score, na.rm = TRUE),
      .groups       = "drop") %>% 
    dplyr::mutate(score = score_raw / max_score_raw)
  
  # For internal and external scores get the subgroups weights, then calculated the sums of the 
  # scores and normalise again by dividing by max score
  ss_score_int_ext <- ss_score %>% 
    dplyr::left_join(
      dplyr::select(stat_subgroups_int_ext_weights, stat_subgroup, weight), 
      by = "stat_subgroup") %>% 
    dplyr::mutate(score_weighted = score * weight) %>% 
    dplyr::left_join(
      dplyr::select(stat_subgroups_int_ext_weights, stat_subgroup, stat_subgroup_add), 
      by = "stat_subgroup") %>% 
    dplyr::filter(!is.na(stat_subgroup_add)) %>% 
    dplyr::select(-stat_subgroup) %>% 
    dplyr::rename(stat_subgroup = stat_subgroup_add) %>% 
    dplyr::group_by(level, stat_subgroup, user_loc_nr, user_timestamp, user_q1.1, zone) %>% 
    dplyr::summarise(score_raw     = sum(score_weighted, na.rm = TRUE),
                     max_score_raw = sum(weight, na.rm = TRUE),
                     .groups = "drop") %>% 
    dplyr::mutate(score = score_raw / max_score_raw)
  
  # For total score get the internal and external weights, then calculated the sums of the 
  # scores and normalise again by dividing by max score
  ss_score_total <- ss_score_int_ext %>% 
    dplyr::left_join(
      dplyr::select(stat_subgroups_total_weights, stat_subgroup, weight), 
      by = "stat_subgroup") %>% 
    dplyr::mutate(score_weighted = score * weight) %>% 
    dplyr::left_join(
      dplyr::select(stat_subgroups_total_weights, stat_subgroup, stat_subgroup_add), 
      by = "stat_subgroup") %>% 
    dplyr::filter(!is.na(stat_subgroup_add)) %>% 
    dplyr::select(-stat_subgroup) %>% 
    dplyr::rename(stat_subgroup = stat_subgroup_add) %>% 
    dplyr::group_by(level, stat_subgroup, user_loc_nr, user_timestamp, user_q1.1, zone) %>% 
    dplyr::summarise(score_raw = sum(score_weighted, na.rm = TRUE),
                     max_score_raw = sum(weight, na.rm = TRUE),
                     .groups = "drop") %>% 
    dplyr::mutate(score     = score_raw / max_score_raw)
  
  # Bind original subgroups with int/ext and total scores and calculate score percentage
  ss_score <- dplyr::bind_rows(
    ss_score,
    ss_score_int_ext,
    ss_score_total) %>% 
    dplyr::mutate(score_perc = round(100 * score, 1))
  
  # Join the subgroup information, like titles
  ss_score <- dplyr::left_join(ss_score, stat_subgroups, by = "stat_subgroup")
  
  # Set the language
  if (language == "en") {
    ss_score$stat_title <- ss_score$stat_title_en
  } else  {
    ss_score$stat_title <- ss_score$stat_title_nw
  }
  
  # Rearrange subgroups by external (subgroups, total external), internal (subgroups, total internal) and finally total
  ss_score <- arrange_by_stat_subgroups(ss_score)
  
  list(stat_question = sq_score,
       stat_subgroup = ss_score)
}



#' Calculate questions scores stats per zone
#'
#' @param .data 
#' @param farms_geo 
#'
#' @return
#' @export
#'
#' @examples
calculate_stat_question_per_zone <- function(.data, farms_geo) {
  
  .data %>% 
    dplyr::filter(level == "Farm") %>%
    dplyr::left_join(dplyr::select(farms_geo, loc_nr, zone), 
                     by = c("user_loc_nr" = "loc_nr")) %>% 
    dplyr::filter(!is.na(zone)) %>% 
    dplyr::group_by(zone, stat_subgroup, stat_question, stat_qn) %>% 
    dplyr::summarise(weight = mean(weight, na.rm = TRUE), 
                     score_raw = mean(score_raw, na.rm = TRUE),
                     score = mean(score, na.rm = TRUE),
                     .groups = "drop") %>% 
    dplyr::mutate(user_loc_nr = NA_character_,
                  user_timestamp = lubridate::now(tz = "UTC"),
                  level = "Zone",
                  user_q1.1 = "") # %>% 
  # dplyr::rename(user_q1.1 = zone)
}


#' Calculate questions scores stats for complete set (Norway)
#'
#' @param .data 
#' @param farms_geo 
#'
#' @return
#' @export
#'
#' @examples
calculate_stat_question_norway <- function(.data) {
  
  .data %>% 
    dplyr::filter(level == "Farm") %>%
    dplyr::group_by(stat_subgroup, stat_question, stat_qn) %>% 
    dplyr::summarise(weight = mean(weight, na.rm = TRUE), 
                     score_raw = mean(score_raw, na.rm = TRUE),
                     score = mean(score, na.rm = TRUE),
                     .groups = "drop") %>% 
    dplyr::mutate(user_loc_nr = NA_character_,
                  user_timestamp = lubridate::now(tz = "UTC"),
                  level = "Norway",
                  user_q1.1 = "norway_average")
}

#' Arrange subgroup score for table
#' 
#' Rearrange subgroups by external (subgroups, total external), internal (subgroups, total internal) and finally total
#'
#' @param .data 
#'
#' @return
#' @export
#'
#' @examples
arrange_by_stat_subgroups <- function(.data) {
  # To avoid as.numeric NA warning
  as_numeric_na <- function(vec) {
    vec[is.na(vec)] <- "Inf" # from 'ext' and 'int'
    vec[vec == "l"] <- "Inf" # from 'total'
    as.numeric(vec)
  }
  
  dplyr::arrange(.data,
                 stat_group, 
                 stringr::str_sub(stat_subgroup, 1, 2) != "su", 
                 as_numeric_na(stringr::str_sub(stat_subgroup, 5, -1)))
}
