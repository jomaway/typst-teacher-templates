#import "../lib/assignments.typ": *
#import "../lib/components.typ": *

#set page(margin: 2cm)
#set text(size: 12pt, font: "Rubik", weight: 300, lang: "de")


#let q(num) = [
  #numbering("1.", num)
  #lorem(22)
]

#let a1 = caro(8)[
  *Answer:*

]

#let a2 = caro(8)[
  *Answer:*

  #set text(red)
  #lorem(54)
]

#block-question-renderer(
  q(1), a1, points: 5
)

#block-question-renderer(
  q(2), a2
)

#block-question-renderer(
  q(2), caro(24)[], points:12
)

#default-question-renderer(
  q(3), a1, points:5,
)

#set block(breakable: false)
#default-question-renderer(
  q(4), caro(24)[]
)
