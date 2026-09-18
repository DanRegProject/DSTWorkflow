# HFRS intercept (OTH)

add_indicator(
  type      = "OTH",
  name      = "HFRS1",
  short_txt = "Intercept",
  code      = "empty",
  icd8      = "",
  w         = 0,
  crit      = "1"
)

# HFRS (DIAG) – et udvalg, resten følger samme mønster

add_indicator(
  type      = "DIAG",
  name      = "HFRS1",
  short_txt = "Bacterial intest infect",
  code      = "A04",
  icd8      = "",
  w         = 1.1
)

add_indicator(
  type      = "DIAG",
  name      = "HFRS2",
  short_txt = "Diarrhoea infectious",
  code      = "A09",
  icd8      = "",
  w         = 1.1
)

add_indicator(
  type      = "DIAG",
  name      = "HFRS3",
  short_txt = "Other Septicaemia",
  code      = "A41",
  icd8      = "",
  w         = 1.6
)

add_indicator(
  type      = "DIAG",
  name      = "HFRS4",
  short_txt = "Streptococcus",
  code      = "B95",
  icd8      = "",
  w         = 1.7
)

add_indicator(
  type      = "DIAG",
  name      = "HFRS5",
  short_txt = "Other bacterial agents as cause",
  code      = "B96",
  icd8      = "",
  w         = 2.9,
  crit      = 'diagtype == "B"'
)

# ... fortsæt tilsvarende for HFRS6–HFRS101 ...

add_indicator(
  type      = "DIAG",
  name      = "HFRS101",
  short_txt = "Enabling devices dependency",
  code      = "Z99",
  icd8      = "",
  w         = 0.8
)