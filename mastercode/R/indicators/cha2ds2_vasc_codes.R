# CHA2DS2-VASc (DIAG)

add_indicator(
  type      = "DIAG",
  name      = "cha2ds2vasc1",
  short_txt = "Stroke (IStroke or SE or TIA)",
  code      = c(get_indicator("DIAG","IStroke")$codes,
                get_indicator("DIAG","TIA")$codes,
                get_indicator("DIAG","SE")$codes),
  icd8      = c(get_indicator("DIAG","IStroke")$icd8,
                get_indicator("DIAG","TIA")$icd8,
                get_indicator("DIAG","SE")$icd8),
  w         = 2
)

add_indicator(
  type      = "DIAG",
  name      = "cha2ds2vasc2",
  short_txt = "Vascular disease (MI or PAD3)",
  code      = c(get_indicator("DIAG","MIall")$codes,
                get_indicator("DIAG","PADvasc")$codes),
  icd8      = c(get_indicator("DIAG","MIall")$icd8,
                get_indicator("DIAG","PADvasc")$icd8),
  w         = 1
)

# CHA2DS2-VASc (CPR)

add_indicator(
  type      = "CPR",
  name      = "cha2ds2vasc1",
  short_txt = "Age>=65",
  code      = "empty",
  icd8      = "",
  w         = 1,
  crit      = "((MCSDate - birthdate)/365) >= 65"
)

add_indicator(
  type      = "CPR",
  name      = "cha2ds2vasc2",
  short_txt = "Age>=75",
  code      = "empty",
  icd8      = "",
  w         = 1,
  crit      = "((MCSDate - birthdate)/365) >= 75"
)

add_indicator(
  type      = "CPR",
  name      = "cha2ds2vasc3",
  short_txt = "Female sex",
  code      = "empty",
  icd8      = "",
  w         = 1,
  crit      = "(sex == 1)"
)

# CHA2DS2-VASc (OTH)

add_indicator(
  type      = "OTH",
  name      = "cha2ds2vasc1",
  short_txt = "Heart failure (diagnosis or medicated (2+ drugs))",
  code      = "empty",
  icd8      = "",
  w         = 1,
  crit      = "((HeartFailDiagMCSDdate > 0) + (HeartFailMediMCSDdate > 0)) > 0"
)

add_indicator(
  type      = "OTH",
  name      = "cha2ds2vasc2",
  short_txt = "Hypertension (diagnosis or medicated (2pt))",
  code      = "empty",
  icd8      = "",
  w         = 1,
  crit      = "((HypertensionDiagMCSDdate > 0) + (HypertensionMediMCSDdate > 0)) > 0"
)

add_indicator(
  type      = "OTH",
  name      = "cha2ds2vasc3",
  short_txt = "Diabetes (diagnosis or medicated (2+ drugs))",
  code      = "empty",
  icd8      = "",
  w         = 1,
  crit      = "((DiabetesDiagMCSDdate > 0) + (DiabetesMediMCSDdate > 0)) > 0"
)