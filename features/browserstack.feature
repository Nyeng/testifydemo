#language: no

Egenskap: Hvordan skalerer nettsiden til Testify

  Bakgrunn:
    Gitt at vi går mot testsiden "http://www.testify.no/"

  @1
  Scenariomal: Browserstack
    Når jeg navigerer til undersiden "medarbeidere.html"
    Og jeg setter skjermstørrelsen til <bredde> og <høyde>
    Så skal jeg kunne klikke på <kontaktlenken>
    Eksempler:
      | bredde | høyde | kontaktlenken |
      | 1280   | 720   | Kontakt       |
      | 480    | 854   | Medarbeidere  |
      | 540    | 960   | Tjenester     |
      | 1920   | 1080  | Om oss        |
      | 480    | 800   | Produkter     |
      | 320    | 480   | Home          |
      | 500    | 800   | Moro          |