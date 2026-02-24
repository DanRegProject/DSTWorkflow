/* SVN header
*/

/* special cases */

/* A */
/* ace - ACE-inhibitor */
%global LMDBACE LMDBLACE;
%let LMDBACE         = C09A;
%let LMDBLACE        = "ACE-inhibitors";

/* Aldo */
%global LMDBAldo LMDBLAldo;
%let LMDBAldo         = C03DA;
%let LMDBLAldo        = "Aldosterone antagonists";

/* ALFA */
%global LMDBalfa LMDBLalfa;
%let LMDBalfa         = C02A C02B C02C;
%let LMDBLalfa        = "Alfa adrenic block";

/* Amio */
%global LMDBAmio LMDBLAmio;
%let LMDBAmio         = C01BD01;
%let LMDBLAmio        = "Amiodarone";

/* Antiand - Antiandrogener */
%global LMDBantiand LMDBLantiand;
%let LMDBantiand      = G03HB;
%let LMDBLantiand     = "Antiandrogener";

/*Antidem - Anti-dementia medication */
%ICD_LMDBdefines(LMDB, antidem, "Antiandrogener", N06D);

/* Antithy */
%global LMDBAntithy LMDBLAntithy;
%let LMDBAntiThy      = H03B;
%let LMDBLAntiThy     = "Antithyroids";

/* Apixa */
%global LMDBApixa LMDBLApixa;
%let LMDBApixa        = B01AF02;
%let LMDBLApixa       = "Apixaban";

/* arb - Angiotension II receptor blockers/antagonists */
%global LMDBARB LMDBLARB;
%let LMDBARB         = C09C;
%let LMDBLARB        = "Angiotension II receptor blockers/antagonists";

/* Aroinhib */
%global LMDBAroinhib LMDBLAroinhib;
%let LMDBAroInhib     = L02BG;
%let LMDBLAroInhib    = "Aromatase inhibitors";

/* Aspirin */
%global LMDBAspirin LMDBLAspirin;
%let LMDBaspirin      = B01AC06;
%let LMDBLaspirin     = "Aspirin";


/* B */
/* Benzo */
%global LMDBBenzo LMDBLBenzo;
%let LMDBBenzo        = N03AE N05BA N05CD N05CF;
%let LMDBLBenzo       = "Benzodiazaepines";

/* Beta */
%global LMDBBeta LMDBLBeta;
%let LMDBbeta         = C07;
%let LMDBLbeta        = "Beta blocker";

/* Bloodlow - Blood glucose lowering drugs, excluding insulins */
%global LMDBbloodlow LMDBLbloodlow;
%let LMDBbloodlow      = A10B;
%let LMDBLbloodlow     = "Blood glucose lowering drugs, excluding insulins";

/* C */
/* Calcium */
%global LMDBCalcium LMDBLCalcium;
%let LMDBcalcium      = C07F C08 C09BB C09DB;
%let LMDBLcalcium     = "Calcium Channel blocker";

/* Carba */
%global LMDBCarba LMDBLCarba;
%let LMDBcarba        = N03AF01;
%let LMDBLcarba       = "Carbamizipine";

/* Clarit */
%global LMDBClarit LMDBLClarit;
%let LMDBClarit       = J01FA09;
%let LMDBLClarit      = "Clarithromycin";

/* clomi - Clomifen */
%global LMDBclomi LMDBLclomi;
%let LMDBclomi        = G03GB02;
%let LMDBLclomi       = "Clomifen";

/* Clopi */
%global LMDBClopi LMDBLClopi;
%let LMDBClopi        = B01AC04;
%let LMDBLClopi       = "Clopidogrel";

/* Coumarin */
%global LMDBCoumarin LMDBLCoumarin;
%let LMDBCoumarin     = B01AA;
%let LMDBLCoumarin    = "Coumarin derivatives (warfarin & phenprocoumon)";

/* Cyclo */
%global LMDBCyclo LMDBLCyclo;
%let LMDBcyclo        = L04AD01;
%let LMDBLcyclo       = "Cyclosporine";


/* D */
/* Dbgtran */
%global LMDBDbgtran LMDBLDbgtran;
%let LMDBdbgtran      = B01AE07;
%let LMDBLdbgtran     = "Dabigatran";

/* DiabLMDB - Insuliner og Metformin */
%global LMDBDiabLMDB LMDBLDiabLMDB;
%let LMDBdiabatc      = A10;
%let LMDBLdiabatc     = "Diabetes Mellitus";

