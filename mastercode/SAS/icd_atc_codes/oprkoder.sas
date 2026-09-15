/* SVN header
$Date: 2021-01-28 10:52:52 +0100 (to, 28 jan 2021) $
$Revision: 269 $
$Author: fflb6683 $
$Id: OPRkoder.sas 269 2021-01-28 09:52:52Z fflb6683 $
*/
/* Operation codes, use OPR and OPRL prefix', Official codes has prefix K which is omitted */
/* 26/6-2017 removing opr at the end (equal to version on SDS) */

/* A */
/* all - all operations */
%IndicatorDef(OPR, All, "All operations", KA KB KF KG KH KJ KK KL KM KN KP);

/* Arrhyo - heart arrhythm operations */
%IndicatorDef(OPR, Arrhyo, "heart arrhythm operations", KFP);

/* Arrhyt - hjerte rytme operationer */
%IndicatorDef(OPR, Arrhyt, "Hjerte rytme operationer", KFPA KFPB KFPD KFPW);

/* B */
/* C */
/* cabg - Coronary artery bypass graft */
%IndicatorDef(OPR, CABG, "Coronary artery bypass graft", KFNA KFNC KFND KFNE);

/* Caesar / Caesarian section  */
%IndicatorDef(OPR, Caesar, "Caesarian section", KMCA);

/* F */
/* fn */
%IndicatorDef(OPR, fn, "Percutanious coronary intervention or coronary artery bypass craft", KFN);

/* K */
/* kidtra */
%IndicatorDef(OPR, Kidtra, "Kidney transplantation", KKAS00 KKAS10 KKAS20);

/* kneehip - knæ og hofte operation */
%IndicatorDef(OPR, kneehip, "knæ og hofte operation", KNGB KNGC KNGU KNFB KNFC KNFU);

/* L */
/* Lbleedopr - Bleeding in respiratory/thorax (OPR) (LINE)*/
%IndicatorDef(OPR, Lbleedopr, "Bleeding in respiratory/thorax (OPR)", KGWD KGWD02 KGWE);

/* M  */
/* msurg */
%IndicatorDef(OPR, MSurg, "Major surgery", KA KB KD KF KG KH KJ KK KL KM KN KP);

/* P */
/* pci */
%IndicatorDef(OPR, pci, "Percutanious coronary intervention", KFNG);

/* pmicd */
%IndicatorDef(OPR, PMICD, "Pacemaker / ICD operation Kode ophører i brug pr 2001", KFPG KFPE);

/* Probleedopr - Procedure-related bleeding (OPR) (LINE)*/
%IndicatorDef(OPR, Probleedopr, "Procedure-related bleeding (OPR)", KAAB30 KAAD00 KAAD05 KAAD10 KAAD15 KABB40 KAWD KAWD00A KAWE KBWD KBWE KCKD90 KCWD KCWE KDWD KDWE KEWD KEWE KFWD KFWE KGWD KGWD02 KGWE KHWD KHWE KJWD KJWE KKEV KKEV02 KKWD);

/* V */
/* valveo */
%IndicatorDef(OPR, Valveo, "Heart valve operation", KFG KFK KFM);

/* mechvalve - mechanical valve prothesis */
%IndicatorDef(OPR, mechvalve, "mechanical valve prothesis", kfge00 kfkd00 kfjf00 kfmd00);
