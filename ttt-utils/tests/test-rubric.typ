#import "../lib/rubric.typ": *
#import "../lib/assignments.typ": *
#set page(margin: 2cm)


#let criteria = (
  "Bewertungskriterium",
  "One", "Two", "Three"
)

#let levels = (
  "Nicht erfüllt",
  // "Ansatz erkennbar",
  "Teilweise erfüllt",
  "Vollständig erfüllt"
)

#let levels2 = (
  (value: 4, label:"A"),
  (value:0, label: "B"),
)

#assignment(collect-points: true)[
  Assignment rubric
  #rubric(
    criteria,
    levels: levels
  )
]


#rubric(
  criteria,
  levels: levels2
)

#rubric(
  (
    "Bewertungskriterium",
    "Endpunkt x ...", "Berechnung z ...", "Grafik y ...", "Gesamteindruck ..."
  ),
  levels: levels,
  level-hints: none
)
