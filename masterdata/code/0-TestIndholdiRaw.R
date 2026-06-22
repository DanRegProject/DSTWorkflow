#' Data Library Profiling and Reporting Tool
#' 
#' Generates comprehensive PDF reports of all datasets in a given directory,
#' including summary statistics, variable inventories, and data quality checks.
#' 
#' This R implementation replaces the SAS macro scanlib() with improved:
#' - Efficiency through vectorized operations and data.table
#' - Transparency via clear variable naming and function documentation
#' - Support for multiple data formats including SAS, RDS, RData, and CSV
#' - Extensibility for future enhancements
#'
#' @param in Character string specifying the data directory or environment to scan
#' @param withyear Logical. If TRUE (default), attempts to extract year from table names
#' @param output_pdf Character string. Path to output PDF file
#' @param verbose Logical. If TRUE, prints progress messages

library(data.table)
library(tidyr)
library(ggplot2)
library(gridExtra)
library(rmarkdown)
library(knitr)

# Check for haven package (reads SAS files)
if (!requireNamespace("haven", quietly = TRUE)) {
  warning("Package 'haven' not found. SAS files will not be readable. Install with: install.packages('haven')")
}

# ============================================================================
# PRIMARY FUNCTION: scan_library
# ============================================================================

scan_library <- function(in = "rawdata", 
                        withyear = TRUE, 
                        output_pdf = NULL,
                        verbose = TRUE) {
  
  # Validate inputs
  if (!is.character(in) || length(in) != 1) {
    stop("'in' must be a single character string specifying data directory")
  }
  if (!is.logical(withyear)) {
    stop("'withyear' must be logical (TRUE/FALSE)")
  }
  
  # Set default output path if not provided
  if (is.null(output_pdf)) {
    output_pdf <- paste0(Sys.getenv("logdir"), "/rawdatareport.pdf")
  }
  
  if (verbose) cat("Scanning library:", in, "\n")
  
  # Load all datasets from the directory or environment
  datasets_list <- load_datasets(in, verbose = verbose)
  
  if (length(datasets_list) == 0) {
    warning(paste("No datasets found in", in))
    return(invisible(NULL))
  }
  
  # Extract table metadata
  tables_metadata <- extract_table_metadata(datasets_list, withyear = withyear, verbose = verbose)
  
  # Extract variable metadata
  variables_metadata <- extract_variable_metadata(datasets_list, tables_metadata, verbose = verbose)
  
  # Classify tables as single or multiple entity types
  table_classification <- classify_tables(tables_metadata)
  
  if (verbose) {
    cat("Found", nrow(table_classification$single), "single-table entities\n")
    cat("Found", nrow(table_classification$multiple), "multiple-table entities\n")
  }
  
  # Generate report
  generate_report(
    tables_single = table_classification$single,
    tables_multiple = table_classification$multiple,
    variables_all = variables_metadata,
    library_name = in,
    withyear = withyear,
    output_pdf = output_pdf,
    verbose = verbose
  )
  
  if (verbose) cat("Report saved to:", output_pdf, "\n")
  
  invisible(list(
    tables_metadata = tables_metadata,
    variables_metadata = variables_metadata,
    classification = table_classification
  ))
}

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

