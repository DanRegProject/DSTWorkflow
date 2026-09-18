# Indicators: Metadata structure to define indicators from any datasource on Statistics Denmark

library(tibble)
library(dplyr)
library(stringr)

indicators <- tibble::tibble(
  type      = character(),
  name      = character(),
  short_txt = character(),
  codes     = list(),      # listekolonne, fx c("DI48","DE10",...)
  icd8      = list(),      # listekolonne, hvis relevant (ellers NULL/NA)
  w         = numeric(),      # evt. vinduer
  wdays     = numeric(),
  crit      = character()
)

add_indicator <- function(
    type,
    name,
    short_txt,
    code,
    icd8   = NULL,
    w      = NA,
    wdays  = NA,
    crit   = ""
) {
  if (missing(type) || missing(name) || missing(code)) {
    stop("type, name og code skal angives")
  }
 
  code_vec <- normalize_vec(code)
  icd8_vec <- normalize_vec(icd8)
  
  # w/wdays: konverter til numeric, NA hvis tom/ikke tal
  
  w_num     <- to_num_or_na(w)
  wdays_num <- to_num_or_na(wdays)
  
  new_row <- tibble::tibble(
    type      = as.character(type),
    name      = as.character(name),
    short_txt = as.character(short_txt),
    codes     = list(code_vec),
    icd8      = list(icd8_vec),
    w         = w_num,
    wdays     = wdays_num,
    crit      = as.character(crit)
  )
  
  # overskriv eksisterende (samme type+name) som SAS-makroerne gør
  existing_idx <- which(indicators$type == type & indicators$name == name)
  if (length(existing_idx) > 0) {
    indicators <<- dplyr::bind_rows(
      indicators[-existing_idx, ],
      new_row
    )
  } else {
    indicators <<- dplyr::bind_rows(indicators, new_row)
  }
  
  invisible(new_row)
}