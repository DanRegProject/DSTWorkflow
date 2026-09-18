# Datasources: Metadata structure to identify datasources on Statistics Denmark

library(tibble)
library(dplyr)
library(stringr)

datasources <- tibble::tibble(
  head     = character(),
  source   = list(),   # listekolonne: fx c("LPR","PRIV","PSYK","LPR3")
  keytbl   = list(),   # listekolonne: fx c("lpr_adm", "priv_adm", ...)
  datatbl  = list(),   # listekolonne
  datatbl2 = list(),   # listekolonne
  key      = character(),
  code     = character(),
  date     = character(),
  select   = list()
)

add_datasource <- function(
    head,                # Short identifier used throughout
    source,              # Main data source, primarily used to distinquish hospital data sources 
    keytbl,              # Data file with person id 
    datatbl  = "",       # Suppl data file, optional
    datatbl2 = "",       # Additional suppl data file, optional
    key      = "",       # Key to link keytbl, datatbl and datatbl2
    code     = "",       # Variable with code used for dataextract with get()
    date     = "",       # Date variable
    select   = ""        # Default minimal list of variables being extracted
) {
  if (missing(head) || missing(source) || missing(keytbl)) {
    stop("head, source, and keytbl must be specified")
  }
  
  src_v   <- normalize_vec(source)
  key_tbl_v <- normalize_vec(keytbl)
  data_tbl_v  <- normalize_vec(datatbl)
  data_tbl2_v <- normalize_vec(datatbl2)
  select_v <- normalize_vec(select)
  
  # Regler:
  # - keytbl samme længde som source (én pr. source)

  check_len(key_tbl_v,   "keytbl", length(src_v))
  if (!missing(datatbl)){
    check_len(data_tbl_v,  "datatbl", length(key_tbl_v))
  } 
  if (!missing(datatbl2)){
    check_len(data_tbl2_v,  "datatbl2", length(key_tbl_v))
  } 
  
  new_row <- tibble(
    head     = as.character(head),
    source   = list(src_v),
    keytbl   = list(key_tbl_v),
    datatbl  = list(data_tbl_v),
    datatbl2 = list(data_tbl2_v),
    key      = as.character(key),
    code     = as.character(code),
    date     = as.character(date),
    select   = list(select_v)
  )
  
  existing_idx <- which(datasources$head == head)
  if (length(existing_idx) > 0) {
    datasources <<- bind_rows(
      datasources[-existing_idx, ],
      new_row
    )
  } else {
    datasources <<- bind_rows(datasources, new_row)
  }
  
  invisible(new_row)
}