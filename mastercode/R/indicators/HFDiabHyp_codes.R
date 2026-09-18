# Heart failure – Medi (LMDB)

clone_indicator(
  from_type      = "LMDB",
  from_name      = loop,
  to_name        = "HeartFailMedi1",
  w              = 1
)

clone_indicator(
  from_type      = "LMDB",
  from_name      = "Renin",
  to_name        = "HeartFailMedi2",
  w              = 1
)

# Heart failure – Diag (DIAG)

clone_indicator(
  from_type      = "DIAG",
  to_name        = "HeartFailDiag1",
  from_name      = "HFStr",
  w              = 1
)

# Diabetes – Medi (LMDB)

clone_indicator(
  from_type      = "LMDB",
  to_nam    = "DiabetesMedi1",
  from_name = "DiabetesATC",
  w         = 1
)

# Diabetes – Diag (DIAG)

clone_indicator(
  from_type      = "DIAG",
  to_name      = "DiabetesDiag1",
  from_name = "DiabLPR",
  w         = 1
)

# Hypertension – Medi (LMDB)

clone_indicator(
  from_type      = "LMDB",
  to_name      = "HypertensionMedi1",
  from_name = "Alfa",
  w         = 1
)

clone_indicator(
  from_type      = "LMDB",
  to_name      = "HypertensionMedi2",
  from_name = "Nonloop",
  w         = 1
)

clone_indicator(
  from_type      = "LMDB",
  to_name      = "HypertensionMedi3",
  from_name = "Vaso",
  w         = 1
)

clone_indicator(
  from_type      = "LMDB",
  to_name      = "HypertensionMedi4",
  from_name = "Beta",
  w         = 1
)

clone_indicator(
  from_type      = "LMDB",
  to_name      = "HypertensionMedi5",
  from_name = "Calcium",
  w         = 1
)

clone_indicator(
  from_type      = "LMDB",
  to_name      = "HypertensionMedi6",
  from_name = "Renin",
  w         = 1
)

# Hypertension – Diag (DIAG)

clone_indicator(
  from_type      = "DIAG",
  to_name      = "HypertensionDiag1",
  from_name = "HypLPR",
  w         = 1
)

# Combination drugs Hypertension (LMDB)

add_indicator(
  type      = "LMDB",
  name      = "CombHypertensionMedi1",
  short_txt = "Combination drugs Hypertension",
  code      = "C09BB04 C09DA C09DB C09CX01 C09DX04 C07B",
  icd8      = "",
  w         = 1
)