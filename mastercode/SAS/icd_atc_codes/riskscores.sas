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
%let DIAGcharlson1        = I21 I22 I23;
%let DIAGcharlson1_ICD8   = 410;
%let DIAGLcharlson1       = "Myocardial infarction";
%let DIAGcharlson1W       = 1;
%let DIAGcharlson2        = I50 I110 I130 I132;
%let DIAGcharlson2_ICD8   = 42709 42710 42711 42719 42899 78249;
%let DIAGLcharlson2       = "Congestive heart failure";
%let DIAGcharlson2W       = 1;
%let DIAGcharlson3        = I70 I71 I72 I73 I74 I77;
%let DIAGcharlson3_ICD8   = 440 441 442 443 444 445;
%let DIAGLcharlson3       = "Peripheral vascular disease";
%let DIAGcharlson3W       = 1;
%let DIAGcharlson4        = I60 I61 I62 I63 I64 I65 I66 I67 I68 I69 G45 G46;
%let DIAGcharlson4_ICD8   = 430 431 432 433 434 435 436 437 438;
%let DIAGLcharlson4       = "Cerebrovasvular disease";
%let DIAGcharlson4W       = 1;
%let DIAGcharlson5        = F00 F01 F02 F03 F051 G30;
%let DIAGcharlson5_ICD8   = 29009 29010 29011 29012 29013 29014 29015 29016 29017 29018 29019 29309;
%let DIAGLcharlson5       = "Dementia";
%let DIAGcharlson5W       = 1;
%let DIAGcharlson6        = J40 J41 J42 J43 J44 J45 J46 J47 J60 J61 J62 J63 J64 J65 J66 J67 J684 J701 J703 J841 J920 J961 J982 J983;
%let DIAGcharlson6_ICD8   = 490 491 492 493 515 516 517 518;
%let DIAGLcharlson6       = "Chronic Pulmonary disease";
%let DIAGcharlson6W       = 1;
%let DIAGcharlson7        = M05 M06 M08 M09 M30 M31 M32 M33 M34 M35 M36 D86;
%let DIAGcharlson7_ICD8   = 712 716 734 446 13599;
%let DIAGLcharlson7       = "Connective tissue disease";
%let DIAGcharlson7W       = 1;
%let DIAGcharlson8        = K221 K25 K26 K27 K28;
%let DIAGcharlson8_ICD8   = 53091 53098 531 532 533 534;
%let DIAGLcharlson8       = "Ulcer disease";
%let DIAGcharlson8W       = 1;
%let DIAGcharlson9        = B18 K700 K701 K702 K703 K709 K71 K73 K74 K760;
%let DIAGcharlson9_ICD8   = 571 57301 57304;
%let DIAGLcharlson9       = "Mild liver disease";
%let DIAGcharlson9W       = 1;
%let DIAGcharlson10       = E100 E101 E109 E110 E111 E119;
%let DIAGcharlson10_ICD8  = 249 250;
%let DIAGLcharlson10      = "Diabetes Mellitus";
%let DIAGcharlson10W       = 1;
/* Charlson weight 2 */
%let DIAGcharlson11        = G81 G82;
%let DIAGcharlson11_ICD8   = 344;
%let DIAGLcharlson11       = "Hemiplegia";
%let DIAGcharlson11W       = 2;
%let DIAGcharlson12        = I12 I13 N00 N01 N02 N03 N04 N05 N07 N11 N14 N17 N18 N19 Q61;
%let DIAGcharlson12_ICD8   = 403 404 580 581 582 583 584 59009 59319 7531 792;
%let DIAGLcharlson12       = "Moderate/severe renal disease";
%let DIAGcharlson12W       = 2;
%let DIAGcharlson13        = E102 E103 E104 E105 E106 E107 E108 E112 E113 E114 E115 E116 E117 E118;
%let DIAGcharlson13_ICD8   = 24901 24902 24903 24904 24905 24908 25001 25002 25003 25004 25005 25008;
%let DIAGLcharlson13       = "Diabetes Mellitus with chronic complications";
%let DIAGcharlson13W       = 2;
%let DIAGcharlson14        = C0 C1 C2 C3 C4 C5 C6 C70 C71 C72 C73 C74 C75;
%let DIAGcharlson14_ICD8   = 14 15 16 17 18 190 191 192 193 194;
%let DIAGLcharlson14       = "Any tumor";
%let DIAGcharlson14W       = 2;
%let DIAGcharlson15        = C91 C92 C93 C94 C95;
%let DIAGcharlson15_ICD8   = 204 205 206 207;
%let DIAGLcharlson15       = "Leukemia";
%let DIAGcharlson15W       = 2;
%let DIAGcharlson16        = C81 C82 C83 C84 C85 C88 C90 C96;
%let DIAGcharlson16_ICD8   = 200 201 202 203 27559;
%let DIAGLcharlson16       = "Lymphoma";
%let DIAGcharlson16W       = 2;
/* Charlson weight 3 */
%let DIAGcharlson17        = B150 B160 B162 B190 K704 K72 K766 I85;
%let DIAGcharlson17_ICD8   = 07000 07002 07004 07006 07008 57300 4560;
%let DIAGLcharlson17       = "Moderate/severe liver disease";
%let DIAGcharlson17W       = 3;
/* Charlson weight 6 */
%let DIAGcharlson18        = C76 C77 C78 C79 C80;
%let DIAGcharlson18_ICD8   = 195 196 197 198 199;
%let DIAGLcharlson18       = "Metastatic solid tumor";
%let DIAGcharlson18W       = 6;
%let DIAGcharlson19        = B21 B22 B23 B24;
%let DIAGcharlson19_ICD8   = 07983;
%let DIAGLcharlson19      = "AIDS";
%let DIAGcharlson19W       = 6;
%let DIAGcharlsonN        = 19; /* 2 diseases with weight 6 each */

