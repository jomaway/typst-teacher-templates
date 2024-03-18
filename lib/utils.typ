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
    let cols = if( cols == auto ){ int(size.width.cm() / 0.5) } else { cols }
    table(
      columns: (0.5cm,) * cols, 
      rows: (0.5cm,) * rows,
      stroke: 0.3pt + luma(140),
      table.cell(y: rows - 1)[],
    )
  })
}

#let checkbox(fill: none, tick: false) = box(
  width: 0.8em, 
  height: 0.8em, 
  stroke: 0.7pt, 
  radius: 1pt, 
  fill: fill,
  if (tick) { align(horizon + center, sym.checkmark) }
)


// Tag 
#let tag(value, fill: orange.lighten(45%)) = {
  if value != none {
    box(
      inset: (x: 3pt, y: 0pt),
      outset: (y: 3pt),
      radius: 2pt,
      fill: fill
    )[#value]
  }
}

// side-by-side
#let side-by-side(columns: none, gutter: 1em, ..cols) = {
  
  let cols = cols.pos()
  let columns = if columns ==  none { (1fr,) * cols.len() } else { columns }

  assert(
    columns.len() == cols.len(),
    message: "number of columns must match number of cols"
  )
  
  grid(columns: columns, gutter: gutter, ..cols)
  
}

// CC image
// #let cc_by-sa-nc = box(height: 1em, image("assets/by-nc-sa.eu.svg"))

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
