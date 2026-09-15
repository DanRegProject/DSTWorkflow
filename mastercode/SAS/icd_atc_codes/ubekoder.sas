/* SVN header
$Date: 2018-07-13 11:31:45 +0200 (fr, 13 jul 2018) $
$Revision: 115 $
$Author: FCNI6683 $
$Id: UBEkoder.sas 115 2018-07-13 09:31:45Z FCNI6683 $
*/
/* procedure codes, use UBE and UBEL prefix', use full code */
/* getOPR is used to extract data, with option type=UBE */

/* abla - Ablation */
%IndicatorDef(type=UBE, name=abla, short_txt="Ablation", code=BFFB);

/* afliab - Atrial fibrillation ablation  */
%IndicatorDef(type=UBE, name=afliab, short_txt="Atrial Fibrillation Ablation", code=BFFB04);

/* afluab - Atrial flutter ablation  */
%IndicatorDef(type=UBE, name=afluab, short_txt="Atrial Flutter Ablation", code=BFFB03);

/* Angio - Angiography  */
%IndicatorDef(type=UBE, name=Angio, short_txt="Angiography", code=UXAG UXAC10);

/* cag - coronary angiography - kranspulsåreundersøgelse */
%IndicatorDef(type=UBE, name=CAG, short_txt="Coronary angiography", code=UXAC85);

/* CT - CT-scan   */
%IndicatorDef(type=UBE, name=ct, short_txt="CT-scan", code=UXC);

/* CT1 - CT-scan   */
%IndicatorDef(type=UBE, name=ct1, short_txt="CT-scan", code=UXCG UXCC);

/* CVK - Central venous catheter */
%IndicatorDef(type=UBE, name=CVK, short_txt="Central venous catheter", code=BMBZ61 BMBZ71 BMBZ51 BMLA01 BMBLA02 BMBLA03);

/* dc - dc konvertering */
%IndicatorDef(type=UBE, name=dc, short_txt="DC-konvertering", code=BFFA01);

/* dialys - Acute and chronic dialysis, haemo & peritoneal */
%IndicatorDef(type=UBE, name=dialys, short_txt="Acute and chronic dialysis, haemo & peritoneal", code=BJFD);

/* dialys2 - Dialysis in Chronic kidney disease, haemo & peritoneal */
%IndicatorDef(type=UBE, name=dialys2, short_txt="Dialysis in Chronic kidney disease, haemo & peritoneal", code=BJFD2);

/* ec - Electrical cardioversion */
%IndicatorDef(type=UBE, name=ec, short_txt="Electrical cardioversion", code=BFFA00 BFFA01 BFFA04);

/* Ecco - Ultrasonograpy including echocardiography   */
%IndicatorDef(type=UBE, name=Ecco, short_txt="Ultrasonograpy including echocardiography", code=UXUC80 UXUC81);

/* HRTUBE - Hormone replacement therapy */
%IndicatorDef(type=UBE, name=HRTUBE, short_txt="Hormone replacement therapy", code=BBHG0);

/* MRveno - MR venography - tillægskode! */
%IndicatorDef(type=UBE, name=MRveno, short_txt="MR venography", code=UXZ52);

/* MyeloSKS - Myeloproliferative disorders (polycythemia vera, essential thrombocytemia)  */
%IndicatorDef(type=UBE, name=MyeloSKS, short_txt="Myeloproliferative disorders (polycythemia vera, essential thrombocytemia)", code=ZM99503 ZM99623);

/* ObesUBE  - behandlings- og plejeklassifikation */
%IndicatorDef(type=UBE, name=Obesube, short_txt="Obesity", code=BQFT03 BQFS01);

/* pm - Pacemaker */
%IndicatorDef(type=UBE, name=PM, short_txt="Pacemaker", code=BFCA0 BFCA6 BFCA9);

/* ullow - Ultrasonography UE  - Klassifikation af undersøgelser */
%IndicatorDef(type=UBE, name=ullow, short_txt="Ultrasonography UE", code=UXUG);

/* VentPerf - Ventilation-perfusion examination  - klassifikation af undersøgelser */
%IndicatorDef(type=UBE, name=VentPerf, short_txt="Ventilation-perfusion examination", code=WLHGS);
