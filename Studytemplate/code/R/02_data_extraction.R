# ============================================================================
# DST Workflow - R Translation
# Data Extraction Functions (replaces getgeneric.sas & findrows() macro)
# ============================================================================

#' Main data extraction function
#' Equivalent to %get() macro
#'
#' @param sets Character vector or string of indicator names to extract
#' @param type Data type ("DIAG", "OPR", "UBE", "LMDB", "LAB", "CAR", "PATO")
#' @param from_year Start year for data extraction
#' @param to_year End year for data extraction
#' @param from_date Specific start date (overrides from_year)
#' @param to_date Specific end date
#' @param in_data Population dataset (data.table with pnr column)
#' @param out_data Output dataset name (if NULL, returns data.table)
#' @param sources Data sources to search (e.g., c("LPR", "PSYK", "PRIV"))
#' @param config Configuration list
#' @param source_list List of source definitions
#' @param indicator_list List of indicator definitions
#'
#' @return data.table with extracted data or NULL if error
#'
get_data <- function(sets = NULL, 
                     type = NULL,
                     from_year = NULL,
                     to_year = Sys.Date() %>% year(),
                     from_date = NULL,
                     to_date = NULL,
                     in_data = NULL,
                     out_data = NULL,
                     sources = NULL,
                     config = config,
                     source_list = sources,
                     indicator_list = indicators) {
  
  # Validate required parameters
  if (is_empty(sets)) {
    log_message("get_data ERROR: 'sets' parameter is required", "ERROR")
    return(NULL)
  }
  
  if (is_empty(type)) {
    log_message("get_data ERROR: 'type' parameter is required", "ERROR")
    return(NULL)
  }
  
  type <- toupper(type)
  
  # Validate type
  valid_types <- c("DIAG", "OPR", "UBE", "LMDB", "LAB", "CAR", "PATO")
  if (!type %in% valid_types) {
    log_message(paste("get_data ERROR: type must be one of:", 
                      paste(valid_types, collapse = ", ")), "ERROR")
    return(NULL)
  }
  
  # Parse sets (can be space-separated string or vector)
  if (is.character(sets) && length(sets) == 1) {
    sets <- strsplit(sets, "\\s+")[[1]]
  }
  sets <- toupper(sets)
  
  # Set default sources if not provided
  if (is_empty(sources)) {
    sources <- if (type %in% names(source_list)) {
      source_list[[type]]$sources
    } else {
      c("LPR", "PSYK", "PRIV", "LPR3")
    }
  }
  
  # Set default year range
  if (is_empty(from_year) && is_empty(from_date)) {
    from_year <- config$project_start_year
  }
  
  # Convert year range to dates if needed
  if (!is_empty(from_year) && is_empty(from_date)) {
    from_date <- make_date(from_year, 1, 1)
  }
  if (!is_empty(to_year) && is_empty(to_date)) {
    to_date <- make_date(to_year, 12, 31)
  }
  
  log_message(paste("get_data START: type=", type, ", sets=", 
                    paste(sets, collapse=","), sep=""), "INFO")
  
  timer("get_data", "start")
  
  # Combine results from each set
  combined_results <- NULL
  
  for (i in seq_along(sets)) {
    code_name <- sets[i]
    indicator_key <- paste0(type, "_", code_name)
    
    # Check if indicator exists
    if (!indicator_key %in% names(indicator_list)) {
      log_message(paste("get_data WARNING: Indicator not found:", indicator_key), "WARNING")
      next
    }
    
    indicator <- indicator_list[[indicator_key]]
    
    # Find rows for this indicator across all sources
    result <- find_rows(
      outcome = code_name,
      code = indicator$codes,
      type = type,
      sources = sources,
      in_data = in_data,
      from_date = from_date,
      to_date = to_date,
      criteria = indicator$criteria,
      config = config,
      source_list = source_list
    )
    
    if (!is.null(result) && nrow(result) > 0) {
      combined_results <- if (is.null(combined_results)) {
        result
      } else {
        rbind(combined_results, result, fill = TRUE)
      }
    }
  }
  
  elapsed <- timer("get_data", "end")
  
  if (is.null(combined_results)) {
    log_message(paste("get_data: No data found for type=", type), "WARNING")
    return(NULL)
  }
  
  # Sort by key columns
  type_spec <- source_list[[type]]
  sort_cols <- c("pnr", type_spec$date_col)
  sort_cols <- sort_cols[sort_cols %in% names(combined_results)]
  
  if (length(sort_cols) > 0) {
    setkeyv(combined_results, sort_cols)
  }
  
  log_message(paste("get_data END: Extracted", nrow(combined_results), 
                    "rows in", round(as.numeric(elapsed), 2), "seconds"), "INFO")
  
  return(combined_results)
}

