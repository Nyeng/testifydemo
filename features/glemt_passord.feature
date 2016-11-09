#language: no

Egenskap: Verifisere korrekt oppførsel når bruker taster inn feil passord

  Bakgrunn: Bruker skal være utlogget før tests
    Gitt at vi har en testbruker "vegard.nyeng@nrk.no"
    Når vi går mot testsiden "https://innlogging.nrk.no"
    Så skal vi være utlogget fra innloggingstjenesten

  @1
  Scenario: Bekreft passord-tilbakemelding på feil passord
    Gitt at jeg er på innloggingssiden for første gang på en stund
    Og jeg har fylt ut feil passord i "Passord"-feltet 3 ganger
    Så skal brukeren ikke få en varsling om antall forsøk tilgjengelig før utestenging