/* Digoxin */
%global LMDBDigoxin LMDBLDigoxin;
%let LMDBDigoxin      = C01AA05;
%let LMDBLDigoxin     = "Digoxin";

/* Donep - Donepzil */
%IndicatorDef(LMDB, donep, "Donepezil", N06DA02);

/* Drone */
%global LMDBDrone LMDBLDrone;
%let LMDBDrone        = C01BD07;
%let LMDBLDrone       = "Dronedarone";


/* E */
/* edoxa */
%global LMDBedoxa LMDBLedoxa;
%let LMDBedoxa        = B01AF03;
%let LMDBLedoxa       = "Edoxaban";


/* F */
/* Fleca - Flecainid */
%IndicatorDef(LMDB, fleca, "Flecainid", C01BC04);

/* Fluco - Fluconazol */
%IndicatorDef(LMDB, fluco, "Fluconazol", J02AC01);

/* Fonda */
%global LMDBFonda LMDBLFonda;
%let LMDBFonda        = B01AX05;
%let LMDBLFonda       = "Fondaparinux";


/* G */
/* Galant - Galantamin */
%IndicatorDef(LMDB, galant, "Galantamin", N06DA04);

/* GP */
%global LMDBGP LMDBLGP;
%let LMDBGP           = B01AC16;
%let LMDBLGP          = "GPIIb/IIIa antagonists (eptifibatide)";


/* H  */
/* H2 */
%global LMDBH2 LMDBLH2;
%let LMDBH2           = A02BA;
%let LMDBLH2          = "H2-receptor antagonistis";

/* heparins */
%global LMDBheparins LMDBLheparins;
%let LMDBHeparins     = B01AB;
%let LMDBLHeparins    = "Low molecular weight heparins";

/* HFatc - Congestive heart failure - HFatc */
%global LMDBHFatc LMDBLHFatc;
%let LMDBHFLMDB        = C03C;
%let LMDBLHFLMDB       = "Congestive heart failure";

/* hypLMDB removed */

/* Hivprot - HIV_proteasehæmmere */
%IndicatorDef(LMDB, hivprot, "HIV-protease inhibitors", J05AE10 J05AE08 J05AR14 J05AR15);

/* HormCnt - Hormonal contraceptives   */
%global LMDBHormCnt LMDBLHormCnt;
%let LMDBHormCnt        = G03A;
%let LMDBLHormCnt       = "Hormonal contraceptives";

/* HRT - Hormone replacement therapy */
%global LMDBHRT LMDBLHRT;
%let LMDBHRT        = G03C G03F;
%let LMDBLHRT       = "Hormone replacement therapy";


/* I */
/* Insulin - Insulins and analogues*/
%global LMDBinsulin LMDBLinsulin;
%let LMDBinsulin      = A10A;
%let LMDBLinsulin     = "Insulin and analogues";

/* Itracon */
%global LMDBItracon LMDBLItracon;
%let LMDBItracon      = J02AC02;
%let LMDBLItracon     = "Itraconazole";

/* Ivabrad */
%global LMDBIvabrad LMDBLIvabrad;
%let LMDBIvabrad      = C01EB17;
%let LMDBLIvabrad     = "Ivabradin";


/* K */
/* keto */
%global LMDBketo LMDBLketo;
%let LMDBKeto         = J02AB02;
%let LMDBLKeto        = "Systemic ketoconazole";

/* L */
/* Loop */
%global LMDBLoop LMDBLLoop;
%let LMDBLoop         = C03C C03EB;
%let LMDBLLoop        = "Loop diuretics";

/* M */
/* Mecil - Mecillinam */
%IndicatorDef(LMDB, mecil, "Mecillinam", J01CA08);

/* Mema - Memantin */
%IndicatorDef(LMDB, mema, "Memantin", N06DX01);

/* metform - Metformin */
%global LMDBmetform LMDBLmetform;
%let LMDBmetform      = A10BA02;
%let LMDBLmetform     = "Metformin";

/* N */

/* Nitro - Nitrofurantoin */
%IndicatorDef(LMDB, nitro, "Nitrofurantoin", J01XE01);

/* Nonloop */
%global LMDBNonloop LMDBLNonloop;
%let LMDBNonLoop      = C02DA C02L C03A C03B C03D C03EA C03X C07C C07D C08G C09BA C09DA C09XA52;
%let LMDBLNonLoop     = "Non-loop diuretics";

