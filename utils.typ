/* Helpers */
// Lines
#let lines(count) = {
    for _ in range(count) {
        block(spacing: 1.6em, line(length:100%, stroke: black.lighten(20%)) )
    }
}

// Field 
#let field(label, width: 3.5cm, value: none) = {
  box(
    stroke: (bottom: 0.5pt), 
    width: width, 
    height: 0.8cm,
    inset: (bottom: 3pt)
  )[
    #align(bottom + center,value)
    #place(bottom + end,dy: 12pt)[#text(10pt, label)]
  ] 
}

// Caro
#let caro(rows, cols:auto) = {
  layout(size => {

    table(
      columns: range(if( cols==auto ){ int(size.width.cm() / 0.5) } else { cols }).map(_ => 0.5cm),
      rows:range(rows).map(_ => 0.5cm),
      stroke: 0.3pt + luma(140)
    )
  })
}

#let checkbox(fill: none) = box(width: 0.8em, height: 0.8em, stroke: 1pt + black, fill: fill)[]


// Tag 
#let tag(value, fill: orange.lighten(35%)) = {
  box(
    inset: 4pt,
    radius: 0.2em,
    height: 1.1em,
    fill: fill
  )[
    #align(center + horizon)[
      #value
    ]
  ]
}

// Intro block
#let intro-block(content, tools) = {
  block(
    fill: rgb( 214, 234, 248 ), 
    inset: 0.6em, 
    width: 100%,
    radius: 0.3em
  )[
    #set text(0.9em)
    #set par(leading: 1em)
    #content \
    *Hilfsmittel:* #if tools == none [keine] else [#tools]
  ]
}

#let cc_by-sa-nc = box(height: 1em, image("assets/by-nc-sa.eu.svg"))