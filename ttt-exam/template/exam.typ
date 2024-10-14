#import "@preview/ttt-exam:0.1.3": *

#set text(size: 12pt, font: ("Rubik"), weight: 300, lang: "de")
#set par(spacing: 1.2em)


#show: exam.with(
  class: get-from-input("class"),
  subject: get-from-input("subject"),
  date :  date-input(),
  authors : get-from-input("authors"),
  logo: box(height: 2cm,image(get-from-input("logo",default: "logo.jpg"))),
  title : get-from-input("title",default: "Exam"),
  subtitle : get-from-input("subtitle"),
  cover: true, // true or false
  eval-table: false,  // true or false
  appendix: none, // content or none
)

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


#multiple-choice(
  prompt: "Which number is a prime number",
  distractors: (
    "1", "6", "15", "9",
  ),
  answer: (
    "7",
  ),
  dir: ltr,
)
