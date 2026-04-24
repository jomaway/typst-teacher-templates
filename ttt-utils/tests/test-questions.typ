#import "../lib/assignments.typ": *
#import "../lib/components.typ": *
#import "../lib/grading.typ": *

#set page(margin: 2cm)
#set text(size: 12pt, font: "Rubik", weight: 300, lang: "de")

= Test questions


#question(points: 2)[
  This is a question with points.

  #caro(3)[
    This is a caro.
  ]
]

#question[
  This is a question *without* points.

  #caro(3)[
    This is a caro.
  ]
]


#question(points: 2)[
  This is a question *without* a number.

  #caro(3)[
    This is a caro.
  ]
]

#question[
  This is a question with options.

  #options(
    cols: 4,
    shuffle: true,
    correct("Option 1"),
    "Option 2",
    "Option 3",
    (correct: true, body: "Option 4")
  )
  // #context current-options()
]

#question(points: 2)[
  This is a question with a custom number style.

  #lines(3)[
    This is a line.
  ]
]

#question(points: 1)[
  This is a question with a long text. #lorem(22)

  #lines(3)[
    - On the line.
    - Test two
    - Line three.
    - And so on
  ]

  #caro(12)[]
]

#context get-questions()
