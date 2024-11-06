



insert_string_break <- function(string, n_character, sub = "<br>", at = " ") {
  if (nchar(string) > n_character) {
    loc <- stringr::str_locate_all(string, at)[[1]][,1]
    if (length(loc) != 0) {
      loc    <- loc[which.min(abs(loc - nchar(string) / 2))]
      string <- paste0(stringr::str_sub(string, 1, loc - 1), sub, stringr::str_sub(string, loc + 1, -1))
    }
  }
  string
}
