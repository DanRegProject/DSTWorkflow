Klargør Rawdata til workdata

SASdatafilerne i rawdata kopieres over i workdata til masterdata/data/sas/master.

OPEN foreslår at man samler data der leveret opdelt i årsdatasæt. Dette kan være hensigtsmæssigt for at gøre det nemt at tilgå data, men for meget store datasæt kan det give meget lange svartider. De årsopdelte data er derfor i vid udstrækning fastholdt. Programmerne understøtter at data i rawdata kan refereres til via views.

Der er enkelte tilfælde hvor der fjernes variable fra rawdata.

Det samlede program vil kunne anvendes umiddelbart i andre projekter med minimal tilretning.

Sidst i filen dannes grunddata til beregning af riskscores, fx charlson og cha2ds2vasc. Dette kræver adgang til makroerne %get() og %makemulticotables(). Data til disse placeres i MCOlib. Hvis de skal dannes sættes MCOflag = TRUE.

Der kan laves nye identvariable, jf anbefaling fra OPEN, hvorved strings erstattes af integers. Min anbefaling er at undlade erstatning af identer før dannelsen af studiedatasæt. Ved studiedatasæt kan det overvejes af hensyn til læsbarhed af data.

Flemming Skjøth, 27-08-2025
