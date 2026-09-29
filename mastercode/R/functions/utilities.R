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
