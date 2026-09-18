# HAS-BLED (DIAG)

clone_indicator(
  from_type      = "DIAG",
  to_name      = "hasbled1",
  from_name      = "renal",   
  w         = 1
)

clone_indicator(
  from_type      = "DIAG",
  to_name      = "hasbled2",
  from_name = "Liver",
  w         = 1
)

add_indicator(
  type      = "DIAG",
  name      = "hasbled3",
  short_txt = "Stroke (IStroke or TIA)",
  code      = c(get_indicator("DIAG","IStroke")$codes,
                get_indicator("DIAG","TIA")$codes),
  icd8      = c(get_indicator("DIAG","IStroke")$icd8,
                get_indicator("DIAG","TIA")$icd8),
  w         = 1
)

add_indicator(
  type      = "DIAG",
  name      = "hasbled4",
  short_txt = "Bleeding",
  code      = c(get_indicator("DIAG","ICBleed")$codes,
                get_indicator("DIAG","IMBleed")$codes,
                get_indicator("DIAG","genBleed")$codes,
                get_indicator("DIAG","OCBleed")$codes),
  icd8      = c(get_indicator("DIAG","ICBleed")$icd8,
                get_indicator("DIAG","IMBleed")$icd8,
                get_indicator("DIAG","genBleed")$icd8,
                get_indicator("DIAG","OCBleed")$icd8),
  w         = 1
)

clone_indicator(
  from_type      = "DIAG",
  to_name      = "hasbled5",
  from_name = "Alco",
  w         = 1,
  wdays     = 180
)

# HAS-BLED (CPR)

add_indicator(
  type      = "CPR",
  name      = "hasbled1",
  short_txt = "Age>=65",
  code      = "empty",
  icd8      = "",
  w         = 1,
  crit      = "((MCSDate - birthdate)/365) >= 65"
)

# HAS-BLED (OTH)

add_indicator(
  type      = "OTH",
  name      = "hasbled1",
  short_txt = "Hypertension (diagnosis or medicated (2+ drugs))",
  code      = "empty",
  icd8      = "",
  w         = 1,
  crit      = "((HypertensionDiagMCSDdate > 0) + (HypertensionMediMCSDdate > 0)) > 0"
)

# HAS-BLED (LMDB)

add_indicator(
  type      = "LMDB",
  name      = "hasbled1",
  short_txt = "Drugs",
  code      = c(get_indicator("LMDB","Aspirin")$codes,
                get_indicator("LMDB","clopi")$codes,
                get_indicator("LMDB","nsaid")$codes),
  w         = 1,
  wdays     = 180
)