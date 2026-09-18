# Segal (DIAG)

add_indicator(
  type      = "DIAG",
  name      = "segal1",
  short_txt = "Parkinson",
  code      = "G20",
  icd8      = "",
  w         = 0.5
)

add_indicator(
  type      = "DIAG",
  name      = "segal2",
  short_txt = "Impaired mobility",
  code      = "R26 Z74 Z75 Z993",
  icd8      = "",
  w         = 1.24
)

add_indicator(
  type      = "DIAG",
  name      = "segal3",
  short_txt = "Depression, wide def.",
  code      = "F204 F251 F31 F32 F33 F341 F38 F41 F43 F44 F920 T43 Y490 Y492",
  icd8      = "",
  w         = 0.54
)

clone_indicator(
  from_type      = "DIAG",
  to_name      = "segal4",
  from_name = "hf2",
  w         = 0.50
)

add_indicator(
  type      = "DIAG",
  name      = "segal5",
  short_txt = "Arthritis (any type)",
  code      = "M0 M1 M20 M21 M22 M23 M24 M32 M33 M34 M35 M36 M43 M6 M70 M71 M72 M75 M76 M77 M78 M79 R26 R29 Z87",
  icd8      = "",
  w         = 0.43
)

add_indicator(
  type      = "DIAG",
  name      = "segal6",
  short_txt = "Cognitive impairment",
  code      = "F0 G30 G31 R41 R46 Z032",
  icd8      = "",
  w         = 0.33
)

add_indicator(
  type      = "DIAG",
  name      = "segal7",
  short_txt = "Stroke (wide def)",
  code      = "I6",
  icd8      = "",
  w         = 0.28
)

add_indicator(
  type      = "DIAG",
  name      = "segal8",
  short_txt = "Paranoia",
  code      = "F06 F20 F21 F22 F23 F24 F25 F28 F29 F32 F33 F44 F600",
  icd8      = "",
  w         = 0.24
)

add_indicator(
  type      = "DIAG",
  name      = "segal9",
  short_txt = "Chronic skin ulcer",
  code      = "L89 L97 L98",
  icd8      = "",
  w         = 0.23
)

add_indicator(
  type      = "DIAG",
  name      = "segal10",
  short_txt = "Pneumonia (wide def)",
  code      = "A221 A37 A481 B250 B440 B778 J1 J69",
  icd8      = "",
  w         = 0.21
)

add_indicator(
  type      = "DIAG",
  name      = "segal11",
  short_txt = "Skin and soft tissue infection",
  code      = "A20 A21 A22 A31 A36 A46 L0 L10 L88 L98 K12 E83",
  icd8      = "",
  w         = 0.18
)

add_indicator(
  type      = "DIAG",
  name      = "segal12",
  short_txt = "Mycoses",
  code      = "B35 B36 B37 B38 B39 B4",
  icd8      = "",
  w         = 0.14
)

add_indicator(
  type      = "DIAG",
  name      = "segal13",
  short_txt = "Gout or other crystal-induced arthopathy",
  code      = "M10 M11 N20",
  icd8      = "",
  w         = 0.08
)

add_indicator(
  type      = "DIAG",
  name      = "segal14",
  short_txt = "Falls",
  code      = "W0 W1",
  icd8      = "",
  w         = 0.08
)

add_indicator(
  type      = "DIAG",
  name      = "segal15",
  short_txt = "Muscoloskeletal problems",
  code      = "E106F E116F G45 M R29 Z783",
  icd8      = "",
  w         = 0.05
)

add_indicator(
  type      = "DIAG",
  name      = "segal16",
  short_txt = "Urinary tract infection (wide def)",
  code      = "A368 N10 N11 N12 N15 N16 N288 N30 N34 N35 N390",
  icd8      = "",
  w         = 0.05
)

# Segal (CPR)

add_indicator(
  type      = "CPR",
  name      = "segal1",
  short_txt = "Age",
  code      = "empty",
  icd8      = "",
  w         = 0.09,
  crit      = "((MCSDate - birthdate)/365)"          # som tekst, som du fortolker i din score-funktion
)

add_indicator(
  type      = "CPR",
  name      = "segal2",
  short_txt = "Male sex",
  code      = "empty",
  icd8      = "",
  w         = -0.19,
  crit      = "(sex == 0)"
)

add_indicator(
  type      = "CPR",
  name      = "segal3",
  short_txt = "White Race",
  code      = "empty",
  icd8      = "",
  w         = -0.49,
  crit      = "1"
)

# Segal (OTH)

add_indicator(
  type      = "OTH",
  name      = "segal1",
  short_txt = "Intercept",
  code      = "empty",
  icd8      = "",
  w         = -9,
  crit      = "1"
)

add_indicator(
  type      = "OTH",
  name      = "segal2",
  short_txt = "Admission past 6 mo",
  code      = "empty",
  icd8      = "",
  w         = 0.09,
  crit      = "((MCSDate - indate)/30.4) < 6"
)

add_indicator(
  type      = "OTH",
  name      = "segal3",
  short_txt = "Charlson >0",
  code      = "empty",
  icd8      = "",
  w         = 0.31,
  crit      = "(CharlsonMCSDate > 0)"   # tilpas navn efter din R-implementering
)