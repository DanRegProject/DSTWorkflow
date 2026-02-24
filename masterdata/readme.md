# Klargøring af registerdata fra Danmarks Statistik

**SAS-programsamling til etablering af analyseklare studiedata**

## Formål

Denne programsamling har til formål at klargøre registerdata fra
Danmarks Statistik til brug i epidemiologiske registerstudier.

Programforløbet styres via `master.sas`, som sekventielt afvikler en
række delprogrammer, der tilsammen etablerer:

-   Ensartede og harmoniserede registerdatasæt\
-   Konsistente nøglestrukturer\
-   Populations- og forløbsregistre\
-   Multikomorbiditetsregistre og kliniske risikoscorer\
-   Afdelingstyperegister

Strukturen er modulær og kan med begrænset tilretning genanvendes i
andre projekter.

------------------------------------------------------------------------

# Overordnet programstruktur

Pipeline-strukturen kan opdeles i seks hovedfaser:

1.  Validering og kopiering af rawdata\
2.  Ensretning og harmonisering\
3.  Nøglekonstruktion og omkodning\
4.  Konstruktion af populations- og forløbsregistre\
5.  Multikomorbiditets- og risikoscoremodul\
6.  Afdelingstyperegister

------------------------------------------------------------------------

# 1. Validering og etablering af arbejdsdata

### `0-TestIndholdiRaw.sas`

Kontrollerer at nødvendige datasæt findes i `rawdata`.

### `1-KopierDataFraRaw.sas`

-   Kopierer SAS-datasæt fra `rawdata` til projektets masterområde
    (`workdata`).
-   Understøtter reference til rawdata via views.
-   Årsopdelte datasæt fastholdes i vid udstrækning for at reducere
    svartider ved meget store registre.
-   I enkelte tilfælde fjernes variable allerede i denne fase.

Formålet er at etablere et stabilt og kontrolleret datagrundlag.

------------------------------------------------------------------------

# 2. Ensretning og harmonisering

### `2_1-EnsretVariable.sas`

-   Standardiserer variabelnavne, typer og formater.
-   Harmoniserer registre med forskellig struktur.

### `2_2-EnsretLPR2Data.sas`

-   Særlig håndtering af LPR2.
-   Strukturharmonisering af diagnose- og kontaktdatastruktur.

### `2_3-DanAarstabeller.sas`

-   Organiserer eller genererer årstabeller.
-   Understøtter arbejde med årsopdelte registre.

Dette trin reducerer strukturel heterogenitet og sikrer, at
downstream-programmer kan arbejde med ensartede datastrukturer.

------------------------------------------------------------------------

# 3. Nøglekonstruktion og omkodning

### `3_1-LavNøgler.sas`

-   Opretter nye identvariable.
-   Understøtter OPEN's anbefaling om integerbaserede nøgler.

### `3_2-OmkodeMedNøgler.sas`

-   Omskriver registre til brug af de nye nøgler.
-   Sikrer konsistent kobling på tværs af registre.

**Bemærkning:**\
Det anbefales generelt at bevare originale identer frem til dannelsen af
studiedatasæt af hensyn til transparens og læsbarhed. Konvertering til
integer-nøgler kan overvejes ved endelig studiedata.

------------------------------------------------------------------------

# 4. Konstruktion af populations- og forløbsregistre

### `4-LavPopulationsForløbsregister.sas`

-   Danner populationsafgrænsninger.
-   Konstruerer forløbsdata.
-   Etablerer indeksdatoer og tidsmæssige relationer mellem hændelser.

Dette trin markerer overgangen fra rå registerdata til en
analyseorienteret datamodel.

------------------------------------------------------------------------

# 5. Multikomorbiditets- og risikoscoremodul

### `5-LavMulticomorbiditetsregister.sas`

Aktiveres via flag:

``` sas
MCOflag = TRUE;
```

Anvender makroerne:

-   `%get()`
-   `%makemulticotables()`

Output placeres i `MCOlib`.

## Understøttede indikatorer

Makrostrukturen (fx `%IndicatorDef`) muliggør fleksibel definition af:

-   LPR-baserede diagnoser (ICD8/ICD10)
-   ATC-baserede medicinkriterier
-   CPR-baserede demografiske kriterier
-   Logiske kriterier (`crit=`)
-   Tidsvinduer (`wdays=`)
-   Vægtning (`w=`)

Eksempler på risikoscorer:

-   Charlson Comorbidity Index
-   HAS-BLED
-   CHA₂DS₂-VASc

Modulet er generisk opbygget og kan relativt enkelt udvides med nye
indikatorer.

------------------------------------------------------------------------

# 6. Afdelingstyperegister

### `6-LavAfdelingstyperegister.sas`

-   Klassificerer behandlingsafdelinger.
-   Kan anvendes som kovariat i analyser.

------------------------------------------------------------------------

# Designprincipper

-   Modulær opbygning
-   Genanvendelig struktur
-   Makrodrevet indikatorlogik
-   Performancehensyn via årsopdelte datasæt
-   Adskillelse mellem rådata, masterdata og derived data
-   Konfigurerbar risikoscoregenerering

------------------------------------------------------------------------

# Anvendelse i nye projekter

Programsamlingen kan genbruges med begrænset tilretning. Typiske
justeringer omfatter:

-   Biblioteksreferencer
-   Projekt-specifikke inklusionskriterier
-   Aktivering/deaktivering af multikomorbiditetsmodul
-   Udvidelse af indikatorbibliotek

------------------------------------------------------------------------

# Målgruppe

Programmerne er udviklet til brugere med erfaring i:

-   Afvikling af SAS-programmer
-   Makroprogrammering
-   Arbejde med store registerdatasæt
-   Registerkobling og populationsafgrænsning

Forløbet forudsætter kendskab til struktur og indhold af danske
sundhedsregistre.

------------------------------------------------------------------------

**Forfatter:**\
Flemming Skjøth\
Senest opdateret: 27-08-2025