/* Segal et al, Development of a claims-based frailty indicator anchored to a well-established frailty phenotype. Med care 2017 jul 55(7) 716-722 */
%let LINKsegal        = 1/(1+exp(-&score&MCSDate)); /*IGNORE THE WARNING. Placeholder. Used in multicoscores.sas*/
%let DIAGsegal1        = G20;
%let DIAGsegal1_ICD8   = ;
%let DIAGLsegal1       = "Parkinson";
%let DIAGsegal1W       = 0.5;
%let DIAGsegal2        = R26 Z74 Z75 Z993;
%let DIAGsegal2_ICD8   = ;
%let DIAGLsegal2       = "Impaired mobility";
%let DIAGsegal2W        = 1.24;
%let DIAGsegal3        = F204 F251 F31 F32 F33 F341 F38 F41 F43 F44 F920 T43 Y490 Y492;
%let DIAGsegal3_ICD8   = ;
%let DIAGLsegal3       = "Depression, wide def.";
%let DIAGsegal3W        = 0.54;
%let DIAGsegal4        = &DIAGhf2;
%let DIAGsegal4_ICD8   = ;
%let DIAGLsegal4       = &DIAGLhf2;
%let DIAGsegal4W       = 0.50;
%let DIAGsegal5        = M0 M1 M20 M21 M22 M23 M24 M32 M33 M34 M35 M36 M43 M6 M70 M71 M72 M75 M76 M77 M78 M79 R26 R29 Z87;
%let DIAGsegal5_ICD8   = ;
%let DIAGLsegal5       = "Arthritis (any type)";
%let DIAGsegal5W       = 0.43;
%let DIAGsegal6        = F0 G30 G31 R41 R46 Z032;
%let DIAGsegal6_ICD8   = ;
%let DIAGLsegal6       = "Cognitive impairment";
%let DIAGsegal6W       = 0.33;
%let DIAGsegal7        = I6;
%let DIAGsegal7_ICD8   = ;
%let DIAGLsegal7       = "Stroke (wide def)";
%let DIAGsegal7W       = 0.28;
%let DIAGsegal8        = F06 f20 F21 F22 F23 F24 F25 F28 F29 F32 F33 F44 F600;
%let DIAGsegal8_ICD8   = ;
%let DIAGLsegal8       = "Paranoia";
%let DIAGsegal8W       = 0.24;
%let DIAGsegal9        = L89 L97 L98;
%let DIAGsegal9_ICD8   = ;
%let DIAGLsegal9       = "Chronic skin ulcer";
%let DIAGsegal9W       = 0.23;
%let DIAGsegal10        = A221 A37 A481 B250 B440 B778 J1 J69;
%let DIAGsegal10_ICD8   = ;
%let DIAGLsegal10       = "Pneumonia (wide def)";
%let DIAGsegal10W       = 0.21;
%let DIAGsegal11        = A20 A21 A22 A31 A36 A46 L0 L10 L88 L98 K12 E83;
%let DIAGsegal11_ICD8   = ;
%let DIAGLsegal11       = "Skin and soft tissue infection";
%let DIAGsegal11W       = 0.18;
%let DIAGsegal12        = B35 B36 B37 B38 B39 B4;
%let DIAGsegal12_ICD8   = ;
%let DIAGLsegal12       = "Mycoses";
%let DIAGsegal12W       = 0.14;
%let DIAGsegal13        = M10 M11 N20;
%let DIAGsegal13_ICD8   = ;
%let DIAGLsegal13       = "Gout or other crystal-induced arthopathy";
%let DIAGsegal13W       = 0.08;
%let DIAGsegal14        = W0 W1;
%let DIAGsegal14_ICD8   = ;
%let DIAGLsegal14       = "Falls";
%let DIAGsegal14W       = 0.08;
%let DIAGsegal15        = E106F E116F G45 M R29 Z783;
%let DIAGsegal15_ICD8   = ;
%let DIAGLsegal15       = "Muscoloskeletal problems";
%let DIAGsegal15W       = 0.05;
%let DIAGsegal16        = A368 N10 N11 N12 N15 N16 N288 N30 N34 N35 N390;
%let DIAGsegal16_ICD8   = ;
%let DIAGLsegal16       = "Urinary tract infection (wide def)";
%let DIAGsegal16W       = 0.05;
%let DIAGsegalN         = 16;

