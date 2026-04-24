#import "../lib/assignments.typ": *
#import "../lib/components.typ": *
#import "../lib/grading.typ": *

#set page(margin: 2cm)
#set text(size: 12pt, font: "Rubik", weight: 300, lang: "de")

= Test scenarios

== Scenario 1

#scenario[
  This is the first scenario.

  #question(points: 2)[
    This is a question with points.

    #caro(3)[
      This is a caro.
    ]
  ]

  #question(points: 3)[
    This is a question with points.
  ]
]

== Scenario 2

#scenario(collect-points: true)[
  This is the second scenario.

  #question(points: 2)[
    This is a question with points.

    #caro(3)[
      This is a caro.
    ]
  ]

  #question(points: 3)[
    This is a question with points.
  ]
]


#scenario(
  disable-numbering: true,
)[
  == Scenario #context scenario-number()
  #lorem(22)

  #question(points:128)[
    Whoosa. Cheating
  ]
]