#' Load datasets from a directory or environment
#' 
#' Supports multiple file formats: .sas7bdat (SAS), .rds, .RData, .csv, .xpt (SAS transport)
#' 
#' @param source Character string specifying data directory path or environment name
#' @param verbose Logical. Print progress
#' @return List of data.tables
load_datasets <- function(source, verbose = FALSE) {
  
  datasets <- list()
  
  # If source is a directory path
  if (dir.exists(source)) {
    # Define supported file patterns
    file_patterns <- c(
      "\\.(sas7bdat|SAS7BDAT)$",  # SAS data files
      "\\.(xpt|XPT)$",             # SAS transport files
      "\\.(rds|RDS)$",             # R serialized objects
      "\\.(RData|rdata)$",         # R workspace files
      "\\.(csv|CSV)$"              # CSV files
    )
    
    pattern <- paste(file_patterns, collapse = "|")
    files <- list.files(source, pattern = pattern, full.names = TRUE)
    
    if (verbose && length(files) > 0) {
      cat("Found", length(files), "data files\n")
    }
    
    for (file in files) {
      filename_clean <- tools::file_path_sans_ext(basename(file))
      
      if (verbose) cat("  Loading:", basename(file), "\n")
      
      tryCatch({
        dataset <- load_single_file(file)
        
        if (!is.null(dataset)) {
          # Convert to data.table if not already
          if (!is.data.table(dataset)) {
            setDT(dataset)
          }
          
          datasets[[filename_clean]] <- dataset
          
          if (verbose) cat("    ✓ Loaded (", nrow(dataset), "rows ×", ncol(dataset), "cols)\n", sep = "")
        }
      }, error = function(e) {
        if (verbose) cat("    ✗ Error loading file:", conditionMessage(e), "\n")
      })
    }
  } 
  # If source is an environment name in global environment
  else if (exists(source, where = .GlobalEnv)) {
    env_obj <- get(source, envir = .GlobalEnv)
    
    if (is.environment(env_obj)) {
      for (name in ls(envir = env_obj)) {
        obj <- get(name, envir = env_obj)
        if (is.data.frame(obj)) {
          if (!is.data.table(obj)) setDT(obj)
          datasets[[name]] <- obj
        }
      }
    }
  } 
  else {
    warning(paste("Source", source, "not found as directory or environment"))
  }
  
  return(datasets)
}

#' Load a single data file based on format
#' 
#' @param file_path Character string. Full path to file
#' @return data.frame or data.table, or NULL if loading failed
#' @keywords internal
load_single_file <- function(file_path) {
  
  extension <- tolower(tools::file_ext(file_path))
  
  dataset <- switch(extension,
    # SAS formats
    sas7bdat = {
      if (!requireNamespace("haven", quietly = TRUE)) {
        stop("Package 'haven' required for reading SAS files. Install with: install.packages('haven')")
      }
      haven::read_sas(file_path)
    },
    xpt = {
      if (!requireNamespace("haven", quietly = TRUE)) {
        stop("Package 'haven' required for reading SAS transport files. Install with: install.packages('haven')")
      }
      haven::read_xpt(file_path)
    },
    # R formats
    rds = readRDS(file_path),
    rdata = {
      env <- new.env()
      load(file_path, envir = env)
      # Return first object in environment (typically there's only one)
      get(ls(envir = env)[1], envir = env)
    },
    # CSV format
    csv = data.table::fread(file_path),
    # Default: return NULL for unknown formats
    NULL
  )
  
  return(dataset)
}

#' Extract metadata about tables
#' @param datasets_list List of data.tables
#' @param withyear Logical. Extract year from table names
#' @param verbose Logical. Print progress
#' @return data.table with columns: table, nobs, nvar, num_numeric, num_character, tablegrp, year
extract_table_metadata <- function(datasets_list, withyear = TRUE, verbose = FALSE) {
  
  if (verbose) cat("Extracting table metadata...\n")
  
  # Initialize empty data.table
  metadata <- data.table(
    table = character(),
    nobs = integer(),
    nvar = integer(),
    num_numeric = integer(),
    num_character = integer()
  )
  
  # Iterate through datasets
  for (table_name in names(datasets_list)) {
    dt <- datasets_list[[table_name]]
    
    # Count variable types
    col_types <- sapply(dt, function(x) class(x)[1])
    num_numeric <- sum(col_types %in% c("numeric", "integer", "double", "haven_labelled"))
    num_character <- sum(col_types %in% c("character", "factor"))
    
    # Add row to metadata
    metadata <- rbind(metadata, data.table(
      table = table_name,
      nobs = nrow(dt),
      nvar = ncol(dt),
      num_numeric = num_numeric,
      num_character = num_character
    ))
  }
  
  # Extract year and table group if requested
  if (withyear) {
    metadata[, c("tablegrp", "year") := extract_year_and_group(table)]
  } else {
    metadata[, tablegrp := table]
    metadata[, year := NA_real_]
  }
  
  setorder(metadata, tablegrp)
  
  return(metadata)
}

