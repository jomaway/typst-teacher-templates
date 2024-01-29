#import "@local/schulzeug:0.1.0": *

#import templates.exam: *


#set text(size: 12pt, font: ("Rubix","Source Sans Pro"), weight: 300)

#let logo = box(height: 2cm, image("logo.jpg", fit: "contain")) 
#let details = toml("details.toml")
#show: exam.with(..details.exam, title: logo_title(logo, details.exam.title));
#show: schulzeug-assignments.with(lang: "de");

#point-table

#assignment[Grundlagen LAN]

Sie sollen im Rahmen eines Projektes das LAN im neuen Schulungsraum aufbauen. \
Dazu müssen neue Netzwerkkompenenten bestellt und konfiguriert werden.

#question(points: 4)[*Erläutern* Sie den *Unterschied* zwischen aktiven und passiven Netzwerkkompenenten und geben Sie jeweils *ein Beispiel* an.]
aktiv #sym.arrow.r #solution(alt: lines(2))[mit Stromverbindung z.B. Switch/Router]

passiv #sym.arrow.r #solution(alt: lines(2))[ohne Stromverbindung z.B. Leitungen]

#question(points: 3)[Geben Sie *3 Kriterien* an, die bei der Vergabe von IP-Adressen *im gleichen LAN* beachtet werden müssen.]
#solution(alt: lines(6))[
    - Keine IP doppelt vergeben
    - Broadcast und Netzwerkadresse dürfen nicht an Hosts vergeben werden.
    - Alle Geräte brauchen den gleichen Netzanteil / Subnetzmaske.
]

#question(points: 3)[Es müssen 31 Host adressiert werden. Berechnen (_Rechenweg_) Sie die *Subnetzmaske* (_Angabe in dezimal_) passend zur Anzahl der benötigten Hosts. Geben Sie die Subnetzmaske in *dezimaler* und *CIDR-Notation*. an]
*Rechenweg:*
#solution(alt: lines(5))[
    $2⁵-2=32-2=30$ adressierbare Host #sym.arrow.r zu wenig!
    $2⁶-2 = 64-2 = 62 $ addressierbare Hosts. Daher werden 6 Hostbits benötigt. $32-6=26$ #sym.arrow.r `/26` Subnetzmaske.
    Umrechnung in Dezimal im letztes Oktet: `1100 0000`#sub[(bin)] = `192`#sub[(dez)]
]
#grid(
    columns: (auto,1fr,auto,1fr),
    [*dezimal:*], solution(alt: align(bottom)[#h(0.4em) #lines(1) #h(0.4em)])[`255.255.255.192`], [*CIDR-Präfix:*], solution(alt: align(bottom)[#h(0.4em) #lines(1) #h(0.4em)])[`\26`]
)

#pagebreak()
#assignment(points: 5)[Kreuzen Sie die richtige Lösung an.]

#question[Welche Adresse ist eine *Broadcast*-Adresse?
#let addr = (`201.55.255.155/26`, `23.255.223.127/26`, `1.255.25.128/26`, `192.223.240.65/26`, `10.255.0.255/12`)
#mct(choices:addr, answer:2)]

#question[Welche *Netz*-Adresse ist *ungültig*?
#let addr = (`25.240.0.0/15`, `125.255.24.0/23`, `195.196.197.240/28`, `215.1.2.221/25`, `24.0.0.0/24`)
#mct(choices:addr, answer:4)]

#question[Welche Adresse ist eine *gültige Host*-Adresse?] 
#let addr = (`16.63.255.255/24`, `126.128.0.0/16`, `16.127.255.255/8`, `95.0.0.0/24`, `13.130.254.255/28`)
#mct(choices:addr, answer:3)

#question[Welche Host-Adresse liegt *im Netzwerk* `207.248.255.0/24`?]
  #let addr = (`207.249.255.1`, `207.248.254.255`, `207.248.253.0`, `207.248.255.245`, `207.248.255.255`)
  #mct(choices:addr, answer:(1,4))

= Letzte Aufgabe

#question(points: 5)[Beschreiben Sie welche Probleme beim Routing auftreten können.]

#assignment(points: 8)[Ende]

#point-sum-box
#point-table
