# Hjælper til at lave en vektor ud af input, som kan være:
# - én streng: "LPR PRIV PSYK LPR3"
# - eller vektor: c("LPR","PRIV","PSYK","LPR3")
normalize_vec <- function(x) {
  if (length(x) == 0) return(character())
  if (length(x) == 1L && is.character(x)) {
    v <- str_split(x, "\\s+", simplify = TRUE) |>
      as.vector()
  } else {
    v <- as.character(x)
  }
  v <- v[v != ""]
  unique(v)
}

check_len <- function(x, name, n_src) {
  if (length(x) == 0L) return(invisible())
  if (!(length(x) == 1L || length(x) == n_src)) {
    stop(
      sprintf(
        "%s har længde %d, men source har længde %d. Brug samme længde som source.",
        name, length(x), n_src
      )
    )
  }
}

to_num_or_na <- function(x) {
  if (length(x) == 0L || (length(x) == 1L && (is.na(x) || x == ""))) {
    return(NA_real_)
  }
  as.numeric(x)
}