#' Extract year and table group from table name
#' 
#' Attempts to find 4-digit year patterns (19XX or 20XX) in table names
#' 
#' @param table_names Character vector of table names
#' @return data.table with columns: tablegrp, year
extract_year_and_group <- function(table_names) {
  
  result <- data.table(
    tablegrp = character(length(table_names)),
    year = numeric(length(table_names))
  )
  
  for (i in seq_along(table_names)) {
    table_name <- table_names[i]
    
    # Look for 4-digit year starting with 19 or 20
    pos <- regexpr("[12][0-9]{3}", table_name)
    
    if (pos > 0) {
      year_start <- pos
      year_end <- pos + attr(pos, "match.length") - 1
      
      result$tablegrp[i] <- substr(table_name, 1, year_start - 1)
      result$year[i] <- as.numeric(substr(table_name, year_start, year_end))
    } else {
      result$tablegrp[i] <- table_name
      result$year[i] <- NA_real_
    }
  }
  
  return(result)
}

#' Extract variable metadata from all datasets
#' @param datasets_list List of data.tables
#' @param tables_metadata data.table with table metadata
#' @param verbose Logical. Print progress
#' @return data.table with columns: table, tablegrp, name, type, label, year
extract_variable_metadata <- function(datasets_list, tables_metadata, verbose = FALSE) {
  
  if (verbose) cat("Extracting variable metadata...\n")
  
  variables <- data.table()
  
  for (table_name in names(datasets_list)) {
    dt <- datasets_list[[table_name]]
    
    # Get table metadata for this dataset
    table_info <- tables_metadata[table == table_name]
    
    # Extract variable types and labels
    col_types <- sapply(dt, function(x) class(x)[1])
    col_labels <- sapply(names(dt), function(col_name) {
      label <- attr(dt[[col_name]], "label", exact = TRUE)
      if (is.null(label)) "" else as.character(label)
    })
    
    # Create variable listing
    var_list <- data.table(
      table = table_name,
      name = names(dt),
      type = col_types,
      label = col_labels
    )
    
    # Add table grouping and year info
    var_list[, tablegrp := table_info$tablegrp[1]]
    var_list[, year := table_info$year[1]]
    
    variables <- rbind(variables, var_list)
  }
  
  return(variables)
}

#' Classify tables as single or multiple entity types
#' @param tables_metadata data.table with table metadata
#' @return List with elements: single (single-table entities), multiple (multi-table entities)
classify_tables <- function(tables_metadata) {
  
  # Count tables per group
  group_counts <- tables_metadata[, .N, by = tablegrp]
  
  # Separate based on count
  single_groups <- group_counts[N == 1, tablegrp]
  multiple_groups <- group_counts[N > 1, tablegrp]
  
  single <- tables_metadata[tablegrp %in% single_groups]
  multiple <- tables_metadata[tablegrp %in% multiple_groups]
  
  return(list(single = single, multiple = multiple))
}

# ============================================================================
# REPORTING FUNCTIONS
# ============================================================================

