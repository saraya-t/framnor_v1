
handle_duplicate_googlsheet_names <- function(xl) {
  
  xl[stringr::str_detect(names(xl), stringr::fixed("..."))]
  nms <- names(xl[stringr::str_detect(names(xl), stringr::fixed("..."))])
  
  nms_new <- nms %>% 
    stringr::str_split(stringr::fixed("...")) %>% 
    purrr::map_chr(~ .[1])
  
  for (nm_new in unique(nms_new)) {
    xl[nm_new] <- NA_character_
    for (row in seq_len(nrow(xl))) {
      non_na <- xl[row, nms[which(nms_new == nm_new)]] %>% t() %>% na.omit() %>% c()
      xl[row, nm_new] <- non_na[1]
    }
  }
  xl <- xl[which(!names(xl) %in% nms)]
  
  xl
}