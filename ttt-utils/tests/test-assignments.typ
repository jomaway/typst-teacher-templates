#import "../lib/assignments.typ": *
#import "../lib/components.typ": *
#set page(margin: 2cm)
#set text(size: 12pt, font: "Rubik", weight: 300, lang: "de")

= Test assignments

#scenario[
  This is a scenario.

  #question(points: 5)[
    This is an question with points.

    #caro(5)[
      *Answer:*
    ]
  ]

  This is some text in between.

  #question(points: 3)[
    Yeah, lets have some more questions.

    #lines(3)[
      *Answer:*
    ]
  ]

  #question[
    Choose the right one.

    #options(
      cols: 4,
      "A",
      "B",
      correct("C"),
      "D",
    )

    #hint[Choose wisely]
  ]
]

== Part 2
Some more questions

#question(points:3)[
  This is some question outside of an scenario.

  #caro(3)[]
]

#question()[
  This is some question outside of an scenario.

  #quick-options[
    - Option 1
    - Option 2
    + Option 3
    - Option 4
  ]
]


#pagebreak()
== Part 3

#scenario(collect-points: true)[
  This is a scenario.

  #question(points: 5)[
    This is an question with points.

    #caro(5)[
      *Answer:*
    ]
  ]

  This is some text in between.

  #question(points: 3)[
    This ...

    #lines(2)[
      #answer(hide:true)[
        #lorem(30)
      ]
    ]
  ]

  #question[
    Choose the right one.

    #options(
      cols: 4,
      "A",
      "B",
      correct("C"),
      "D",
    )

    #hint[Choose wisely]
  ]
]


#question(points: 3)[
  This is some question outside of an scenario. aklsjf ala alsdjd alalal dja sjs sjd jdiewp eüfg möäm pw erti üj l rip
  #lorem(23)

  #caro(7)[]
]