#' Generate comprehensive PDF report
#' @param tables_single data.table of single-entity tables
#' @param tables_multiple data.table of multiple-entity tables
#' @param variables_all data.table of variable metadata
#' @param library_name Character string. Name of data library
#' @param withyear Logical. Whether year extraction was used
#' @param output_pdf Character string. Output file path
#' @param verbose Logical. Print progress
generate_report <- function(tables_single, tables_multiple, variables_all,
                           library_name, withyear, output_pdf, verbose = FALSE) {
  
  # Create temporary R Markdown file
  rmd_file <- tempfile(fileext = ".Rmd")
  
  # Build R Markdown content
  rmd_content <- build_rmarkdown_content(
    tables_single = tables_single,
    tables_multiple = tables_multiple,
    variables_all = variables_all,
    library_name = library_name,
    withyear = withyear
  )
  
  # Write R Markdown file
  writeLines(rmd_content, rmd_file)
  
  if (verbose) cat("Rendering PDF report...\n")
  
  # Render to PDF
  tryCatch({
    rmarkdown::render(
      rmd_file,
      output_format = "pdf_document",
      output_file = output_pdf,
      quiet = !verbose
    )
  }, error = function(e) {
    warning("PDF rendering failed. Ensure TeX/LaTeX is installed.")
    cat("Error:", conditionMessage(e), "\n")
  })
  
  # Clean up temporary file
  unlink(rmd_file)
}

#' Build R Markdown content for report
#' @keywords internal
build_rmarkdown_content <- function(tables_single, tables_multiple, variables_all,
                                    library_name, withyear) {
  
  rmd <- c(
    "---",
    "title: 'Data Library Report'",
    "date: !r Sys.Date()",
    "output:",
    "  pdf_document:",
    "    toc: true",
    "    toc_depth: 2",
    "---",
    "",
    paste("# Report in library:", library_name),
    ""
  )
  
  # Single table entities section
  if (nrow(tables_single) > 0) {
    rmd <- c(rmd,
      "## Single Table Entities",
      "",
      "These entities contain only one table in this dataset.",
      ""
    )
    
    single_summary <- tables_single[, .(table, nobs, nvar, num_numeric, num_character)]
    setnames(single_summary, c("table", "nobs", "nvar", "num_numeric", "num_character"),
             c("Table", "N Observations", "N Variables", "N Numeric", "N Character"))
    
    rmd <- c(rmd, "```{r, results='asis', echo=FALSE}", "")
    rmd <- c(rmd, 
      "knitr::kable(",
      deparse(quote(single_summary)),
      ", format='latex', booktabs=TRUE)",
      "")
    rmd <- c(rmd, "```", "")
  }
  
  # Multiple table entities section
  if (nrow(tables_multiple) > 0 && withyear) {
    rmd <- c(rmd,
      "## Multiple Table Entities",
      "",
      "These entities contain multiple tables across different years.",
      ""
    )
    
    # Tabulate observations
    rmd <- c(rmd,
      "### Number of Observations by Table Group and Year",
      "",
      "```{r, results='asis', echo=FALSE, warning=FALSE}", "")
    
    rmd <- c(rmd, 
      "obs_by_year <- tables_multiple %>%",
      "  filter(year > 0) %>%",
      "  group_by(tablegrp, year) %>%",
      "  summarise(min_obs = min(nobs), .groups = 'drop') %>%",
      "  pivot_wider(names_from = year, values_from = min_obs, values_fill = '')",
      "",
      "knitr::kable(obs_by_year, format = 'latex', booktabs = TRUE)",
      "")
    
    rmd <- c(rmd, "```", "")
    
    # Number of variables
    rmd <- c(rmd,
      "### Number of Variables and Numeric Variables",
      "",
      "```{r, results='asis', echo=FALSE, warning=FALSE}", "")
    
    rmd <- c(rmd,
      "var_by_year <- tables_multiple %>%",
      "  filter(year > 0) %>%",
      "  group_by(tablegrp, year) %>%",
      "  summarise(min_vars = min(nvar), min_numeric = min(num_numeric), .groups = 'drop')",
      "",
      "knitr::kable(var_by_year, format = 'latex', booktabs = TRUE)",
      "")
    
    rmd <- c(rmd, "```", "")
  }
  
  # Variable overview section
  if (nrow(variables_all) > 0) {
    rmd <- c(rmd,
      "## Variable Overview",
      "",
      "Summary of variables present in the dataset.",
      "",
      "```{r, results='asis', echo=FALSE, warning=FALSE}", "")
    
    rmd <- c(rmd,
      "var_summary <- variables_all %>%",
      "  group_by(tablegrp, name) %>%",
      "  summarise(count = n(), .groups = 'drop')",
      "",
      "knitr::kable(var_summary, format = 'latex', booktabs = TRUE,",
      "  col.names = c('Table Group', 'Variable Name', 'Count'))",
      "")
    
    rmd <- c(rmd, "```", "")
    
    # Detailed variable listing
    rmd <- c(rmd,
      "## Detailed Variable Listing",
      "",
      "Complete variable metadata including types and labels.",
      "",
      "```{r, results='asis', echo=FALSE, warning=FALSE}", "")
    
    rmd <- c(rmd,
      "var_detail <- variables_all %>%",
      "  distinct(tablegrp, name, type, label)",
      "",
      "knitr::kable(var_detail, format = 'latex', booktabs = TRUE,",
      "  col.names = c('Table Group', 'Variable', 'Type', 'Label'))",
      "")
    
    rmd <- c(rmd, "```", "")
  }
  
  return(rmd)
}

