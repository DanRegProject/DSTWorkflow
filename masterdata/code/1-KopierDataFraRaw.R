install.packages("fastreg")
library(fastreg)
library(dplyr)
library(DBI)

setwd("E:/ProjektDB/OPEN/workdata/710211/Masterdata/code")

saspath<-"E:/ProjektDB/OPEN/workdata/710211/Masterdata/Data/SAS/Master/"
pqtpath<-"E:/ProjektDB/OPEN/workdata/710211/Masterdata/Data/parquet/Master/"
options(
  fastreg.project_rawdata_dir = saspath,
  fastreg.project_workdata_dir = pqtpath
)

pipeline_dir <- fs::path(pqtpath,"conversion_pipeline")
fs::dir_create(pipeline_dir)
fastreg::use_template(path=pipeline_dir)
# herefter rettes config sektionen i _targets.R
# flyt _targets.R og conversion_log.qmd til working dir

#sas_paths <- list_sas_files(saspath)

# kaldet til tar_make kopierer og konverterer alle filer i saspath
targets::tar_make()

fastreg::list_parquet_datasets()
