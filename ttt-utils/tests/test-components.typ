#import "../lib/components.typ": *
#import "../lib/assignments.typ": *
= Test components

#option[xx]

#options[
  cols: 4,
  "A",
  "B",
  correct("C"),
  "D",
]

== Checkerd Notebook style (aka caro)

#caro(4)[$f(x) = frac(x³-2x²+x-5,x-1)$]

#caro(4, cols: 10)[$f(x) = frac(x³-2x²+x-5,x-1)$]

=== diret use of pattern
#box(
  width: 4.7cm,
  height: 2.3cm,
  inset: 0.6cm,
  fill: caro-pattern(),
)[
  Done
]