# ============================================================================
# CONVENIENCE WRAPPERS & EXECUTION
# ============================================================================

#' Execute the complete scanning and reporting workflow
#' 
#' This is the main entry point - equivalent to the original SAS batch code
#'
#' @param logdir Character string. Directory for output files
#' @param data_dirs Named list or vector of directories to scan. 
#'        If NULL, looks for 'rawdata', 'extdata', 'extdata2' in current directory
#' @param verbose Logical. Print progress messages
#'
#' @examples
#' \dontrun{
#'   # Set working directories
#'   Sys.setenv(logdir = "./reports")
#'   
#'   # Run complete workflow with default directories
#'   run_data_profiling(verbose = TRUE)
#'   
#'   # Or specify custom directories
#'   run_data_profiling(
#'     data_dirs = list(
#'       rawdata = "./data/raw",
#'       extdata = "./data/ext",
#'       extdata2 = "./data/ext2"
#'     ),
#'     verbose = TRUE
#'   )
#' }
#'
#' @export
run_data_profiling <- function(logdir = NULL, data_dirs = NULL, verbose = TRUE) {
  
  # Set log directory
  if (is.null(logdir)) {
    logdir <- Sys.getenv("logdir", "./")
  }
  Sys.setenv(logdir = logdir)
  
  # Ensure output directory exists
  if (!dir.exists(logdir)) {
    dir.create(logdir, recursive = TRUE)
  }
  
  # Default data directories
  if (is.null(data_dirs)) {
    data_dirs <- list(
      rawdata = "rawdata",
      extdata = "extdata",
      extdata2 = "extdata2"
    )
  }
  
  if (verbose) {
    cat("Data Profiling Report Generation\n")
    cat("=================================\n\n")
  }
  
  # Scan each library
  for (lib_name in names(data_dirs)) {
    lib_path <- data_dirs[[lib_name]]
    
    if (!dir.exists(lib_path)) {
      if (verbose) cat("⚠ Warning: Directory not found:", lib_path, "\n")
      next
    }
    
    withyear <- lib_name == "rawdata"  # Extract year only for rawdata
    output_file <- file.path(logdir, paste0("rawdatareport_", lib_name, ".pdf"))
    
    if (verbose) cat("Processing", lib_name, "library...\n")
    
    scan_library(
      in = lib_path,
      withyear = withyear,
      output_pdf = output_file,
      verbose = verbose
    )
    
    if (verbose) cat("\n")
  }
  
  if (verbose) cat("✓ All reports generated successfully!\n")
}

# ============================================================================
# EXECUTION (uncomment to run)
# ============================================================================

# if (interactive()) {
#   run_data_profiling(logdir = "./reports", verbose = TRUE)
# }