%let CPRLsegal1       = "Age";
%let CPRsegal1C       = (&MCSDate-birthdate)/365; /*IGNORE THE WARNING. Placeholder. Used in multicoscores.sas*/
%let CPRsegal1W       = 0.09;
%let CPRLsegal2       = "Male sex";
%let CPRsegal2C       = sex=0;
%let CPRsegal2W       = -0.19;
%let CPRLsegal3       = "White Race";
%let CPRsegal3W       = -0.49;
%let CPRsegal3C       = 1; /* all defined as white race*/
%let CPRsegalN         = 3;

%let OTHLsegal1       = "Intercept";
%let OTHsegal1W       = -9;
%let OTHsegal1C       = 1;
%let OTHLsegal2       = "Admission past 6 mo";
%let OTHsegal2W       = 0.09;
%let OTHsegal2C       = (&MCSDate-indate)/30.4<6; /* tweak in multicoscore to include date of last hospitalisation */ /*IGNORE THE WARNING. Placeholder. Used in multicoscores.sas*/
%let OTHLsegal3       = "Charlson >0";
%let OTHsegal3W       = 0.31;
%let OTHsegal3C       = (Charlson&MCSDate >0); /*IGNORE THE WARNING. Placeholder. Used in multicoscores.sas*/
%let OTHsegalN         = 3;


/*Hospital Frailty Risk Score(HFRS) PMID: 29706364 Gilbert et al (2018) Lancet */
%let OTHLHFRS1       = "Intercept";
%let OTHHFRS1W       = 0;
%let OTHHFRS1C       = 1;
%let OTHHFRSN        = 1;

%let DIAGHFRS1        = A04;
%let DIAGHFRS1_ICD8   = ;
%let DIAGLHFRS1       = "Bacterial intest infect";
%let DIAGHFRS1W      = 1.1;

%let DIAGHFRS2        = A09;
%let DIAGHFRS2_ICD8   = ;
%let DIAGLHFRS2       = "Diarrhoea infectious";
%let DIAGHFRS2W      = 1.1;

%let DIAGHFRS3        = A41;
%let DIAGHFRS3_ICD8   = ;
%let DIAGLHFRS3       = "Other Septicaemia";
%let DIAGHFRS3W       = 1.6;

%let DIAGHFRS4        = B95;
%let DIAGHFRS4_ICD8   = ;
%let DIAGLHFRS4		  = "Streptococcus";
%let DIAGHFRS4W       = 1.7;

%let DIAGHFRS5        = B96;
%let DIAGHFRS5_ICD8   = ;
%let DIAGLHFRS5       = "Other bacterial agents as cause";
%let DIAGHFRS5W       = 2.9;
%let DIAGHFRS5C       = diagtype="B";

%let DIAGHFRS6        = D64;
%let DIAGHFRS6_ICD8   = ;
%let DIAGLHFRS6       = "Other anaemias";
%let DIAGHFRS6W       = 0.4;

%let DIAGHFRS7        = E05;
%let DIAGHFRS7_ICD8   = ;
%let DIAGLHFRS7       = "Thyrotoxicosis";
%let DIAGHFRS7W       = 0.9;

%let DIAGHFRS8        = E16;
%let DIAGHFRS8_ICD8   = ;
%let DIAGLHFRS8       = "Pancreatic internal secretion";
%let DIAGHFRS8W       = 1.4;

%let DIAGHFRS9        = E53;
%let DIAGHFRS9_ICD8   = ;
%let DIAGLHFRS9       = "Vitamin B deficiency";
%let DIAGHFRS9W       = 1.9;

%let DIAGHFRS10        = E55;
%let DIAGHFRS10_ICD8   = ;
%let DIAGLHFRS10       = "Vitamin D deficiency";
%let DIAGHFRS10W       = 1;

