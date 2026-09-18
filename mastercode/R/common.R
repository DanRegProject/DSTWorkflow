localmacropath<-"mastercode/R/functions/"
source(paste0(localmacropath,"utilities.R"))
source(paste0(localmacropath,"datasources.R"))
source(paste0(localmacropath,"indicators.R"))

add_datasource(
  # data source header (type in indicators, get, merge)                                           
    head="DIAG",
  # hospital data sources for codes 
    source="LPR PRIV PSYK LPR3",
  # Name (Prefix) of source tables with pnr                       
    keytbl="lpr_adm priv_adm psyk_adm lpr_a_kontakt",
  # Name (Prefix) of source tables with data if not in keytbl, optional  
    datatbl="lpr_diag priv_diag psyk_diag lpr_a_diagnose",
  # Name (Prefix) of source tables with supplemental data, optional  
    datatbl2=,
  # Internal key variable linking keytbl and datatbl/datatbl2, optional     
    key="kontakt_id",
  # Code variable optionally used to restrict on codes, optional  
    code="diag",
  # Date variable optionally used to restrict on period, optional  
    date="start",
  # Minimum standard variables to extract, optional 
    # further may be added in %get                    
    select="pnr start slut prioritet diag diagtype kontakt_id forloeb_id"
)
add_datasource(
  # data source header (type in %indicatorDef, %get, %merge)                                          
    head="OPR",
  # hospital data sources for codes 
    source="LPR PRIV LPR3",
  # Name (Prefix) of source tables with pnr                       
    keytbl="lpr_adm priv_adm lpr_a_kontakt",
  # Name (Prefix) of source tables with data if not in keytbl, optional  
    datatbl="lpr_sks_opr priv_sks_opr lpr_a_procedurekonopr",
  # Name (Prefix) of source tables with supplemental data, optional  
    datatbl2=,
  # Internal key variable linking keytbl and datatbl/datatbl2, optional     
    key="kontakt_id",
  # Code variable optionally used to restrict on codes, optional  
    code="proc",
  # Date variable optionally used to restrict on period, optional  
    date="start_proc",
  # Minimum standard variables to extract, optional 
    # further may be added in %get                    
    select="pnr start start_proc proc proctype kontakt_id"
)
add_datasource(
  # data source header (type in %indicatorDef, %get, %merge)                                          
    head="UBE",
  # hospital data sources for codes 
    source="LPR PRIV LPR3",
  # Name (Prefix) of source tables with pnr                       
    keytbl="lpr_adm priv_adm lpr_a_kontakt",
  # Name (Prefix) of source tables with data if not in keytbl, optional  
    datatbl="lpr_sks_ube priv_sks_ube lpr_a_procedurekonube",
  # Name (Prefix) of source tables with supplemental data, optional  
    datatbl2=,
  # Internal key variable linking keytbl and datatbl/datatbl2, optional     
    key="kontakt_id",
  # Code variable optionally used to restrict on codes, optional  
    code="proc",
  # Date variable optionally used to restrict on period, optional  
    date="start_proc",
  # Minimum standard variables to extract, optional 
    # further may be added in %get                    
    select="pnr start start_proc proc proctype kontakt_id"
)
add_datasource(
  # data source header (type in %indicatorDef, %get, %merge)                                          
    head="LMDB",
  # ources for codes 
    source="LMDB",
  # Name (Prefix) of source tables with pnr                       
    keytbl="LMDB",
  # Name (Prefix) of source tables with data if not in keytbl, optional  
    datatbl=,
  # Name (Prefix) of source tables with supplemental data, optional  
    datatbl2=,
  # Internal key variable linking keytbl and datatbl/datatbl2, optional     
    key=,
  # Code variable optionally used to restrict on codes, optional  
    code="atc",
  # Date variable optionally used to restrict on period, optional  
    date="eksd",
  # Minimum standard variables to extract, optional 
    # further may be added in %get                    
    select="pnr eksd atc"
)
add_datasource(
  # data source header (type in %indicatorDef, %get, %merge)                                          
    head="HMDB",
  # data source header (type in %indicatorDef, %get, %merge)                                          
    source="HMDB",
  # Name (Prefix) of source tables with pnr                       
    keytbl="indberetningmedpris",
  # Name (Prefix) of source tables with data if not in keytbl, optional  
    datatbl=,
  # Name (Prefix) of source tables with supplemental data, optional  
    datatbl2=,
  # Internal key variable linking keytbl and datatbl/datatbl2, optional     
    key=,
  # Code variable optionally used to restrict on codes, optional  
    code="atc",
  # Date variable optionally used to restrict on period, optional  
    date="adm",
  # Minimum standard variables to extract, optional 
    # further may be added in %get                    
    select="pnr adm atc"
);
add_datasource(
  # data source header (type in %indicatorDef, %get, %merge)                                          
    head="LAB",
  # data source header (type in %indicatorDef, %get, %merge)                                          
    source="LAB",
  # Name (Prefix) of source tables with pnr                       
    keytbl="LAB_DM_FORSKER",
  # Name (Prefix) of source tables with data if not in keytbl, optional  
    datatbl=,
  # Name (Prefix) of source tables with supplemental data, optional  
    datatbl2=,
  # Internal key variable linking keytbl and datatbl/datatbl2, optional     
    key=,
  # Code variable optionally used to restrict on codes, optional  
    code=,
  # Date variable optionally used to restrict on period, optional  
    date=,
  # Minimum standard variables to extract, optional 
    # further may be added in %get                    
    select=
)
add_datasource(
  # data source header (type in %indicatorDef, %get, %merge)                                          
    head="PATO",
  # data source header (type in %indicatorDef, %get, %merge)                                          
    source="PATO",
  # Name (Prefix) of source tables with pnr                       
    keytbl="fctrekvisition",
  # Name (Prefix) of source tables with data if not in keytbl, optional  
    datatbl="dimpatologiskdiagnose",
  # Name (Prefix) of source tables with supplemental data, optional  
    datatbl2="fctpatologiskprocedure",
  # Internal key variable linking keytbl and datatbl/datatbl2, optional     
    key="dw_ek_rekvisition",
  # Code variable optionally used to restrict on codes, optional  
    code="diagnose_snomed_kode",
  # Date variable optionally used to restrict on period, optional  
    date="dato_rekvirering",
  # Minimum standard variables to extract, optional 
    # further may be added in %get                    
    select="pnr dw_ek_rekvisition dato_rekvirering diagnose_snomed_kode diagnose_snomed_sekvensnummer instans_undersogende materialenummer anden_specialprocedure hasteprocedure materiale_antal materialetype specielle_analyser
")
add_datasource(
  # data source header (type in %indicatorDef, %get, %merge)                                          
    head="CAR",
  # data source header (type in %indicatorDef, %get, %merge)                                          
    source="CAR",
  # Name (Prefix) of source tables with pnr                       
    keytbl="tumor_aarlig",
  # Name (Prefix) of source tables with data if not in keytbl, optional  
    datatbl=,
  # Name (Prefix) of source tables with supplemental data, optional  
    datatbl2=,
  # Internal key variable linking keytbl and datatbl/datatbl2, optional     
    key=,
  # Code variable optionally used to restrict on codes, optional  
    code="diagnose",
  # Date variable optionally used to restrict on period, optional  
    date=,
  # Minimum standard variables to extract, optional 
    # further may be added in %get                    
    select=
)
add_datasource(
  # data source header (type in %indicatorDef, %get, %merge)                                          
    head="FAIK",
  # data source header (type in %indicatorDef, %get, %merge)                                          
    source="FAIK",
  # Name (Prefix) of source tables with pnr                       
    keytbl="BEF",
  # Name (Prefix) of source tables with data if not in keytbl, optional  
    datatbl="FAIK",
  # Name (Prefix) of source tables with supplemental data, optional  
    datatbl2=,
  # Internal key variable linking keytbl and datatbl/datatbl2, optional     
    key="familie_id",
  # Code variable optionally used to restrict on codes, optional  
    code=,
  # Date variable optionally used to restrict on period, optional  
    date=,
  # Minimum standard variables to extract, optional 
    # further may be added in %get                    
    select="pnr familie_id famaekvivadisp_13 famsociogrup_13"
)
add_datasource(
  # data source header (type in %indicatorDef, %get, %merge)                                          
    head="BEF",
  # data source header (type in %indicatorDef, %get, %merge)                                          
    source="BEF",
  # Name (Prefix) of source tables with pnr                       
    keytbl="BEF",
  # Name (Prefix) of source tables with data if not in keytbl, optional  
    datatbl=,
  # Name (Prefix) of source tables with supplemental data, optional  
    datatbl2=,
  # Internal key variable linking keytbl and datatbl/datatbl2, optional     
    key=,
  # Code variable optionally used to restrict on codes, optional  
    code=,
  # Date variable optionally used to restrict on period, optional  
    date=,
  # Minimum standard variables to extract, optional 
    # further may be added in %get                    
    select="pnr civst"
)
add_datasource(
  # data source header (type in %indicatorDef, %get, %merge)                                          
    head="AKM",
  # data source header (type in %indicatorDef, %get, %merge)                                          
    source="AKM",
  # Name (Prefix) of source tables with pnr                       
    keytbl="AKM",
  # Name (Prefix) of source tables with data if not in keytbl, optional  
    datatbl=,
  # Name (Prefix) of source tables with supplemental data, optional  
    datatbl2=,
  # Internal key variable linking keytbl and datatbl/datatbl2, optional     
    key=,
  # Code variable optionally used to restrict on codes, optional  
    code=,
  # Date variable optionally used to restrict on period, optional  
    date=,
  # Minimum standard variables to extract, optional 
    # further may be added in %get                    
    select="pnr besks13 socio13"
)
add_datasource(
  # data source header (type in %indicatorDef, %get, %merge)                                          
    head="UDD",
  # data source header (type in %indicatorDef, %get, %merge)                                          
    source="UDD",
  # Name (Prefix) of source tables with pnr                       
    keytbl="UDDF",
  # Name (Prefix) of source tables with data if not in keytbl, optional  
    datatbl=,
  # Name (Prefix) of source tables with supplemental data, optional  
    datatbl2=,
  # Internal key variable linking keytbl and datatbl/datatbl2, optional     
    key=,
  # Code variable optionally used to restrict on codes, optional  
    code=,
  # Date variable optionally used to restrict on period, optional  
    date="hf_vcfra",
  # Minimum standard variables to extract, optional 
    # further may be added in %get                    
    select="pnr hfaudd"
)


source(paste0(localmacropath,"../indicators/diag_codes.R"))
source(paste0(localmacropath,"../indicators/opr_codes.R"))
source(paste0(localmacropath,"../indicators/ube_codes.R"))
source(paste0(localmacropath,"../indicators/lmdb_codes.R"))
source(paste0(localmacropath,"../indicators/charlson_codes.R"))
source(paste0(localmacropath,"../indicators/cha2ds2_vasc_codes.R"))
# der mangler koder i diag_codes og lmdb_codes, der skal tages udgangspunkt i versioner på DS 
#source(paste0(localmacropath,"../indicators/hasbled_codes.R"))
#source(paste0(localmacropath,"../indicators/segal_codes.R"))
#source(paste0(localmacropath,"../indicators/hfdiabhyp_codes.R"))
#source(paste0(localmacropath,"../indicators/hrfs_codes"))
