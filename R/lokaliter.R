

#' Get lokaliter
#' 
#' Download the lokaliter data from source
#' 
#' @param vars character() with columns to return in data frame. Named strings will will overwrite the column name. 
#' @param types character() with column types corresponding to vars, only 'c' (character) and 'd' (double) available.
#'
#' @return tibble()
#' @export
#'
#' @examples
get_lokaliter <- function(vars  = c("loc_nr" = "loknr", "lat", "lon"),
                          types = c("c", "d", "d")) {
  
  assertthat::assert_that(is.character(vars))
  assertthat::assert_that(is.character(types))
  assertthat::assert_that(all(types %in% c("c", "d")))
  assertthat::assert_that(length(types) == length(vars))
  
  resp <- httr::GET("https://gis.fiskeridir.no/server/rest/services/Yggdrasil/Akvakulturregisteret/FeatureServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json")
  
  resp_error <- httr::http_error(resp)
  if (resp_error) {
    warning("Error in retrieving lokaliter data from gis.fiskeridir.no")
    return(NULL)
  }
  
  resp_type  <- httr::http_type(resp)
  if (resp_type != "application/json") {
    warning("Response type from gis.fiskeridir.no is not application JSON")
    return(NULL)
  }
  
  resp_text <- httr::content(resp, as = "text") 
  
  rtdf <- jsonlite::fromJSON(resp_text)
  
  lokaliter <- rtdf$features$attributes
  
  # c("objectid", "loknr", "navn", "status_lokalitet", "klareringsdato",
  #   "klareringstype", "kapasitet_lok", "kapasitet_unittype", "plassering",
  #   "vannmiljo", "lokalitet", "fylke", "kommunenr", "kommune", 
  #   "lat", "lon", 
  #   "symbol", "til_arter", "til_innehavere", "lokalitet_url", 
  #   "til_tillatelser", "til_formaal", "til_produksjonsform")
  
  if (!all(vars %in% names(lokaliter))) {
    warning(paste0("Not all variables (", paste(vars, collapse = ", "),
                   ") in downloaded data"))
    return(NULL)
  }
  
  lokaliter        <- lokaliter[vars]
  # Set new names to old names if not set
  if (is.null(names(vars))) {
    # names(vars) is NULL when no names have been set
    names(vars) <- vars 
  } else {
    names(vars)[names(vars) == ""] <- vars[names(vars) == ""]
  }
  names(lokaliter) <- names(vars)
  
  lokaliter <- lokaliter %>% 
    dplyr::mutate_if(types == "c", as.character) %>% 
    dplyr::mutate_if(types == "d", as.double)
  
  tibble::as_tibble(lokaliter)
}
