#language: no
# encoding: UTF-8
Egenskap: Device login. Jeg skal kunne logge inn med å aktivere enn kode fra de store skjermene: apple tv, smart tv etc

  @1
  Abstrakt Scenario: Generere engangskode
    Gitt at jeg skal teste client login med klienten <klient>
    Når jeg kaller engangskode for klienten
    Så skal jeg få generert opp en engangskode uten tall
    Eksempler:
      |klient|
      |Stue|

  @2
  Abstrakt Scenario: Polling av aktiveringskode
    Gitt at jeg skal teste client login med klienten <klient>
    Når jeg kaller engangskode for klienten
    Og jeg poller aktiveringskoden etter <tid> sekunder
    Så skal jeg få responskode 202
    Eksempler:
      | klient |tid     |
      | Stue   |0       |
      | Stue   |10      |

  @4
  Abstrakt Scenario: Aktivere kode
    Gitt at jeg skal teste client login med klienten <klient>
    Når jeg kaller engangskode for klienten
    Og jeg aktiverer engangskoden
    Så skal jeg få beskjed om at enheten er aktivert
    Og jeg poller aktiveringskoden etter <tid> sekunder
    Så skal jeg få responskode 200
    Eksempler:
      |klient|tid|
      |Maskin|0    |

  @5
  Abstrakt Scenario: Hente ut token
    Gitt at jeg skal teste client login med klienten <klient>
    Når jeg kaller engangskode for klienten
    Og jeg aktiverer engangskoden
    Så skal jeg få beskjed om at enheten er aktivert
    Og at jeg poller aktiveringskoden for å hente ut en kode
    Så skal jeg kunne hente ut access token
    Eksempler:
      |klient|
      |Kjeller|

  @6
  Abstrakt Scenario: Hente brukerinfo
    Gitt at jeg skal teste client login med klienten <klient>
    Når jeg gjennomfører login for å hente ut access token
    Så  skal jeg få hentet ut brukerdataen min
    Eksempler:
      |klient|
      |Nasa|

  @7
  Abstrakt Scenario: Utlogging
    Gitt at jeg skal teste client login med klienten <klient>
    Når jeg gjennomfører login for å hente ut access token
    Og jeg prøver å logge ut med refresh token
    #Så skal jeg bli logget ut
    Eksempler:
      |klient|
      |Loft|
        #TODO: Lag scenario for hva som skal skje når koden er ugyldig og du poller og når man poller samtidig
  @8
  Abstrakt Scenario: Polle kode samtig
    Gitt at jeg skal teste client login med klienten <klient>
    Når jeg kaller engangskode for klienten
    Og jeg poller aktiveringskoden etter <tid> sekunder
    #Så skal jeg bli logget ut
    Eksempler:
      |klient|tid|
      |Loft|0    |



