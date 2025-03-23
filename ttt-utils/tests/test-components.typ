#import "../lib/components.typ": *

= Test components

== Checkerd Notebook style (aka caro)

=== table implementation
#caro(4)

#caro(4, cols: 10)

=== tiling implementation
#caro-box(4)[$f(x) = frac(x³-2x²+x-5,x-1)$]

#caro-box(4, cols: 10)[$f(x) = frac(x³-2x²+x-5,x-1)$]

=== diret use of pattern
#box(
  width: 4.7cm,
  height: 2.3cm,
  inset: 0.6cm,
  fill: caro-pattern(),
)[
  Done
]
