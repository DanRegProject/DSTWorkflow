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
    type      = toupper(as.character(type)),
    name      = toupper(as.character(name)),
    short_txt = as.character(short_txt),
    codes     = list(toupper(code_vec)),
    icd8      = list(toupper(icd8_vec)),
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

get_indicator <- function(type, name) {
  # Filtrér den relevante indikator
  ind <- indicators %>%
    dplyr::filter(.data$type == !!toupper(type), .data$name == !!toupper(name))
  
  if (nrow(ind) == 0L) {
    stop("Ingen indikator fundet for type='", type, "' og name='", name, "'.")
  }
  if (nrow(ind) > 1L) {
    stop("Flere indikatorer fundet for type='", type, "' og name='", name, "'. Metadata bør være unikke.")
  }
  
  # Ekstrahér de centrale felter
  list(
    type      = ind$type[1],
    name      = ind$name[1],
    short_txt = ind$short_txt[1],
    codes     = ind$codes[[1]],   # vektor
    icd8      = ind$icd8[[1]],    # vektor eller NULL
    w         = ind$w[1],
    wdays     = ind$wdays[1],
    crit      = ind$crit[1]
  )
}

clone_indicator <- function(
    from_type,
    from_name,
    to_type  = from_type,
    to_name,
    short_txt = NULL,  # hvis NULL: brug original short_txt
    w        = NULL,   # hvis NULL: brug original w
    wdays    = NULL,   # hvis NULL: brug original wdays
    crit     = NULL    # hvis NULL: brug original crit
) {
  orig <- get_indicator(from_type, from_name)
  
  # brug original short_txt hvis ikke andet er angivet
  if (is.null(short_txt)) short_txt <- orig$short_txt
  if (is.null(w))        w        <- orig$w
  if (is.null(wdays))    wdays    <- orig$wdays
  if (is.null(crit))     crit     <- orig$crit
  
  # codes/icd8 skal ind som streng til add_indicator (hvis din add_indicator forventer én streng)
  # Vi samler vektoren til én streng med mellemrum
  codes_str <- paste(orig$codes, collapse = " ")
  icd8_str  <- if (is.null(orig$icd8)) "" else paste(orig$icd8, collapse = " ")
  
  add_indicator(
    type      = to_type,
    name      = to_name,
    short_txt = short_txt,
    code      = codes_str,
    icd8      = icd8_str,
    w         = w,
    wdays     = wdays,
    crit      = crit
  )
}