%let DIAGHFRS11        = E83;
%let DIAGHFRS11_ICD8   = ;
%let DIAGLHFRS11       = "Disorders of mineral metabolism";
%let DIAGHFRS11W       = 0.4;

%let DIAGHFRS12        = E86;
%let DIAGHFRS12_ICD8   = ;
%let DIAGLHFRS12       = "Volume depletion";
%let DIAGHFRS12W       = 2.3;

%let DIAGHFRS13        = E87;
%let DIAGHFRS13_ICD8   = ;
%let DIAGLHFRS13       = "Fluid electrolyte balance disorders";
%let DIAGHFRS13W       = 2.3;

%let DIAGHFRS14        = F00;
%let DIAGHFRS14_ICD8   = ;
%let DIAGLHFRS14       = "Alzheimer Dementia";
%let DIAGHFRS14W       = 7.1;

%let DIAGHFRS15        = F01;
%let DIAGHFRS15_ICD8   = ;
%let DIAGLHFRS15       = "Vascular dementia";
%let DIAGHFRS15W       = 2;

%let DIAGHFRS16        = F03;
%let DIAGHFRS16_ICD8   = ;
%let DIAGLHFRS16       = "Unspecified dementia";
%let DIAGHFRS16W       = 2.1;

%let DIAGHFRS17        = F05;
%let DIAGHFRS17_ICD8   = ;
%let DIAGLHFRS17       = "Delerium";
%let DIAGHFRS17W       = 3.2;

%let DIAGHFRS18        = F10;
%let DIAGHFRS18_ICD8   = ;
%let DIAGLHFRS18       = "Alcohol related mental disorders";
%let DIAGHFRS18W       = 0.7;

%let DIAGHFRS19        = F32;
%let DIAGHFRS19_ICD8   = ;
%let DIAGLHFRS19       = "Depressive episode";
%let DIAGHFRS19W       = 0.5;

%let DIAGHFRS20        = G20;
%let DIAGHFRS20_ICD8   = ;
%let DIAGLHFRS20       = "Parkinson";
%let DIAGHFRS20W       = 1.8;

%let DIAGHFRS21        = G30;
%let DIAGHFRS21_ICD8   = ;
%let DIAGLHFRS21       = "Alzheimers";
%let DIAGHFRS21W       = 4;

%let DIAGHFRS22        = G31;
%let DIAGHFRS22_ICD8   = ;
%let DIAGLHFRS22       = "Other degenerative disease";
%let DIAGHFRS22W       = 1.2;

%let DIAGHFRS23        = G40;
%let DIAGHFRS23_ICD8   = ;
%let DIAGLHFRS23       = "Epilepsy";
%let DIAGHFRS23W       = 1.4;

%let DIAGHFRS24        = G45;
%let DIAGHFRS24_ICD8   = ;
%let DIAGLHFRS24       = "TIA";
%let DIAGHFRS24W       = 1.2;

%let DIAGHFRS25        = G81;
%let DIAGHFRS25_ICD8   = ;
%let DIAGLHFRS25       = "Hemiplegia";
%let DIAGHFRS25W       = 4.4;

%let DIAGHFRS26        = H54;
%let DIAGHFRS26_ICD8   = ;
%let DIAGLHFRS26       = "Blidness";
%let DIAGHFRS26W       = 1.9;

%let DIAGHFRS27        = H91;
%let DIAGHFRS27_ICD8   = ;
%let DIAGLHFRS27       = "Hearing loss";
%let DIAGHFRS27W       = 0.9;

%let DIAGHFRS28        = I63;
%let DIAGHFRS28_ICD8   = ;
%let DIAGLHFRS28       = "Istroke";
%let DIAGHFRS28W       = 0.8;

%let DIAGHFRS29        = I67;
%let DIAGHFRS29_ICD8   = ;
%let DIAGLHFRS29       = "Cerebrovascular disease";
%let DIAGHFRS29W       = 2.6;

%let DIAGHFRS30        = I69;
%let DIAGHFRS30_ICD8   = ;
%let DIAGLHFRS30       = "Sequale cerebrovas dis";
%let DIAGHFRS30W       = 3.7;

%let DIAGHFRS31        = I95;
%let DIAGHFRS31_ICD8   = ;
%let DIAGLHFRS31       = "Hypotension";
%let DIAGHFRS31W       = 1.6;

%let DIAGHFRS32        = J18;
%let DIAGHFRS32_ICD8   = ;
%let DIAGLHFRS32       = "Pneumonia";
%let DIAGHFRS32W       = 1.1;

