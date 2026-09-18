# A
# all - all operations
add_indicator(
  type      = "OPR",
  name      = "All",
  short_txt = "All operations",
  code      = "KA KB KF KG KH KJ KK KL KM KN KP"
)

# Arrhyo - heart arrhythm operations
add_indicator(
  type      = "OPR",
  name      = "Arrhyo",
  short_txt = "heart arrhythm operations",
  code      = "KFP"
)

# Arrhyt - hjerte rytme operationer
add_indicator(
  type      = "OPR",
  name      = "Arrhyt",
  short_txt = "Hjerte rytme operationer",
  code      = "KFPA KFPB KFPD KFPW"
)

# C
# cabg - Coronary artery bypass graft
add_indicator(
  type      = "OPR",
  name      = "CABG",
  short_txt = "Coronary artery bypass graft",
  code      = "KFNA KFNC KFND KFNE"
)

# Caesar / Caesarian section
add_indicator(
  type      = "OPR",
  name      = "Caesar",
  short_txt = "Caesarian section",
  code      = "KMCA"
)

# F
# fn
add_indicator(
  type      = "OPR",
  name      = "fn",
  short_txt = "Percutanious coronary intervention or coronary artery bypass craft",
  code      = "KFN"
)

# K
# kidtra
add_indicator(
  type      = "OPR",
  name      = "Kidtra",
  short_txt = "Kidney transplantation",
  code      = "KKAS00 KKAS10 KKAS20"
)

# kneehip - knæ og hofte operation
add_indicator(
  type      = "OPR",
  name      = "kneehip",
  short_txt = "knæ og hofte operation",
  code      = "KNGB KNGC KNGU KNFB KNFC KNFU"
)

# L
# Lbleedopr - Bleeding in respiratory/thorax (OPR)
add_indicator(
  type      = "OPR",
  name      = "Lbleedopr",
  short_txt = "Bleeding in respiratory/thorax (OPR)",
  code      = "KGWD KGWD02 KGWE"
)

# M
# msurg
add_indicator(
  type      = "OPR",
  name      = "MSurg",
  short_txt = "Major surgery",
  code      = "KA KB KD KF KG KH KJ KK KL KM KN KP"
)

# P
# pci
add_indicator(
  type      = "OPR",
  name      = "pci",
  short_txt = "Percutanious coronary intervention",
  code      = "KFNG"
)

# pmicd
add_indicator(
  type      = "OPR",
  name      = "PMICD",
  short_txt = "Pacemaker / ICD operation Kode ophører i brug pr 2001",
  code      = "KFPG KFPE"
)

# Probleedopr - Procedure-related bleeding (OPR)
add_indicator(
  type      = "OPR",
  name      = "Probleedopr",
  short_txt = "Procedure-related bleeding (OPR)",
  code      = paste(
    "KAAB30 KAAD00 KAAD05 KAAD10 KAAD15",
    "KABB40 KAWD KAWD00A KAWE",
    "KBWD KBWE",
    "KCKD90 KCWD KCWE",
    "KDWD KDWE",
    "KEWD KEWE",
    "KFWD KFWE",
    "KGWD KGWD02 KGWE",
    "KHWD KHWE",
    "KJWD KJWE",
    "KKEV KKEV02 KKWD"
  )
)

# V
# valveo
add_indicator(
  type      = "OPR",
  name      = "Valveo",
  short_txt = "Heart valve operation",
  code      = "KFG KFK KFM"
)

# mechvalve - mechanical valve prothesis
add_indicator(
  type      = "OPR",
  name      = "mechvalve",
  short_txt = "mechanical valve prothesis",
  code      = "kfge00 kfkd00 kfjf00 kfmd00"
)