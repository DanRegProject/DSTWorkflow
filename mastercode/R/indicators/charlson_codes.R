# Charlson weight 1
add_indicator(
  type      = "DIAG",
  name      = "charlson1",
  short_txt = "Myocardial infarction",
  code      = "I21 I22 I23",
  icd8      = "410",
  w         = 1
)

add_indicator(
  type      = "DIAG",
  name      = "charlson2",
  short_txt = "Congestive heart failure",
  code      = "I50 I110 I130 I132",
  icd8      = "42709 42710 42711 42719 42899 78249",
  w         = 1
)

add_indicator(
  type      = "DIAG",
  name      = "charlson3",
  short_txt = "Peripheral vascular disease",
  code      = "I70 I71 I72 I73 I74 I77",
  icd8      = "440 441 442 443 444 445",
  w         = 1
)

add_indicator(
  type      = "DIAG",
  name      = "charlson4",
  short_txt = "Cerebrovasvular disease",
  code      = "I60 I61 I62 I63 I64 I65 I66 I67 I68 I69 G45 G46",
  icd8      = "430 431 432 433 434 435 436 437 438",
  w         = 1
)

add_indicator(
  type      = "DIAG",
  name      = "charlson5",
  short_txt = "Dementia",
  code      = "F00 F01 F02 F03 F051 G30",
  icd8      = "29009 29010 29011 29012 29013 29014 29015 29016 29017 29018 29019 29309",
  w         = 1
)

add_indicator(
  type      = "DIAG",
  name      = "charlson6",
  short_txt = "Chronic Pulmonary disease",
  code      = "J40 J41 J42 J43 J44 J45 J46 J47 J60 J61 J62 J63 J64 J65 J66 J67 J684 J701 J703 J841 J920 J961 J982 J983",
  icd8      = "490 491 492 493 515 516 517 518", 
  w         = 1
)

add_indicator(
  type      = "DIAG",
  name      = "charlson7",
  short_txt = "Connective tissue disease",
  code      = "M05 M06 M08 M09 M30 M31 M32 M33 M34 M35 M36 D86",
  icd8      = "712 716 734 446 13599",
  w         = 1
)

add_indicator(
  type      = "DIAG",
  name      = "charlson8",
  short_txt = "Ulcer disease",
  code      = "K221 K25 K26 K27 K28",
  icd8      = "53091 53098 531 532 533 534",
  w         = 1
)

add_indicator(
  type      = "DIAG",
  name      = "charlson9",
  short_txt = "Mild liver disease",
  code      = "B18 K700 K701 K702 K703 K709 K71 K73 K74 K760",
  icd8      = "571 57301 57304",
  w         = 1
)

add_indicator(
  type      = "DIAG",
  name      = "charlson10",
  short_txt = "Diabetes Mellitus",
  code      = "E100 E101 E109 E110 E111 E119",
  icd8      = "249 250",
  w         = 1
)

# Charlson weight 2
add_indicator(
  type      = "DIAG",
  name      = "charlson11",
  short_txt = "Hemiplegia",
  code      = "G81 G82",
  icd8      = "344",
  w         = 2
)

add_indicator(
  type      = "DIAG",
  name      = "charlson12",
  short_txt = "Moderate/severe renal disease",
  code      = "I12 I13 N00 N01 N02 N03 N04 N05 N07 N11 N14 N17 N18 N19 Q61",
  icd8      = "403 404 580 581 582 583 584 59009 59319 7531 792",
  w         = 2
)

add_indicator(
  type      = "DIAG",
  name      = "charlson13",
  short_txt = "Diabetes Mellitus with chronic complications",
  code      = "E102 E103 E104 E105 E106 E107 E108 E112 E113 E114 E115 E116 E117 E118",
  icd8      = "24901 24902 24903 24904 24905 24908 25001 25002 25003 25004 25005 25008",  
  w         = 2
)

add_indicator(
  type      = "DIAG",
  name      = "charlson14",
  short_txt = "Any tumor",
  code      = "C0 C1 C2 C3 C4 C5 C6 C70 C71 C72 C73 C74 C75",
  icd8      = "14 15 16 17 18 190 191 192 193 194",
  w         = 2
)

add_indicator(
  type      = "DIAG",
  name      = "charlson15",
  short_txt = "Leukemia",
  code      = "C91 C92 C93 C94 C95",
  icd8      = "204 205 206 207",
  w         = 2
)

add_indicator(
  type      = "DIAG",
  name      = "charlson16",
  short_txt = "Lymphoma",
  code      = "C81 C82 C83 C84 C85 C88 C90 C96",
  icd8      = "200 201 202 203 27559",
  w         = 2
)

# Charlson weight 3
add_indicator(
  type      = "DIAG",
  name      = "charlson17",
  short_txt = "Moderate/severe liver disease",
  code      = "B150 B160 B162 B190 K704 K72 K766 I85",
  icd8      = "07000 07002 07004 07006 07008 57300 4560",
  w         = 3
)

# Charlson weight 6
add_indicator(
  type      = "DIAG",
  name      = "charlson18",
  short_txt = "Metastatic solid tumor",
  code      = "C76 C77 C78 C79 C80",
  icd8      = "195 196 197 198 199",
  w         = 6
)

add_indicator(
  type      = "DIAG",
  name      = "charlson19",
  short_txt = "AIDS",
  code      = "B21 B22 B23 B24",
  icd8      = "07983",
  w         = 6
)