%let DIAGHFRS33        = J22;
%let DIAGHFRS33_ICD8   = ;
%let DIAGLHFRS33       = "Low resp infection";
%let DIAGHFRS33W       = 0.7;

%let DIAGHFRS34        = J69;
%let DIAGHFRS34_ICD8   = ;
%let DIAGLHFRS34       = "Pneumonitis";
%let DIAGHFRS34W       = 1;

%let DIAGHFRS35        = J96;
%let DIAGHFRS35_ICD8   = ;
%let DIAGLHFRS35       = "Resp failure";
%let DIAGHFRS35W       = 1.5;

%let DIAGHFRS36        = K26;
%let DIAGHFRS36_ICD8   = ;
%let DIAGLHFRS36       = "Duodenal ulcer";
%let DIAGHFRS36W       = 1.6;

%let DIAGHFRS37        = K52;
%let DIAGHFRS37_ICD8   = ;
%let DIAGLHFRS37       = "Gastroenteritis";
%let DIAGHFRS37W       = 0.3;

%let DIAGHFRS38        = K59;
%let DIAGHFRS38_ICD8   = ;
%let DIAGLHFRS38       = "Other intestinal dis";
%let DIAGHFRS38W       = 1.8;

%let DIAGHFRS39        = K92;
%let DIAGHFRS39_ICD8   = ;
%let DIAGLHFRS39       = "Other digestive diseases";
%let DIAGHFRS39W       = 0.8;

%let DIAGHFRS40        = L03;
%let DIAGHFRS40_ICD8   = ;
%let DIAGLHFRS40       = "Cellulitis";
%let DIAGHFRS40W       = 2;

%let DIAGHFRS41        = L08;
%let DIAGHFRS41_ICD8   = ;
%let DIAGLHFRS41       = "Other skin infections";
%let DIAGHFRS41W       = 0.4;

%let DIAGHFRS42        = L89;
%let DIAGHFRS42_ICD8   = ;
%let DIAGLHFRS42       = "Decubitus ulcer";
%let DIAGHFRS42W       = 1.7;

%let DIAGHFRS43        = L97;
%let DIAGHFRS43_ICD8   = ;
%let DIAGLHFRS43       = "Leg ulcer";
%let DIAGHFRS43W       = 1.6;

%let DIAGHFRS44        = M15;
%let DIAGHFRS44_ICD8   = ;
%let DIAGLHFRS44       = "Polyarthrosis";
%let DIAGHFRS44W       = 0.4;

%let DIAGHFRS45        = M19;
%let DIAGHFRS45_ICD8   = ;
%let DIAGLHFRS45       = "Other arthrosis";
%let DIAGHFRS45W       = 1.5;

%let DIAGHFRS46        = M25;
%let DIAGHFRS46_ICD8   = ;
%let DIAGLHFRS46       = "Other joint disorders";
%let DIAGHFRS46W       = 2.3;

%let DIAGHFRS47        = M41;
%let DIAGHFRS47_ICD8   = ;
%let DIAGLHFRS47       = "Scolosis";
%let DIAGHFRS47W       = 0.9;

%let DIAGHFRS48        = M48;
%let DIAGHFRS48_ICD8   = ;
%let DIAGLHFRS48       = "Spinal stenosis";
%let DIAGHFRS48W       = 0.5;
%let DIAGHFRS48C       = diagtype="B";

%let DIAGHFRS49        = M79;
%let DIAGHFRS49_ICD8   = ;
%let DIAGLHFRS49       = "Soft tissue disorder";
%let DIAGHFRS49W       = 1.1;

%let DIAGHFRS50        = M80;
%let DIAGHFRS50_ICD8   = ;
%let DIAGLHFRS50       = "Osteoporosis with facture";
%let DIAGHFRS50W       = 0.8;

%let DIAGHFRS51        = M81;
%let DIAGHFRS51_ICD8   = ;
%let DIAGLHFRS51       = "Osteoporosis without facture";
%let DIAGHFRS51W       = 1.4;

%let DIAGHFRS52        = N17;
%let DIAGHFRS52_ICD8   = ;
%let DIAGLHFRS52       = "Acute renal failure";
%let DIAGHFRS52W       = 1.8;

%let DIAGHFRS53        = N18;
%let DIAGHFRS53_ICD8   = ;
%let DIAGLHFRS53       = "Chronic renal failure";
%let DIAGHFRS53W       = 1.4;

%let DIAGHFRS54        = N19;
%let DIAGHFRS54_ICD8   = ;
%let DIAGLHFRS54       = "Unspecific renal failure";
%let DIAGHFRS54W       = 1.6;

