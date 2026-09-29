# ============================================================================
# LOGGING AND TIMING UTILITIES
# ============================================================================

#' Initialize logging
#' @param log_dir Directory for log files
#' @param filename Base name for log file
#' @param option "new" to create new file, "append" to append
#' @return Connection object or invisible NULL
initialize_log <- function(log_dir, filename, option = "new") {
  
  timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
  log_file <- file.path(log_dir, paste0(filename, "_", timestamp, ".log"))
  
  if (option == "new" && file.exists(log_file)) {
    file.remove(log_file)
  }
  
  # Store log file path in global environment
  .GlobalEnv$current_log_file <- log_file
  .GlobalEnv$log_active <- TRUE
  
  cat("\n" %+% strrep("=", 80) %+% "\n")
  cat("LOG FILE: ", log_file, "\n")
  cat("Started: ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
  cat(strrep("=", 80) %+% "\n\n")
  
  invisible(log_file)
}

#' Log a message
#' @param message Message to log
#' @param type Type of message ("INFO", "WARNING", "ERROR")
log_message <- function(message, type = "INFO") {
  
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  prefix <- paste0("[", timestamp, "] [", type, "] ")
  
  full_message <- paste0(prefix, message)
  
  cat(full_message, "\n")
  
  # Optionally write to file
  if (exists("current_log_file", envir = .GlobalEnv) && 
      exists("log_active", envir = .GlobalEnv) &&
      .GlobalEnv$log_active) {
    write(full_message, file = .GlobalEnv$current_log_file, append = TRUE)
  }
}

#' Timer management
#' @param timer_name Name of timer
#' @param action "start" or "end"
#' @return Time elapsed (if action="end")
timer <- function(timer_name, action = "start") {
  
  if (!exists("timers", envir = .GlobalEnv)) {
    .GlobalEnv$timers <- list()
  }
  
  if (action == "start") {
    .GlobalEnv$timers[[timer_name]] <- Sys.time()
    log_message(paste("Timer '", timer_name, "' started", sep = ""), "DEBUG")
    return(invisible(NULL))
  } else if (action == "end") {
    if (!timer_name %in% names(.GlobalEnv$timers)) {
      log_message(paste("Timer '", timer_name, "' not found", sep = ""), "WARNING")
      return(NA)
    }
    elapsed <- Sys.time() - .GlobalEnv$timers[[timer_name]]
    log_message(paste("Timer '", timer_name, "' ended. Elapsed: ", 
                      format(elapsed), sep = ""), "DEBUG")
    return(elapsed)
  }
}

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


#' Safe column selection
#' @param dt data.table
#' @param cols Vector of column names to select
#' @return data.table with only existing columns
select_existing_cols <- function(dt, cols) {
  
  existing <- cols[cols %in% names(dt)]
  missing <- cols[!cols %in% names(dt)]
  
  if (length(missing) > 0) {
    log_message(paste("Columns not found:", paste(missing, collapse = ", ")), "WARNING")
  }
  
  if (length(existing) == 0) {
    log_message("No columns to select", "WARNING")
    return(dt[, .SD][0])  # Return empty data.table with same structure
  }
  
  return(dt[, ..existing])
}

# ============================================================================
# DATA VALIDATION UTILITIES
# ============================================================================

#' Validate required columns in dataset
#' @param dt data.table
#' @param required_cols Vector of required column names
#' @return Logical TRUE if valid, FALSE otherwise
validate_columns <- function(dt, required_cols) {
  
  missing <- required_cols[!required_cols %in% names(dt)]
  
  if (length(missing) > 0) {
    log_message(paste("Missing required columns:", paste(missing, collapse = ", ")), "ERROR")
    return(FALSE)
  }
  
  return(TRUE)
}

#' Check for duplicate rows
#' @param dt data.table
#' @param by_cols Columns to check duplicates by
#' @return Number of duplicates
count_duplicates <- function(dt, by_cols) {
  
  if (!all(by_cols %in% names(dt))) {
    log_message("Some 'by' columns not found", "WARNING")
    return(NA)
  }
  
  dup_count <- sum(duplicated(dt, by = by_cols))
  
  if (dup_count > 0) {
    log_message(paste("Found", dup_count, "duplicates by columns:", 
                      paste(by_cols, collapse = ", ")), "WARNING")
  }
  
  return(dup_count)
}

# ============================================================================
# STRING UTILITIES
# ============================================================================

#' String concatenation operator
`%+%` <- function(x, y) {
  paste0(x, y)
}

#' Check if string is empty or NULL
is_empty <- function(x) {
  is.null(x) || length(x) == 0 || (is.character(x) && x == "")
}

#' Expand code patterns (e.g., "DA" matches "DA666", "DA667")
#' @param code_pattern Pattern to match (e.g., "DA")
#' @param code_list Full list of codes
#' @return Codes matching pattern
match_code_pattern <- function(code_pattern, code_list) {
  
  if (is_empty(code_pattern)) return(character(0))
  
  # Use grepl for prefix matching
  matched <- code_list[grepl(paste0("^" %+% code_pattern), code_list, ignore.case = TRUE)]
  
  return(matched)
}

cat("\n=== Utility functions loaded ===")
cat("\n")
