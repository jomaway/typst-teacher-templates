#import "@preview/ttt-exam:0.1.0": *

#set text(size: 12pt, font: ("Rubik"), weight: 300, lang: "de")

#let logo = box(height: 3cm,image("logo.jpg") )
#show: exam.with(..toml("meta.toml").exam, logo: logo, header: "page", point-field: "table");

= Part 1: Free text questions

#assignment[
  Answer the following questions.
  
  #question(points: 1)[
    Solve the following equation for $x$:
    
    $ 3x+5=17 $]

    #answer(field: caro(6))[
      $ 3x+5=17 $
      $ 3x=17-53x=17-5 $
      $ 3x=123x=12 $
      $ x=123x=312 $
      $ x=4x=4 $
    ]
  ]

  #question(points: 22)[
    Write what comes to your mind.
    #answer-field(lines(6))
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

// show point-table or point-sum-box
// uncomment if you need it.
// = Points
// #point-table  
// #h(1fr)
// #point-sum-box 