%let DIAGHFRS55        = N20;
%let DIAGHFRS55_ICD8   = ;
%let DIAGLHFRS55       = "Kidney ureter stones";
%let DIAGHFRS55W       = 0.7;

%let DIAGHFRS56        = N28;
%let DIAGHFRS56_ICD8   = ;
%let DIAGLHFRS56       = "Other kidney dis";
%let DIAGHFRS56W       = 1.3;

%let DIAGHFRS57        = N39;
%let DIAGHFRS57_ICD8   = ;
%let DIAGLHFRS57       = "Urinary disorders UTI UIC";
%let DIAGHFRS57W       = 3.2;

%let DIAGHFRS58        = R00;
%let DIAGHFRS58_ICD8   = ;
%let DIAGLHFRS58       = "Heart beat abnorm";
%let DIAGHFRS58W       = 0.7;

%let DIAGHFRS59        = R02;
%let DIAGHFRS59_ICD8   = ;
%let DIAGLHFRS59       = "Gangrene";
%let DIAGHFRS59W       = 1;

%let DIAGHFRS60        = R11;
%let DIAGHFRS60_ICD8   = ;
%let DIAGLHFRS60       = "Nausea vomiting";
%let DIAGHFRS60W       = 0.3;

%let DIAGHFRS61        = R13;
%let DIAGHFRS61_ICD8   = ;
%let DIAGLHFRS61       = "Dysphagia";
%let DIAGHFRS61W       = 0.8;

%let DIAGHFRS62        = R26;
%let DIAGHFRS62_ICD8   = ;
%let DIAGLHFRS62       = "Gait and mobility abnorm";
%let DIAGHFRS62W       = 2.6;

%let DIAGHFRS63        = R29;
%let DIAGHFRS63_ICD8   = ;
%let DIAGLHFRS63       = "Tendency to fall";
%let DIAGHFRS63W       = 3.6;

%let DIAGHFRS64        = R31;
%let DIAGHFRS64_ICD8   = ;
%let DIAGLHFRS64       = "Haematuria";
%let DIAGHFRS64W       = 3;

%let DIAGHFRS65        = R32;
%let DIAGHFRS65_ICD8   = ;
%let DIAGLHFRS65       = "Urinary incontinence";
%let DIAGHFRS65W       = 1.2;

%let DIAGHFRS66        = R33;
%let DIAGHFRS66_ICD8   = ;
%let DIAGLHFRS66       = "Urinary retention";
%let DIAGHFRS66W       = 1.3;

%let DIAGHFRS67        = R40;
%let DIAGHFRS67_ICD8   = ;
%let DIAGLHFRS67       = "Coma stupor";
%let DIAGHFRS67W       = 2.5;

%let DIAGHFRS68        = R41;
%let DIAGHFRS68_ICD8   = ;
%let DIAGLHFRS68       = "Cognitive function";
%let DIAGHFRS68W       = 2.7;

%let DIAGHFRS69        = R44;
%let DIAGHFRS69_ICD8   = ;
%let DIAGLHFRS69       = "General sensation perception";
%let DIAGHFRS69W       = 1.6;

%let DIAGHFRS70        = R45;
%let DIAGHFRS70_ICD8   = ;
%let DIAGLHFRS70       = "Emotional state";
%let DIAGHFRS70W       = 1.2;

%let DIAGHFRS71        = R47;
%let DIAGHFRS71_ICD8   = ;
%let DIAGLHFRS71       = "Speach disturbances";
%let DIAGHFRS71W       = 1;

%let DIAGHFRS72        = R50;
%let DIAGHFRS72_ICD8   = ;
%let DIAGLHFRS72       = "Fever";
%let DIAGHFRS72W       = 0.1;

%let DIAGHFRS73        = R54;
%let DIAGHFRS73_ICD8   = ;
%let DIAGLHFRS73       = "Senility";
%let DIAGHFRS73W       = 2.2;

%let DIAGHFRS74        = R55;
%let DIAGHFRS74_ICD8   = ;
%let DIAGLHFRS74       = "Sencope";
%let DIAGHFRS74W       = 1.8;

%let DIAGHFRS75        = R56;
%let DIAGHFRS75_ICD8   = ;
%let DIAGLHFRS75       = "Convulsions";
%let DIAGHFRS75W       = 2.6;

%let DIAGHFRS76        = R63;
%let DIAGHFRS76_ICD8   = ;
%let DIAGLHFRS76       = "Food and fluid intake";
%let DIAGHFRS76W       = 0.9;

%let DIAGHFRS77        = R69;
%let DIAGHFRS77_ICD8   = ;
%let DIAGLHFRS77       = "Unknown causes of morbidity";
%let DIAGHFRS77W       = 1.3;

