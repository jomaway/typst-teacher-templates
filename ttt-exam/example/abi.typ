#import "@preview/ttt-exam:0.1.0": *
#import "@preview/wrap-it:0.1.0": * 
#set text(size: 13pt, font: ("Rubik"), weight: 300, lang: "de")

#let logo = image("logo.jpg") 
#show: exam.with(title: "ABI", subtitle: "2023", subject: "Mathe", logo: logo, authors: "ISB", date: datetime(year:2023, month:05, day:03) );

= Teil 1: Analysis 

#assignment[
  Auf einer Autobahn entsteht morgens an einer Baustelle häufig ein Stau.

  #let fig = [#figure(
    image("abb1.png", width: 5cm),
  )<fig1>]

    #wrap-content(
    align: top + right,
    fig
  )[
    An einem bestimmten Tag entsteht der Stau um 06:00 Uhr und löst sich bis 10:00 Uhr vollständig auf. Für diesen Tag kann die momentane Änderungsrate der Staulänge mithilfe der in $R$   definierten Funktion f mit 
    $ f(x) = x dot (8 - 5x) dot ( 1 - x/4)² = -5/16 x⁴ + 3x³ -9x² +8x $

  ]

  beschrieben werden. Dabei gibt x die nach 06:00 Uhr vergangene Zeit in Stunden und $f(x)$   die momentane Änderungsrate der Staulänge in Kilometern pro Stunde an. Die Abbildung 1 zeigt den Graphen von f für $0≤ x ≤ 4$. Für die erste Ableitungsfunktion von $f$ gilt $f'(x) = (5x²-16x+8) dot (1-x/4)$.

  #question(points: 3)[
     Nennen Sie die Zeitpunkte, zu denen die momentane Änderungsrate der Staulänge den Wert null hat, und begründen Sie anhand der Struktur des Funktionsterms von f, dass es keine weiteren solchen Zeitpunkte gibt
  ]

  #question(points: 1)[
    Es gilt $f(2)<0$. Geben Sie die Bedeutung dieser Tatsache im Sachzusammenhang an.
  ]

  #question(points:5)[
    Bestimmen Sie rechnerisch den Zeitpunkt, zu dem die Staulänge am stärksten zunimmt. 
  ]

  #question(points:2)[
    Geben Sie den Zeitpunkt an, zu dem der Stau am längsten ist. Begründen Sie Ihre Angabe. 
  ]

  Im Sachzusammenhang ist neben der Funktion f die in IR definierte Funktion s mit 
  $ s(x) = (x/4)² dot (4-x)³ = -1/16x⁵ + 3/4x⁴ -3x³ + 4x² $ von Bedeutung.


#pagebreak()
  #question(points:4)[
    Begründen Sie, dass die folgende Aussage richtig ist:

    _Die Staulänge kann für jeden Zeitpunkt von 06:00 Uhr bis 10:00Uhr durch die Funktion s angegeben werden._

    Bestätigen Sie rechnerisch, dass sich der Stau um 10:00 vollständig aufgelöst hat.
    
  ]

  #question(points:3)[
    Berechnen Sie die Zunahme der Staulänge von 06:30 Uhr bis 08:00 Uhr und bestimmen Sie für diesen Zeitraum die mittlere Änderungsrate der Staulänge.
  ]

  #question(points:3)[
    #let fig = [#figure(
        image("abb2.png", width: 5cm),
        // supplement: "Abb.",
      )<fig2>  ]
    #wrap-content(
      align: top + right,
      fig,
    )[
      Für einen anderen Tag wird die momentane Änderungsrate der Staulänge für den Zeitraum von 06:00 Uhr bis 10:00 Uhr durch den in der @fig2 gezeigten Graphen dargestellt. Dabei ist x die nach 06:00 Uhr vergangene Zeit in Stunden und y die momentane Änderungsrate
      der Staulänge in Kilometern pro Stunde.
    ]

    Um 07:30 Uhr hat der Stau eine bestimmte Länge. Es gibt einen anderen Zeitpunkt, zu dem der Stau die gleiche Länge hat. Markieren Sie diesen Zeitpunkt in der Abbildung 2, begründen Sie Ihre Markierung und veranschaulichen Sie Ihre Begründung in der @fig2.  

  ]

  #caro(22)


]


