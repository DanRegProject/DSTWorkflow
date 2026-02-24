/* definitions 2020 */

/*alcorel - alcohol related diseases*/
%let DIAGalcorel = e244 e529a f105 f106 f107 f108 f109 g312 g621 g721 i426 k292 k70 k852 k860 l278a o354 p043;
%let DIAGlalcorel = "alcohol related diseases";

/*alco - alcohol abuse*/
%let DIAGalco = f100 f101 f102 f103 f104 r780 t500a t51 x65 z714 z721 z358m10 z39310 z3932 z502 z714 z721;
%let DIAGlalco = "alcohol abuse";

/*copd - chronic obstructive pulmonary disorder (kol)*/
%let DIAGcopd = j44 alal21;
%let DIAGlcopd = "chronic obstructive pulmonary disorder (kol)";

/*diablpr - diabetes mellitus*/
%let DIAGdiablpr = e10 e11 e12 e13 e14 h360 o240 o241 o242 o243;
%let DIAGldiablpr = "diabetes mellitus";

/*diabcomp - diabetes with chronic complications*/
%let DIAGdiabcomp = e102 e103 e104 e105 e106 e107 e108 e112 e113 e114 e115 e116 e117 e118 h360;
%let DIAGldiabcomp = "diabetes with chronic complications";

/*dvtall - deep venous thrombosis (inclusive)*/
%let DIAGdvtall = i636 i676 i801 i802 i803 i808 i809 i819 i822 i823 i828 i829 o223 o229 o871 o879;
%let DIAGldvtall = "deep venous thrombosis (inclusive)";

/*dvtstr - deep venous thrombosis (exclusive)*/
%let DIAGdvtstr = i801 i802 i803 i808 i809;
%let DIAGldvtstr = "deep venous thrombosis (exclusive)";

/*hf - heart failure (inclusive cardiomyopathies)*/
%let DIAGhf = i110 i130 i132 i420 i50 i426 i427 i429;
%let DIAGlhf = "heart failure (inclusive cardiomyopathies)";

/*hfstr - heart failure str version*/
%let DIAGhfstr = i110 i130 i132 i420 i50;
%let DIAGlhfstr = "heart failure str version";

/*hyplpr - hypertension*/
%let DIAGhyplpr = i10 i11 i12 i13 i15;
%let DIAGlhyplpr = "hypertension";

/*ihd - ischemic heart disease*/
%let DIAGihd = i20 i21 i23 i24 i25;
%let DIAGlihd = "ischemic heart diseasen";

/*liver - clinically relevant liver disease*/
%let DIAGliver = b150 b160 b162 b18 b190 i85 k700 k701 k702 k703 k704 k709 k71 k72 k73 k74 k760 k766;
%let DIAGlliver = "clinically relevant liver disease";

/*miall - myocardial infarction*/
%let DIAGmiall = i21 i23 i24;
%let DIAGlmiall = "myocardial infarction";

/*mistr - myocardial infarction str version*/
%let DIAGmistr = i21;
%let DIAGlmistr = "myocardial infarction str version";

/*mitralrheu - rheumatic mitral valve disease*/
%let DIAGmitralrheu = i05 i080a i081a i083a;
%let DIAGlmitralrheu = "rheumatic mitral valve disease";

/*mitstenspec - mitral stenosis rheumatic and nonrheumatic*/
%let DIAGmitstenspec = i050 i052 i342;
%let DIAGlmitstenspec = "mitral stenosis rheumatic and nonrheumatic";

/*obese25 - obesity (bmi = 25)*/
%let DIAGobese25 =e65 e66;
%let DIAGlobese25 = "obesity (bmi = 25)";

/*obese30 - obesity (bmi = 30)*/
%let DIAGobese30 =e660b e660c e660d e660e e660f e660g e660h;
%let DIAGlobese30 = "obesity (bmi = 30)";

/*obeseall - obesity (inklusiv foelger af overvaegt anden overvagt)*/
%let DIAGobeseall = e65 e66 e67 e68;
%let DIAGlobeseall = "obesity (inklusiv foelger af overvaegt anden overvaegt)";

/*padall dah peripheral arterial disease*/
%let DIAGpadall = i70 i73 i74;
%let DIAGlpadall = "peripheral arterial disease";

/*padstr - peripheral arterial ischemic disease*/
%let DIAGpadstr = i702 i739a i739c i74;
%let DIAGlpadstr = "peripheral arterial ischemic disease";

/*padembo - peripheral arterial thromboemboli for s2 in cha2ds2vasc*/
%let DIAGpadembo = i74;
%let DIAGlpadembo = "peripheral arterial thromboemboli for s2 in ch2ds2vasc";

/*padvasc - peripheral vascular/ischemic disease and aortic plague for part of vasc in cha2ds2asc*/
%let DIAGpadvasc = i700 i702 i708 i709 i739;
%let lplpadvasc = "peripheral vascular/ischemic disease and aortic plague for part of vasc in cha2ds2vasc";

/*pneu - pneumonia*/
%let DIAGpneu = j12 j13 j14 j15 j16 j17 j18;
%let DIAGlpneu = "pneumonia";

/*renalchronic - chronic kidney disease*/
%let DIAGrenalchronic = e102 e112 e142 i120 i131 i132 i150 i151 n03 n04;
%let DIAGlrenalchronic = "chronic kidney disease";

/*renal - renal disease*/
%let DIAGrenal = i12 i13 n00 n01 n02 n03 n04 n05 n07 n11 n14 n18 n19 q61 n17;
%let DIAGlrenal = "renal disease";

/*vteall - venous thromboembolism (inclusive)*/
%let DIAGvteall = h348e h348f i26 i636 i676 i801 i802 i803 i808 i809 i81 i822 i823 i828 i829 o223 o225 o229 o871 o879 o873 o882 t917c t817d;
%let DIAGlvteall = "venous thromboembolism (inclusive)";

/*vtestr - venous thromboembolism (exclusive)*/
%let DIAGvtestr = i26 i801 i802 i803 i808 i809;
%let DIAGlvtestr = "venous thromboembolism (exclusive)";