%let DIAGHFRS78        = R79;
%let DIAGHFRS78_ICD8   = ;
%let DIAGLHFRS78       = "Abnormal blood chemistry";
%let DIAGHFRS78W       = 0.6;

%let DIAGHFRS79        = R94;
%let DIAGHFRS79_ICD8   = ;
%let DIAGLHFRS79       = "Abnormal function";
%let DIAGHFRS79W       = 1.4;

%let DIAGHFRS80        = S00;
%let DIAGHFRS80_ICD8   = ;
%let DIAGLHFRS80       = "Superficial injury of head";
%let DIAGHFRS80W       = 3.2;

%let DIAGHFRS81        = S01;
%let DIAGHFRS81_ICD8   = ;
%let DIAGLHFRS81       = "Open head wound";
%let DIAGHFRS81W       = 1.1;

%let DIAGHFRS82        = S06;
%let DIAGHFRS82_ICD8   = ;
%let DIAGLHFRS82       = "Intracranial injury";
%let DIAGHFRS82W       = 2.4;

%let DIAGHFRS83        = S09;
%let DIAGHFRS83_ICD8   = ;
%let DIAGLHFRS83       = "Unspecified head injury";
%let DIAGHFRS83W       = 1.2;

%let DIAGHFRS84        = S22;
%let DIAGHFRS84_ICD8   = ;
%let DIAGLHFRS84       = "Rib fracture";
%let DIAGHFRS84W       = 1.8;

%let DIAGHFRS85        = S32;
%let DIAGHFRS85_ICD8   = ;
%let DIAGLHFRS85       = "Spine and pelvis fracture";
%let DIAGHFRS85W       = 1.4;

%let DIAGHFRS86        = S42;
%let DIAGHFRS86_ICD8   = ;
%let DIAGLHFRS86       = "Shoulder fracture";
%let DIAGHFRS86W       = 2.3;

%let DIAGHFRS87        = S51;
%let DIAGHFRS87_ICD8   = ;
%let DIAGLHFRS87       = "Open forarm wound";
%let DIAGHFRS87W       = 0.5;

%let DIAGHFRS88        = S72;
%let DIAGHFRS88_ICD8   = ;
%let DIAGLHFRS88       = "Femur fracture";
%let DIAGHFRS88W       = 1.4;

%let DIAGHFRS89        = S80;
%let DIAGHFRS89_ICD8   = ;
%let DIAGLHFRS89       = "Lower leg superfecial injury";
%let DIAGHFRS89W       = 2;

%let DIAGHFRS90        = T83;
%let DIAGHFRS90_ICD8   = ;
%let DIAGLHFRS90       = "Complica urogenital implants";
%let DIAGHFRS90W       = 2.4;

%let DIAGHFRS91        = T89;
%let DIAGHFRS91_ICD8   = ;
%let DIAGLHFRS91       = "Nosocomial infect";
%let DIAGHFRS91W       = 1.2;

%let DIAGHFRS92        = Z22;
%let DIAGHFRS92_ICD8   = ;
%let DIAGLHFRS92       = "Carrier infect dis";
%let DIAGHFRS92W       = 1.7;

%let DIAGHFRS93        = Z50;
%let DIAGHFRS93_ICD8   = ;
%let DIAGLHFRS93       = "Rehabilitation";
%let DIAGHFRS93W       = 2.1;

%let DIAGHFRS94        = Z60;
%let DIAGHFRS94_ICD8   = ;
%let DIAGLHFRS94       = "Social problems";
%let DIAGHFRS94W       = 1.8;

%let DIAGHFRS95        = Z73;
%let DIAGHFRS95_ICD8   = ;
%let DIAGLHFRS95       = "Life management difficulty";
%let DIAGHFRS95W       = 0.6;

%let DIAGHFRS96        = Z74;
%let DIAGHFRS96_ICD8   = ;
%let DIAGLHFRS96       = "Care provider dependency";
%let DIAGHFRS96W       = 1.1;

%let DIAGHFRS97        = Z75;
%let DIAGHFRS97_ICD8   = ;
%let DIAGLHFRS97       = "Medical facilities problems";
%let DIAGHFRS97W       = 2;

%let DIAGHFRS98        = Z87;
%let DIAGHFRS98_ICD8   = ;
%let DIAGLHFRS98       = "History of other disease";
%let DIAGHFRS98W       = 1.5;

%let DIAGHFRS99        = Z91;
%let DIAGHFRS99_ICD8   = ;
%let DIAGLHFRS99       = "History of risk factor";
%let DIAGHFRS99W       = 0.5;

