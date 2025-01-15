#import "@preview/ttt-exam:0.1.3": *

#set text(size: 12pt, font: ("Rubik"), weight: 300, lang: "de")
#if sys.version.at(1) >= 12 {
  set par(spacing: 1.2em)
}

#show: exam.with(
  authors : "Authors",
  logo: box(height: 2cm, image(get-from-input("logo", default: "logo.jpg"))),

  cover: true, // true or false
  eval-table: false,  // true or false
)

= Part 1: Free text questions

#assignment[

  #question(points: 1)[

    #answer(field: caro(6))[
      
    ]
  ]
]


= Part 2: Multiple and single choice

#multiple-choice(
  prompt: "Which numbers are even",
  distractors: (
    "1", "3", "5"
  ),
  answer: (
    "2", "4",
  ),
  dir: ltr,
  hint: [_Two options are correct_]
)
