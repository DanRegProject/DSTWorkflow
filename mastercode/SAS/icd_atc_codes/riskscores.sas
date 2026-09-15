/* This file is used to specify multicomorbidity scores, observe entry groups defined by
    DIAG hospital discharge information
    CPR demographic information
    OTH other information - entries within here may need specific coding in multicoscore.sas
    in any group, entry postfix
    W assigns weight of entry
    C criterion, in DIAG being options for getDIAG, in CPR and OTH definition of entry
        macro variable MCSDate can be used in defition
    LINK is used for potential non-identity link between linear predictor and score,
        macro variable score must be used
    */
%let mcolist = CHARLSON SEGAL HFRS hasbled cha2ds2vasc 
               diabetesMedi diabetesDiag 
               hypertensionMedi combhypertensionMedi hypertensionDiag 
               heartfailMedi heartfailDiag;

/* Charlson:
  ICD10 from http://bmcmedresmethodol.biomedcentralcom/articles/10.1186/1471-2288-11-83,
  The predictive value of ICD-10 diagnostic coding used to assess Charlson comorbidity index conditions
  in the population-based Danish National Registry of Patients */
/* Charlson weight 1 */
%IndicatorDef(DIAG, charlson1, "Myocardial infarction", I21 I22 I23, icd8=410, w=1);
%IndicatorDef(DIAG, charlson2, "Congestive heart failure", I50 I110 I130 I132, icd8=42709 42710 42711 42719 42899 78249, w=1);
%IndicatorDef(DIAG, charlson3, "Peripheral vascular disease", I70 I71 I72 I73 I74 I77, icd8=440 441 442 443 444 445, w=1);
%IndicatorDef(DIAG, charlson4, "Cerebrovasvular disease", I60 I61 I62 I63 I64 I65 I66 I67 I68 I69 G45 G46, icd8=430 431 432 433 434 435 436 437 438, w=1);
%IndicatorDef(DIAG, charlson5, "Dementia", F00 F01 F02 F03 F051 G30, icd8=29009 29010 29011 29012 29013 29014 29015 29016 29017 29018 29019 29309, w=1);
%IndicatorDef(DIAG, charlson6, "Chronic Pulmonary disease", J40 J41 J42 J43 J44 J45 J46 J47 J60 J61 J62 J63 J64 J65 J66 J67 J684 J701 J703 J841 J920 J961 J982 J983, icd8=490 491 492 493 515 516 517 51[...]
%IndicatorDef(DIAG, charlson7, "Connective tissue disease", M05 M06 M08 M09 M30 M31 M32 M33 M34 M35 M36 D86, icd8=712 716 734 446 13599, w=1);
%IndicatorDef(DIAG, charlson8, "Ulcer disease", K221 K25 K26 K27 K28, icd8=53091 53098 531 532 533 534, w=1);
%IndicatorDef(DIAG, charlson9, "Mild liver disease", B18 K700 K701 K702 K703 K709 K71 K73 K74 K760, icd8=571 57301 57304, w=1);
%IndicatorDef(DIAG, charlson10, "Diabetes Mellitus", E100 E101 E109 E110 E111 E119, icd8=249 250, w=1);

/* Charlson weight 2 */
%IndicatorDef(DIAG, charlson11, "Hemiplegia", G81 G82, icd8=344, w=2);
%IndicatorDef(DIAG, charlson12, "Moderate/severe renal disease", I12 I13 N00 N01 N02 N03 N04 N05 N07 N11 N14 N17 N18 N19 Q61, icd8=403 404 580 581 582 583 584 59009 59319 7531 792, w=2);
%IndicatorDef(DIAG, charlson13, "Diabetes Mellitus with chronic complications", E102 E103 E104 E105 E106 E107 E108 E112 E113 E114 E115 E116 E117 E118, icd8=24901 24902 24903 24904 24905 24908 25001 25[...]
%IndicatorDef(DIAG, charlson14, "Any tumor", C0 C1 C2 C3 C4 C5 C6 C70 C71 C72 C73 C74 C75, icd8=14 15 16 17 18 190 191 192 193 194, w=2);
%IndicatorDef(DIAG, charlson15, "Leukemia", C91 C92 C93 C94 C95, icd8=204 205 206 207, w=2);
%IndicatorDef(DIAG, charlson16, "Lymphoma", C81 C82 C83 C84 C85 C88 C90 C96, icd8=200 201 202 203 27559, w=2);

/* Charlson weight 3 */
%IndicatorDef(DIAG, charlson17, "Moderate/severe liver disease", B150 B160 B162 B190 K704 K72 K766 I85, icd8=07000 07002 07004 07006 07008 57300 4560, w=3);

/* Charlson weight 6 */
%IndicatorDef(DIAG, charlson18, "Metastatic solid tumor", C76 C77 C78 C79 C80, icd8=195 196 197 198 199, w=6);
%IndicatorDef(DIAG, charlson19, "AIDS", B21 B22 B23 B24, icd8=07983, w=6);
%let DIAGcharlsonN        = 19; /* 2 diseases with weight 6 each */

/* Segal et al, Development of a claims-based frailty indicator anchored to a well-established frailty phenotype. Med care 2017 jul 55(7) 716-722 */
%let LINKsegal        = 1/(1+exp(-&score&MCSDate)); /*IGNORE THE WARNING. Placeholder. Used in multicoscores.sas*/
%IndicatorDef(DIAG, segal1, "Parkinson", G20, icd8=, w=0.5);
%IndicatorDef(DIAG, segal2, "Impaired mobility", R26 Z74 Z75 Z993, icd8=, w=1.24);
%IndicatorDef(DIAG, segal3, "Depression, wide def.", F204 F251 F31 F32 F33 F341 F38 F41 F43 F44 F920 T43 Y490 Y492, icd8=, w=0.54);
%IndicatorDef(DIAG, segal4, &DIAGLhf2, &DIAGhf2, icd8=, w=0.50);
%IndicatorDef(DIAG, segal5, "Arthritis (any type)", M0 M1 M20 M21 M22 M23 M24 M32 M33 M34 M35 M36 M43 M6 M70 M71 M72 M75 M76 M77 M78 M79 R26 R29 Z87, icd8=, w=0.43);
%IndicatorDef(DIAG, segal6, "Cognitive impairment", F0 G30 G31 R41 R46 Z032, icd8=, w=0.33);
%IndicatorDef(DIAG, segal7, "Stroke (wide def)", I6, icd8=, w=0.28);
%IndicatorDef(DIAG, segal8, "Paranoia", F06 f20 F21 F22 F23 F24 F25 F28 F29 F32 F33 F44 F600, icd8=, w=0.24);
%IndicatorDef(DIAG, segal9, "Chronic skin ulcer", L89 L97 L98, icd8=, w=0.23);
%IndicatorDef(DIAG, segal10, "Pneumonia (wide def)", A221 A37 A481 B250 B440 B778 J1 J69, icd8=, w=0.21);
%IndicatorDef(DIAG, segal11, "Skin and soft tissue infection", A20 A21 A22 A31 A36 A46 L0 L10 L88 L98 K12 E83, icd8=, w=0.18);
%IndicatorDef(DIAG, segal12, "Mycoses", B35 B36 B37 B38 B39 B4, icd8=, w=0.14);
%IndicatorDef(DIAG, segal13, "Gout or other crystal-induced arthopathy", M10 M11 N20, icd8=, w=0.08);
%IndicatorDef(DIAG, segal14, "Falls", W0 W1, icd8=, w=0.08);
%IndicatorDef(DIAG, segal15, "Muscoloskeletal problems", E106F E116F G45 M R29 Z783, icd8=, w=0.05);
%IndicatorDef(DIAG, segal16, "Urinary tract infection (wide def)", A368 N10 N11 N12 N15 N16 N288 N30 N34 N35 N390, icd8=, w=0.05);
%let DIAGsegalN         = 16;

%IndicatorDef(CPR, segal1, "Age", empty, w=0.09, crit=(&MCSDate-birthdate)/365);
%IndicatorDef(CPR, segal2, "Male sex", empty, w=-0.19, crit=(sex=0));
%IndicatorDef(CPR, segal3, "White Race", empty, w=-0.49, crit=1); /* all defined as white race*/
%let CPRsegalN         = 3;

%IndicatorDef(OTH, segal1, "Intercept", empty, w=-9, crit=1);
%IndicatorDef(OTH, segal2, "Admission past 6 mo", empty, w=0.09, crit=(&MCSDate-indate)/30.4<6);
%IndicatorDef(OTH, segal3, "Charlson >0", empty, w=0.31, crit=(Charlson&MCSDate >0));
%let OTHsegalN         = 3;


/*Hospital Frailty Risk Score(HFRS) PMID: 29706364 Gilbert et al (2018) Lancet */
%IndicatorDef(OTH, HFRS1, "Intercept", empty, w=0, crit=1);
%let OTHHFRSN        = 1;

%IndicatorDef(DIAG, HFRS1, "Bacterial intest infect", A04, icd8=, w=1.1);
%IndicatorDef(DIAG, HFRS2, "Diarrhoea infectious", A09, icd8=, w=1.1);
%IndicatorDef(DIAG, HFRS3, "Other Septicaemia", A41, icd8=, w=1.6);
%IndicatorDef(DIAG, HFRS4, "Streptococcus", B95, icd8=, w=1.7);
%IndicatorDef(DIAG, HFRS5, "Other bacterial agents as cause", B96, icd8=, w=2.9, crit=diagtype="B");
%IndicatorDef(DIAG, HFRS6, "Other anaemias", D64, icd8=, w=0.4);
%IndicatorDef(DIAG, HFRS7, "Thyrotoxicosis", E05, icd8=, w=0.9);
%IndicatorDef(DIAG, HFRS8, "Pancreatic internal secretion", E16, icd8=, w=1.4);
%IndicatorDef(DIAG, HFRS9, "Vitamin B deficiency", E53, icd8=, w=1.9);
%IndicatorDef(DIAG, HFRS10, "Vitamin D deficiency", E55, icd8=, w=1);
%IndicatorDef(DIAG, HFRS11, "Disorders of mineral metabolism", E83, icd8=, w=0.4);
%IndicatorDef(DIAG, HFRS12, "Volume depletion", E86, icd8=, w=2.3);
%IndicatorDef(DIAG, HFRS13, "Fluid electrolyte balance disorders", E87, icd8=, w=2.3);
%IndicatorDef(DIAG, HFRS14, "Alzheimer Dementia", F00, icd8=, w=7.1);
%IndicatorDef(DIAG, HFRS15, "Vascular dementia", F01, icd8=, w=2);
%IndicatorDef(DIAG, HFRS16, "Unspecified dementia", F03, icd8=, w=2.1);
%IndicatorDef(DIAG, HFRS17, "Delerium", F05, icd8=, w=3.2);
%IndicatorDef(DIAG, HFRS18, "Alcohol related mental disorders", F10, icd8=, w=0.7);
%IndicatorDef(DIAG, HFRS19, "Depressive episode", F32, icd8=, w=0.5);
%IndicatorDef(DIAG, HFRS20, "Parkinson", G20, icd8=, w=1.8);
%IndicatorDef(DIAG, HFRS21, "Alzheimers", G30, icd8=, w=4);
%IndicatorDef(DIAG, HFRS22, "Other degenerative disease", G31, icd8=, w=1.2);
%IndicatorDef(DIAG, HFRS23, "Epilepsy", G40, icd8=, w=1.4);
%IndicatorDef(DIAG, HFRS24, "TIA", G45, icd8=, w=1.2);
%IndicatorDef(DIAG, HFRS25, "Hemiplegia", G81, icd8=, w=4.4);
%IndicatorDef(DIAG, HFRS26, "Blidness", H54, icd8=, w=1.9);
%IndicatorDef(DIAG, HFRS27, "Hearing loss", H91, icd8=, w=0.9);
%IndicatorDef(DIAG, HFRS28, "Istroke", I63, icd8=, w=0.8);
%IndicatorDef(DIAG, HFRS29, "Cerebrovascular disease", I67, icd8=, w=2.6);
%IndicatorDef(DIAG, HFRS30, "Sequale cerebrovas dis", I69, icd8=, w=3.7);
%IndicatorDef(DIAG, HFRS31, "Hypotension", I95, icd8=, w=1.6);
%IndicatorDef(DIAG, HFRS32, "Pneumonia", J18, icd8=, w=1.1);
%IndicatorDef(DIAG, HFRS33, "Low resp infection", J22, icd8=, w=0.7);
%IndicatorDef(DIAG, HFRS34, "Pneumonitis", J69, icd8=, w=1);
%IndicatorDef(DIAG, HFRS35, "Resp failure", J96, icd8=, w=1.5);
%IndicatorDef(DIAG, HFRS36, "Duodenal ulcer", K26, icd8=, w=1.6);
%IndicatorDef(DIAG, HFRS37, "Gastroenteritis", K52, icd8=, w=0.3);
%IndicatorDef(DIAG, HFRS38, "Other intestinal dis", K59, icd8=, w=1.8);
%IndicatorDef(DIAG, HFRS39, "Other digestive diseases", K92, icd8=, w=0.8);
%IndicatorDef(DIAG, HFRS40, "Cellulitis", L03, icd8=, w=2);
%IndicatorDef(DIAG, HFRS41, "Other skin infections", L08, icd8=, w=0.4);
%IndicatorDef(DIAG, HFRS42, "Decubitus ulcer", L89, icd8=, w=1.7);
%IndicatorDef(DIAG, HFRS43, "Leg ulcer", L97, icd8=, w=1.6);
%IndicatorDef(DIAG, HFRS44, "Polyarthrosis", M15, icd8=, w=0.4);
%IndicatorDef(DIAG, HFRS45, "Other arthrosis", M19, icd8=, w=1.5);
%IndicatorDef(DIAG, HFRS46, "Other joint disorders", M25, icd8=, w=2.3);
%IndicatorDef(DIAG, HFRS47, "Scolosis", M41, icd8=, w=0.9);
%IndicatorDef(DIAG, HFRS48, "Spinal stenosis", M48, icd8=, w=0.5, crit=diagtype="B");
%IndicatorDef(DIAG, HFRS49, "Soft tissue disorder", M79, icd8=, w=1.1);
%IndicatorDef(DIAG, HFRS50, "Osteoporosis with facture", M80, icd8=, w=0.8);
%IndicatorDef(DIAG, HFRS51, "Osteoporosis without facture", M81, icd8=, w=1.4);
%IndicatorDef(DIAG, HFRS52, "Acute renal failure", N17, icd8=, w=1.8);
%IndicatorDef(DIAG, HFRS53, "Chronic renal failure", N18, icd8=, w=1.4);
%IndicatorDef(DIAG, HFRS54, "Unspecific renal failure", N19, icd8=, w=1.6);
%IndicatorDef(DIAG, HFRS55, "Kidney ureter stones", N20, icd8=, w=0.7);
%IndicatorDef(DIAG, HFRS56, "Other kidney dis", N28, icd8=, w=1.3);
%IndicatorDef(DIAG, HFRS57, "Urinary disorders UTI UIC", N39, icd8=, w=3.2);
%IndicatorDef(DIAG, HFRS58, "Heart beat abnorm", R00, icd8=, w=0.7);
%IndicatorDef(DIAG, HFRS59, "Gangrene", R02, icd8=, w=1);
%IndicatorDef(DIAG, HFRS60, "Nausea vomiting", R11, icd8=, w=0.3);
%IndicatorDef(DIAG, HFRS61, "Dysphagia", R13, icd8=, w=0.8);
%IndicatorDef(DIAG, HFRS62, "Gait and mobility abnorm", R26, icd8=, w=2.6);
%IndicatorDef(DIAG, HFRS63, "Tendency to fall", R29, icd8=, w=3.6);
%IndicatorDef(DIAG, HFRS64, "Haematuria", R31, icd8=, w=3);
%IndicatorDef(DIAG, HFRS65, "Urinary incontinence", R32, icd8=, w=1.2);
%IndicatorDef(DIAG, HFRS66, "Urinary retention", R33, icd8=, w=1.3);
%IndicatorDef(DIAG, HFRS67, "Coma stupor", R40, icd8=, w=2.5);
%IndicatorDef(DIAG, HFRS68, "Cognitive function", R41, icd8=, w=2.7);
%IndicatorDef(DIAG, HFRS69, "General sensation perception", R44, icd8=, w=1.6);
%IndicatorDef(DIAG, HFRS70, "Emotional state", R45, icd8=, w=1.2);
%IndicatorDef(DIAG, HFRS71, "Speach disturbances", R47, icd8=, w=1);
%IndicatorDef(DIAG, HFRS72, "Fever", R50, icd8=, w=0.1);
%IndicatorDef(DIAG, HFRS73, "Senility", R54, icd8=, w=2.2);
%IndicatorDef(DIAG, HFRS74, "Sencope", R55, icd8=, w=1.8);
%IndicatorDef(DIAG, HFRS75, "Convulsions", R56, icd8=, w=2.6);
%IndicatorDef(DIAG, HFRS76, "Food and fluid intake", R63, icd8=, w=0.9);
%IndicatorDef(DIAG, HFRS77, "Unknown causes of morbidity", R69, icd8=, w=1.3);
%IndicatorDef(DIAG, HFRS78, "Abnormal blood chemistry", R79, icd8=, w=0.6);
%IndicatorDef(DIAG, HFRS79, "Abnormal function", R94, icd8=, w=1.4);
%IndicatorDef(DIAG, HFRS80, "Superficial injury of head", S00, icd8=, w=3.2);
%IndicatorDef(DIAG, HFRS81, "Open head wound", S01, icd8=, w=1.1);
%IndicatorDef(DIAG, HFRS82, "Intracranial injury", S06, icd8=, w=2.4);
%IndicatorDef(DIAG, HFRS83, "Unspecified head injury", S09, icd8=, w=1.2);
%IndicatorDef(DIAG, HFRS84, "Rib fracture", S22, icd8=, w=1.8);
%IndicatorDef(DIAG, HFRS85, "Spine and pelvis fracture", S32, icd8=, w=1.4);
%IndicatorDef(DIAG, HFRS86, "Shoulder fracture", S42, icd8=, w=2.3);
%IndicatorDef(DIAG, HFRS87, "Open forarm wound", S51, icd8=, w=0.5);
%IndicatorDef(DIAG, HFRS88, "Femur fracture", S72, icd8=, w=1.4);
%IndicatorDef(DIAG, HFRS89, "Lower leg superfecial injury", S80, icd8=, w=2);
%IndicatorDef(DIAG, HFRS90, "Complica urogenital implants", T83, icd8=, w=2.4);
%IndicatorDef(DIAG, HFRS91, "Nosocomial infect", T89, icd8=, w=1.2);
%IndicatorDef(DIAG, HFRS92, "Carrier infect dis", Z22, icd8=, w=1.7);
%IndicatorDef(DIAG, HFRS93, "Rehabilitation", Z50, icd8=, w=2.1);
%IndicatorDef(DIAG, HFRS94, "Social problems", Z60, icd8=, w=1.8);
%IndicatorDef(DIAG, HFRS95, "Life management difficulty", Z73, icd8=, w=0.6);
%IndicatorDef(DIAG, HFRS96, "Care provider dependency", Z74, icd8=, w=1.1);
%IndicatorDef(DIAG, HFRS97, "Medical facilities problems", Z75, icd8=, w=2);
%IndicatorDef(DIAG, HFRS98, "History of other disease", Z87, icd8=, w=1.5);
%IndicatorDef(DIAG, HFRS99, "History of risk factor", Z91, icd8=, w=0.5);
%IndicatorDef(DIAG, HFRS100, "Artificial opening status", Z93, icd8=, w=1);
%IndicatorDef(DIAG, HFRS101, "Enabling devices dependency", Z99, icd8=, w=0.8);

%let DIAGHFRSN         = 101;


/* HAS-BLED bleeding risk score */
%IndicatorDef(DIAG, hasbled1, "Renal disease", &LPRCrenal, icd8=&LPRCrenal_ICD8, w=1);
%IndicatorDef(DIAG, hasbled2, "Liver disease", &LPRLiver, icd8=&LPRLiver_ICD8, w=1);
%IndicatorDef(DIAG, hasbled3, "Stroke (IStroke or TIA)", &LPRIStroke &LPRTIA,
              icd8= &LPRIStroke_ICD8 &LPRTIA_ICD8, w=1);
%IndicatorDef(DIAG, hasbled4, "Bleeding", &LPRGIbleed &LPRICbleed &LPRIMbleed &LPRgenbleed &LPRocbleed,
              icd8=&LPRGIbleed_ICD8 &LPRICbleed_ICD8 &LPRIMbleed_ICD8 &LPRgenbleed_ICD8 &LPRocbleed_ICD8, w=1);
%IndicatorDef(DIAG, hasbled5, "Alcohol", &LPRAlco, icd8=&LPRAlco_ICD8, w=1, wdays=180);

%IndicatorDef(CPR, hasbled1, "Age>=65", empty, w=1,
              crit=((%MCSDate-birthdate)/365)>=65); /*IGNORE THE WARNING. Placeholder used in multicoscores.sas*/

%IndicatorDef(OTH, hasbled1, "Hypertension (diagnosis or medicated (2+ drugs))", empty, w=1,
              crit=((HypertensionDiag&MCSDdate>0) + (HypertensionMedi&MCSDdate>0))>0);
/*IGNORE THE WARNING. Placeholder used in multicoscores.sas*/

%IndicatorDef(LMDB, hasbled1, "Drugs", &ATCAspirin &ATCclopi &ATCnsaid, w=1, wdays=180);


/* CHA2DS2-VASc stroke risk score */

%IndicatorDef(DIAG, cha2ds2vasc1, "Stroke (IStroke or SE or TIA)", &LPRIStroke &LPRTIA &LPRSE,
              icd8= &LPRIStroke_ICD8 &LPRTIA_ICD8 &LPRSE_ICD8, w=2);
%IndicatorDef(DIAG, cha2ds2vasc2, "Vascular disease (MI or PAD3)", &LPRMI &LPRPAD3,
              icd8= &LPRMI_ICD8 &LPRPAD3_ICD8, w=1);
%IndicatorDef(CPR, cha2ds2vasc1, "Age>=65", empty, w=1,
              crit=((%MCSDate-birthdate)/365)>=65); /*IGNORE THE WARNING. Placeholder used in multicoscores.sas*/
%IndicatorDef(CPR, cha2ds2vasc2, "Age>=75", empty, w=1,
              crit=((%MCSDate-birthdate)/365)>=75); /*IGNORE THE WARNING. Placeholder used in multicoscores.sas*/
%IndicatorDef(CPR, cha2ds2vasc3, "Female sex", empty, w=1, crit=(sex=1));

%IndicatorDef(OTH, cha2ds2vasc1, "Heart failure (diagnosis or medicated (2+ drugs))", empty, w=1,
              crit=((HeartFailDiag&MCSDdate>0) + (HeartFailMedi&MCSDdate>0))>0);
/*IGNORE THE WARNING. Placeholder used in multicoscores.sas*/
%IndicatorDef(OTH, cha2ds2vasc2, "Hypertension (diagnosis or medicated (2pt))", empty, w=1,
              crit=((HypertensionDiag&MCSDdate>0) + (HypertensionMedi&MCSDdate>0))>0);
/*IGNORE THE WARNING. Placeholder used in multicoscores.sas*/
%IndicatorDef(OTH, cha2ds2vasc3, "Diabetes (diagnosis or medicated (2+ drugs))", empty, w=1,
              crit=((DiabetesDiag&MCSDdate>0) + (DiabetesMedi&MCSDdate>0))>0);
/*IGNORE THE WARNING. Placeholder used in multicoscores.sas*/


/* Heart failure, used in CHA2DS2-VASc */
%IndicatorDef(LMDB, HeartFailMedi1, &ATCcloop, &ATCloop, w=1);
%IndicatorDef(LMDB, HeartFailMedi2, &ATCLRenin, &ATCRenin, w=1);
%IndicatorDef(DIAG, HeartFailDiag1, &LPRHFStr, &LPRHFStr, icd8=&LPRHFStr_ICD8, w=1);


/* Diabetes, used in CHA2DS2-VASc */
%IndicatorDef(LMDB, DiabetesMedi1, &ATCDiabetesATC, &ATCDiabetesATC, w=1);
%IndicatorDef(DIAG, DiabetesDiag1, &LPRDiabLPR, &LPRDiabLPR, icd8=&LPRDiabLPR_ICD8, w=1);


/* Hypertension, used in CHA2DS2VASC and HAS-BLED */
%IndicatorDef(LMDB, HypertensionMedi1, &ATCAlfa, &ATCAlfa, w=1);
%IndicatorDef(LMDB, HypertensionMedi2, &ATCLNonloop, &ATCNonloop, w=1);
%IndicatorDef(LMDB, HypertensionMedi3, &ATCLVaso, &ATCVaso, w=1);
%IndicatorDef(LMDB, HypertensionMedi4, &ATCLBeta, &ATCBeta, w=1);
%IndicatorDef(LMDB, HypertensionMedi5, &ATCLCalcium, &ATCCalcium, w=1);
%IndicatorDef(LMDB, HypertensionMedi6, &ATCLRenin, &ATCRenin, w=1);
%IndicatorDef(DIAG, HypertensionDiag1, &LPRHylLPR, &LPRHylLPR, icd8=&LPRHylLPR_ICD8, w=1);


/* Hypertension combination drugs, used in CHA2DS2VASC and HAS-BLED */
%IndicatorDef(LMDB, CombHypertensionMedi1, "Combination drugs Hypertension",
              C09BB04 C09DA C09DB C09CX01 C09DX04 C07B, w=1);
