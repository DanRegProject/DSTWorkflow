# ============================================================================
# DST Workflow - R Translation
# Utility Functions (replaces macroutilities.sas functionality)
# ============================================================================

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

# ============================================================================
# FILE AND DATA UTILITIES
# ============================================================================

#' Read SAS dataset
#' @param path Path to .sas7bdat file
#' @return data.table
read_sas_file <- function(path) {
  
  if (!file.exists(path)) {
    log_message(paste("File not found:", path), "ERROR")
    return(NULL)
  }
  
  tryCatch({
    dt <- as.data.table(read_sas(path))
    log_message(paste("Loaded:", basename(path), "(", nrow(dt), "rows, ", 
                      ncol(dt), "cols)"), "INFO")
    return(dt)
  }, error = function(e) {
    log_message(paste("Error reading file:", path, "-", e$message), "ERROR")
    return(NULL)
  })
}

#' Find year-specific dataset files
#' @param base_path Path to data directory
#' @param pattern Base filename pattern (e.g., "LPR_")
#' @param years Vector of years to search for
#' @return Named list of file paths
find_year_files <- function(base_path, pattern, years) {
  
  file_list <- list()
  
  for (year in years) {
    # Try different naming conventions
    filename_patterns <- c(
      paste0(pattern, year, ".sas7bdat"),
      paste0(pattern, "_", year, ".sas7bdat"),
      paste0(toupper(pattern), year, ".sas7bdat")
    )
    
    for (pattern_try in filename_patterns) {
      filepath <- file.path(base_path, pattern_try)
      if (file.exists(filepath)) {
        file_list[[as.character(year)]] <- filepath
        break
      }
    }
  }
  
  if (length(file_list) == 0) {
    log_message(paste("No files found matching pattern:", pattern), "WARNING")
  } else {
    log_message(paste("Found", length(file_list), "year-specific files for", pattern), "INFO")
  }
  
  return(file_list)
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
