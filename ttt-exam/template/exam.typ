#import "@local/ttt-exam:0.1.0": *

#set text(size: 12pt, font: ("Rubik"), weight: 300, lang: "de")

#let logo = box(height: 2cm, image("logo.jpg", fit: "contain")) 
#let details = toml("details.toml")
#show: exam.with(..details.exam, title: logo_title(logo, details.exam.title));

= Part 1: Free text questions

#assignment[
  Answer the following questions.
  
  #question(points: 1)[
    Solve the following equation for $x$:
    
    $ 3x+5=17 $]

    #solution(alt: caro(6))[
      $ 3x+5=17 $
      $ 3x=17-53x=17-5 $
      $ 3x=123x=12 $
      $ x=123x=312 $
      $ x=4x=4 $
    ]
  ]


= Part 2: Multiple and single choice

#multiple-choice((
  prompt: "Which numbers are even",
  distractors: (
    "1", "3", "5"
  ),
  answer: (
    "2", "4",
  )
))

= Punkteverteilung
// show point-table or point-sum-box
#point-table  
#h(1fr)
#point-sum-box 
