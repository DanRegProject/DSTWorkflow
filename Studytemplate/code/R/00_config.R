# ============================================================================
# DST Workflow - R Translation
# Configuration Layer (replaces master.sas & common.sas)
# ============================================================================
# This file defines global project configuration, data sources, and indicators
# Load this first before running other scripts

# install if needed:
# install.packages(c('haven', 'data.table', 'tidyverse', 'lubridate', 'glue'))

library(haven)        # Read SAS files
library(data.table)   # Efficient data manipulation
library(tidyverse)    # Data wrangling
library(lubridate)    # Date handling
library(glue)         # String interpolation

# ============================================================================
# 1. PROJECT CONFIGURATION
# ============================================================================

config <- list(
  # Project paths
  project_number = "012345",
  global_project = "xxxxx",
  global_project_path = "X:/Projekter/xxxxx",
  
  project_name = "PXXX_yyyyyy",
  project_owner_initials = "QQQ",
  project_description = "Template project",
  project_date = Sys.Date(),
  
  project_path = "X:/Projekter/xxxxx/projects/PXXX_yyyyyy",
  project_start_year = 1977,
  
  # Data paths
  master_lib_path = "D:/data/Workdata/012345/data/SAS/Master",
  risk_lib_path = "D:/data/Workdata/012345/data/SAS/RISKData2",
  
  local_work_dir = "X:/Projekter/xxxxx/projects/PXXX_yyyyyy/tempdata/R",
  local_final_dir = "X:/Projekter/xxxxx/projects/PXXX_yyyyyy/data/R",
  local_code_dir = "X:/Projekter/xxxxx/projects/PXXX_yyyyyy/code/R",
  local_log_dir = "X:/Projekter/xxxxx/projects/PXXX_yyyyyy/out",
  
  # Global date range
  global_end = as.Date("2099-12-31"),
  year_in_days = 365.25,
  
  # Logging
  create_log = TRUE,
  create_timelog = TRUE,
  sql_max = "max",
  
  # Available years for data (adjust based on your data)
  available_years = 1977:2024
)