/* NSAID */
%global LMDBNSAID LMDBLNSAID;
%let LMDBNSAID        = M01AA M01AB M01AC M01AE M01AG M01AH M01AX01 ;
%let LMDBLNSAID       = "NSAIDs";


/* O */
/* OtherDiab */
%global LMDBOtherDiab LMDBLOtherDiab;
%let LMDBOtherDiab    = A10X;
%let LMDBLOtherDiab   = "Other drugs used in diabetes";


/* P */
/* Persantin */
%global LMDBPersantin LMDBLPersantin;
%let LMDBPersantin    = B01AC07;
%let LMDBLPersantin   = "Persantin";

/* Phen */
%global LMDBPhen LMDBLPhen;
%let LMDBPhen         = B01AA04;
%let LMDBLPhen        = "Phenprocoumon";

/* prasu - Prasugrel */
%IndicatorDef(LMDB, prasu, "Prasugrel", B01AC22);

/* Proton */
%global LMDBProton LMDBLProton;
%let LMDBProton       = A02BC;
%let LMDBLProton      = "Proton-pump inhibitors";


/* Q */
/* Quin */
%global LMDBQuin LMDBLQuin;
%let LMDBQuin         = C01BA01;
%let LMDBLQuin        = "Quinidine";


/* R */
/* Renin */
%global LMDBRenin LMDBLRenin;
%let LMDBRenin        = C09;
%let LMDBLRenin       = "Renin-angiotensin inhibitor (ARB or ACE inhibitor)";

/* riva -  Rivarox */
%global LMDBRiva LMDBLRiva;
%let LMDBRiva         = B01AF01;
%let LMDBLRiva        = "Rivaroxaban";

/* rivast - Rivastigmin */
%IndicatorDef(LMDB, rivast, "Rivastigmin", N06DA03);

/* S */
/* Sota - Sotalol */
%IndicatorDef(LMDB, sota, "Sotalol", C07AA07);

/* SSRI */
%global LMDBSSRI LMDBLSSRI;
%let LMDBSSRI         = N06AB;
%let LMDBLSSRI        = "Selective serotonin reuptake inhibitors";

/* Statins */
%global LMDBStatins LMDBLStatins;
%let LMDBStatins      = C10;
%let LMDBLStatins     = "Statins";

/* sulfa - Sulfamethiozole */
%IndicatorDef(LMDB, sulfa, "Sulfamethiozole", J01EB02);


/* Sulfin */
%global LMDBSulfin LMDBLSulfin;
%let LMDBSulfin       = M04;
%let LMDBLSulfin      = "Sulfinpyrazone";

/* Syscort */
%global LMDBSyscort LMDBLSyscort;
%let LMDBSysCort      = H02;
%let LMDBLSysCort     = "Systemic corticosteroids";


/* T */
/* Tacrol */
%global LMDBTacrol LMDBLTacrol;
%let LMDBTacrol       = L04AD02;
%let LMDBLTacrol      = "Tacrolimus";

/* TAThaLe - Tamoxifen Thalidomide Lenalidomide */
%global LMDBTAThaLe LMDBLTAThaLe;
%let LMDBTAThaLe        = L02BA01 L04AX04 L04AX02;
%let LMDBLTAThaLe       = "Tamoxifen Thalidomide Lenalidomide";

/* Thiazol */
%global LMDBThiazol LMDBLThiazol;
%let LMDBThiazol      = A10BG;
%let LMDBLThiazol     = "Thiazolidinediones";

/* Thien */
%global LMDBThien LMDBLThien;
%let LMDBThien        = B01AC04 B01AC24 B01AC22; /*15/5/17 - tilføjet B01AC24 og B01AC22 (af Line)*/
%let LMDBLThien       = "Thienopyridines (clopidogel, tricagrelor, prasugrel";

/* Tica - Ticagrelor */
%IndicatorDef(LMDB, tica, "Ticagrelor", B01AC24);

/* TMP - Trimethoprim */
%IndicatorDef(LMDB, tmp, "Trimetroprim", J01EA01);


/* V */
/* Vaso */
%global LMDBVaso LMDBLVaso;
%let LMDBVaso         = C02DB C02DD C02DG C04 C05;
%let LMDBLVaso        = "Vasodilator";

/* Vera */
%global LMDBVera LMDBLVera;
%let LMDBVera         = C08DA01;
%let LMDBLVera        = "Verapamil";


/* W */
/* Warfarin */
%global LMDBWarfarin LMDBLWarfarin;
%let LMDBWarfarin     = B01AA03;
%let LMDBLWarfarin    = "Warfarin";