%let DIAGHFRS100        = Z93;
%let DIAGHFRS100_ICD8   = ;
%let DIAGLHFRS100       = "Artificial opening status";
%let DIAGHFRS100W       = 1;

%let DIAGHFRS101        = Z99;
%let DIAGHFRS101_ICD8   = ;
%let DIAGLHFRS101       = "Enabling devices dependency";
%let DIAGHFRS101W       = 0.8;

%let DIAGHFRSN         = 101;


/* HAS-BLED bleeding risk score */
%IndicatorDef(LPR, hasbled1, "Renal disease", &LPRCrenal, icd8=&LPRCrenal_ICD8, w=1);
%IndicatorDef(LPR, hasbled2, "Liver disease", &LPRLiver, icd8=&LPRLiver_ICD8, w=1);
%IndicatorDef(LPR, hasbled3, "Stroke (IStroke or TIA)", &LPRIStroke &LPRTIA,
              icd8= &LPRIStroke_ICD8 &LPRTIA_ICD8, w=1);
%IndicatorDef(LPR, hasbled4, "Bleeding", &LPRGIbleed &LPRICbleed &LPRIMbleed &LPRgenbleed &LPRocbleed,
              icd8=&LPRGIbleed_ICD8 &LPRICbleed_ICD8 &LPRIMbleed_ICD8 &LPRgenbleed_ICD8 &LPRocbleed_ICD8, w=1);
%IndicatorDef(LPR, hasbled5, "Alcohol", &LPRAlco, icd8=&LPRAlco_ICD8, w=1, wdays=180);

%IndicatorDef(CPR, hasbled1, "Age>=65", empty, w=1,
              crit=((%MCSDate-birthdate)/365)>=65); /*IGNORE THE WARNING. Placeholder used in multicoscores.sas*/

%IndicatorDef(OTH, hasbled1, "Hypertension (diagnosis or medicated (2+ drugs))", empty, w=1,
              crit=((HypertensionDiag&MCSDdate>0) + (HypertensionMedi&MCSDdate>0))>0);
/*IGNORE THE WARNING. Placeholder used in multicoscores.sas*/

%IndicatorDef(ATC, hasbled1, "Drugs", &ATCAspirin &ATCclopi &ATCnsaid, w=1, wdays=180);


/* CHA2DS2-VASc stroke risk score */

%IndicatorDef(LPR, cha2ds2vasc1, "Stroke (IStroke or SE or TIA)", &LPRIStroke &LPRTIA &LPRSE,
              icd8= &LPRIStroke_ICD8 &LPRTIA_ICD8 &LPRSE_ICD8, w=2);
%IndicatorDef(LPR, cha2ds2vasc2, "Vascular disease (MI or PAD3)", &LPRMI &LPRPAD3,
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
%IndicatorDef(ATC, HeartFailMedi1, &ATCcloop, &ATCloop, w=1);
%IndicatorDef(ATC, HeartFailMedi2, &ATCLRenin, &ATCRenin, w=1);
%IndicatorDef(LPR, HeartFailDiag1, &LPRHFStr, &LPRHFStr, icd8=&LPRHFStr_ICD8, w=1);


/* Diabetes, used in CHA2DS2-VASc */
%IndicatorDef(ATC, DiabetesMedi1, &ATCDiabetesATC, &ATCDiabetesATC, w=1);
%IndicatorDef(LPR, DiabetesDiag1, &LPRDiabLPR, &LPRDiabLPR, icd8=&LPRDiabLPR_ICD8, w=1);


/* Hypertension, used in CHA2DS2VASC and HAS-BLED */
%IndicatorDef(ATC, HypertensionMedi1, &ATCAlfa, &ATCAlfa, w=1);
%IndicatorDef(ATC, HypertensionMedi2, &ATCLNonloop, &ATCNonloop, w=1);
%IndicatorDef(ATC, HypertensionMedi3, &ATCLVaso, &ATCVaso, w=1);
%IndicatorDef(ATC, HypertensionMedi4, &ATCLBeta, &ATCBeta, w=1);
%IndicatorDef(ATC, HypertensionMedi5, &ATCLCalcium, &ATCCalcium, w=1);
%IndicatorDef(ATC, HypertensionMedi6, &ATCLRenin, &ATCRenin, w=1);
%IndicatorDef(LPR, HypertensionDiag1, &LPRHylLPR, &LPRHylLPR, icd8=&LPRHylLPR_ICD8, w=1);


/* Hypertension combination drugs, used in CHA2DS2VASC and HAS-BLED */
%IndicatorDef(ATC, CombHypertensionMedi1, "Combination drugs Hypertension",
              C09BB04 C09DA C09DB C09CX01 C09DX04 C07B, w=1);