#' Find rows matching criteria across year-specific tables
#' Equivalent to %findrows() macro
#'
#' @param outcome Outcome label
#' @param code Vector of codes to match
#' @param type Data type
#' @param sources Vector of data sources to search
#' @param in_data Optional population filter (data.table with pnr)
#' @param from_date Start date filter
#' @param to_date End date filter
#' @param criteria Additional WHERE-like criteria
#' @param config Configuration
#' @param source_list Source definitions
#'
#' @return data.table
#'
find_rows <- function(outcome = NULL,
                      code = NULL,
                      type = NULL,
                      sources = NULL,
                      in_data = NULL,
                      from_date = NULL,
                      to_date = NULL,
                      criteria = NULL,
                      config = config,
                      source_list = sources) {
  
  if (is_empty(type)) {
    log_message("find_rows ERROR: type is required", "ERROR")
    return(NULL)
  }
  
  type <- toupper(type)
  
  # Get source specifications
  type_spec <- source_list[[type]]
  if (is.null(type_spec)) {
    log_message(paste("find_rows ERROR: Unknown type:", type), "ERROR")
    return(NULL)
  }
  
  combined_data <- NULL
  
  # Search each source
  for (source in sources) {
    source_data <- find_rows_in_source(
      source = source,
      type = type,
      code = code,
      in_data = in_data,
      from_date = from_date,
      to_date = to_date,
      criteria = criteria,
      config = config,
      source_list = source_list
    )
    
    if (!is.null(source_data) && nrow(source_data) > 0) {
      # Add source identifier
      source_data[, source := tolower(source)]
      
      combined_data <- if (is.null(combined_data)) {
        source_data
      } else {
        rbind(combined_data, source_data, fill = TRUE)
      }
    }
  }
  
  if (!is.null(combined_data)) {
    # Add outcome label
    combined_data[, outcome := outcome]
    
    # Remove duplicate key columns from multiple sources
    combined_data <- unique(combined_data)
  }
  
  return(combined_data)
}

#' Search for matching rows in a single data source
#'
find_rows_in_source <- function(source = NULL,
                                type = NULL,
                                code = NULL,
                                in_data = NULL,
                                from_date = NULL,
                                to_date = NULL,
                                criteria = NULL,
                                config = config,
                                source_list = sources) {
  
  source <- toupper(source)
  type <- toupper(type)
  
  # Get type specifications
  type_spec <- source_list[[type]]
  
  log_message(paste("Searching:", type, "in", source), "DEBUG")
  
  # Find year-specific files
  table_prefix <- paste0(source, "_")
  if (type %in% c("DIAG", "OPR", "UBE")) {
    # These types are split across multiple tables
    if (type == "DIAG" && !is.null(type_spec$diag_table)) {
      table_prefix <- paste0(source, "_", type_spec$diag_table, "_")
    } else if (type == "OPR" && !is.null(type_spec$opr_table)) {
      table_prefix <- paste0(source, "_", type_spec$opr_table, "_")
    } else if (type == "UBE" && !is.null(type_spec$ube_table)) {
      table_prefix <- paste0(source, "_", type_spec$ube_table, "_")
    }
  }
  
  # Find available year files
  year_files <- find_year_files(
    base_path = config$master_lib_path,
    pattern = table_prefix,
    years = config$available_years
  )
  
  if (length(year_files) == 0) {
    log_message(paste("No files found for", type, "in", source), "WARNING")
    return(NULL)
  }
  
  # Load and combine year-specific files
  combined_source_data <- NULL
  
  for (year in names(year_files)) {
    year_data <- read_sas_file(year_files[[year]])
    
    if (is.null(year_data) || nrow(year_data) == 0) {
      next
    }
    
    # Filter to population if provided
    if (!is.null(in_data)) {
      if (!validate_columns(year_data, "pnr")) {
        log_message(paste("No pnr column in", year), "WARNING")
        next
      }
      year_data <- year_data[pnr %in% in_data$pnr]
    }
    
    # Filter by code if provided
    if (!is_empty(code)) {
      code_col <- type_spec$code_col
      if (!is.null(code_col) && code_col %in% names(year_data)) {
        # Use prefix matching (like "DA%" in SAS)
        matching_rows <- year_data[
          Reduce(function(x, y) x | y, 
                  lapply(code, function(c) grepl(paste0("^" %+% c), get(code_col), ignore.case = TRUE)))
        ]
        year_data <- matching_rows
      }
    }
    
    # Filter by date range if provided
    date_col <- type_spec$date_col
    if (!is.null(date_col) && date_col %in% names(year_data)) {
      if (!is.null(from_date)) {
        year_data <- year_data[get(date_col) >= from_date]
      }
      if (!is.null(to_date)) {
        year_data <- year_data[get(date_col) <= to_date]
      }
    }
    
    # Apply additional criteria if provided
    if (!is.null(criteria)) {
      tryCatch({
        year_data <- year_data[eval(parse(text = criteria))]
      }, error = function(e) {
        log_message(paste("Error applying criteria:", e$message), "WARNING")
      })
    }
    
    # Combine with other years
    combined_source_data <- if (is.null(combined_source_data)) {
      year_data
    } else {
      rbind(combined_source_data, year_data, fill = TRUE)
    }
  }
  
  if (!is.null(combined_source_data)) {
    # Select standard columns
    std_cols <- if (type == "DIAG" && !is.null(type_spec$std_cols_diag)) {
      type_spec$std_cols_diag
    } else if (type == "OPR" && !is.null(type_spec$std_cols_opr)) {
      type_spec$std_cols_opr
    } else if (type == "UBE" && !is.null(type_spec$std_cols_ube)) {
      type_spec$std_cols_ube
    } else {
      type_spec$std_cols
    }
    
    combined_source_data <- select_existing_cols(combined_source_data, std_cols)
  }
  
  return(combined_source_data)
}

cat("\n=== Data extraction functions loaded ===")
cat("\n")
