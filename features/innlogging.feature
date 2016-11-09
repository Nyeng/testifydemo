#language: no

Egenskap: Demonstrere egenskapene til features og Cucumber ved bruk av Capybara

  Bakgrunn: Bruker skal være utlogget før tests
    Gitt at vi har en testbruker "vegard.nyeng@nrk.no"
    Når vi går mot testsiden "https://innlogging.nrk.no"
    Så skal vi være utlogget fra innloggingstjenesten

  @1
  Scenario: Endre registrerte brukerdata
    Gitt at jeg er på innloggingssiden
    Når jeg logger inn
    Og jeg går til profil-siden
    Så skal jeg kunne endre følgende felter
      | FirstName    |
      | LastName     |
      | PostalNumber |
      | Brukernavn   |