# Create output directories if they don't exist
dir.create(config$local_work_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(config$local_final_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(config$local_log_dir, recursive = TRUE, showWarnings = FALSE)

# ============================================================================
# 2. DATA SOURCE DEFINITIONS
# ============================================================================
# These replace %datasourceDef() from common.sas
# Each source defines table structure and column mappings

sources <- list(
  
  # LPR (Landspatientregistret - National Hospital Register)
  LPR = list(
    head = "LPR",
    primary_prefix = "ADM",      # LPRprim=ADM
    diag_table = "DIAG",         # LPRdiag=DIAG
    opr_table = "SKS_OPR",        # LPRopr=SKS_OPR
    ube_table = "SKS_UBE",        # LPRube=SKS_UBE
    
    key_col = "kontakt_id",
    code_col_diag = "diag",
    code_col_opr = "proc",
    code_col_ube = "proc",
    date_col_diag = "start",
    date_col_opr = "start_proc",
    date_col_ube = "start_proc",
    
    std_cols_diag = c("pnr", "start", "slut", "prioritet", "diag", "diagtype", "kontakt_id", "forloeb_id"),
    std_cols_opr = c("pnr", "start", "start_proc", "proc", "proctype", "kontakt_id"),
    std_cols_ube = c("pnr", "start", "start_proc", "proc", "proctype", "kontakt_id"),
    
    sources = c("LPR", "PSYK", "PRIV", "LPR3")
  ),
  
  # DIAG (Diagnosis data)
  DIAG = list(
    head = "DIAG",
    key_col = "kontakt_id",
    code_col = "diag",
    date_col = "start",
    std_cols = c("pnr", "start", "slut", "prioritet", "diag", "diagtype", "kontakt_id", "forloeb_id")
  ),
  
  # OPR (Operations/Procedures)
  OPR = list(
    head = "OPR",
    key_col = "kontakt_id",
    code_col = "proc",
    date_col = "start_proc",
    std_cols = c("pnr", "start", "start_proc", "proc", "proctype", "kontakt_id")
  ),
  
  # UBE (Procedures/Investigations)
  UBE = list(
    head = "UBE",
    key_col = "kontakt_id",
    code_col = "proc",
    date_col = "start_proc",
    std_cols = c("pnr", "start", "start_proc", "proc", "proctype", "kontakt_id")
  ),
  
  # LMDB (Lægemiddeldatabasen - Medicine prescription database)
  LMDB = list(
    head = "LMDB",
    primary_prefix = "LMDB",
    key_col = NULL,
    code_col = "atc",
    date_col = "eksd",
    std_cols = c("pnr", "eksd", "atc")
  ),
  
  # LAB (Laboratory data)
  LAB = list(
    head = "LAB",
    primary_prefix = "LAB_DM_FORSKER",
    key_col = NULL,
    code_col = NULL,
    date_col = NULL,
    std_cols = c("pnr")  # Modify based on actual LAB structure
  ),
  
  # PATO (Pathology data)
  PATO = list(
    head = "PATO",
    primary_prefix = "fctrekvisition",
    data_table = "dimpatologiskdiagnose",
    data_table_2 = "fctpatologiskprocedure",
    key_col = "dw_ek_rekvisition",
    code_col = "diagnose_snomed_kode",
    date_col = "dato_rekvirering",
    std_cols = c("pnr", "dw_ek_rekvisition", "dato_rekvirering", "diagnose_snomed_kode", 
                 "diagnose_snomed_sekvensnummer", "instans_undersogende")
  ),
  
  # CAR (Cancer Register)
  CAR = list(
    head = "CAR",
    primary_prefix = "tumor_aarlig",
    key_col = NULL,
    code_col = "diagnose",
    date_col = NULL,
    std_cols = c("pnr", "diagnose")
  )
)

# ============================================================================
# 3. INDICATOR DEFINITIONS
# ============================================================================
# These replace %IndicatorDef() calls from local_codes.sas
# Structure: list of lists with code definitions

indicators <- list(
  # Example structure (replace with actual indicators from your study)
  # DIAG_slemdiag = list(
  #   type = "DIAG",
  #   codes = c("DA666", "DA667"),
  #   label = "det går ondt, av av",
  #   icd8 = "666",
  #   criteria = NULL,
  #   weight = NULL,
  #   weight_days = NULL
  # )
)

# Function to add indicator definitions (similar to %IndicatorDef)
add_indicator <- function(indicators, type, name, codes, label, icd8 = NULL, 
                          criteria = NULL, weight = NULL, weight_days = NULL) {
  
  indicator_name <- paste0(type, "_", name)
  
  indicators[[indicator_name]] <- list(
    type = toupper(type),
    name = name,
    codes = codes,
    label = label,
    icd8 = icd8,
    criteria = criteria,
    weight = weight,
    weight_days = weight_days
  )
  
  return(indicators)
}

# Example usage:
# indicators <- add_indicator(indicators, "DIAG", "cvd", 
#                             codes = c("DI10", "DI11", "DI12"),
#                             label = "Cardiovascular disease",
#                             icd8 = "390 391 392 393 394 395 396 397 398 410 411 412 413 414 415")

# ============================================================================
# 4. BASE POPULATION DEFINITIONS
# ============================================================================
# Define which indicators to use for base population

base_population_config <- list(
  # Set to indicator names to include, or NULL to skip
  diag = NULL,     # c("cvd", "diabetes")
  medi = NULL,     # c("antihypertensive")
  opr = NULL,      # c("cabg")
  ube = NULL,      # c("ct_scan")
  car = NULL,      # c("cancer")
  pato = NULL      # c("pathology_finding")
)

# ============================================================================
# 5. SUPPLEMENTAL DATA CONFIGURATION
# ============================================================================
# Define which registry tables to include for each population member

supplemental_config <- list(
  # Standard CPR data (always included)
  standard_cpr = TRUE,
  
  # Optional full extracts (set to TRUE to include)
  full_socio = FALSE,      # AKM, FAIK, UDDF
  full_sssy = FALSE,       # SSSY, SYSI
  full_car = FALSE,        # Tumor register
  full_pato = FALSE,       # Pathology
  full_lpr = FALSE,        # Full hospital discharge register
  full_lmdb = FALSE,       # Full prescription register
  full_lab = FALSE,        # Full laboratory data
  
  # Selective extracts (define indicators to use)
  diag_all = NULL,         # c("diag1", "diag2")
  medi_all = NULL,         # c("medi1", "medi2")
  opr_all = NULL,
  ube_all = NULL,
  lab_all = NULL,
  car_all = NULL,
  pato_all = NULL,
  hmedi_all = NULL
)

cat("\n=== Configuration loaded ===")
cat("\nProject:", config$project_name)
cat("\nWork directory:", config$local_work_dir)
cat("\nAvailable data sources:", paste(names(sources), collapse = ", "))
cat("\n")
