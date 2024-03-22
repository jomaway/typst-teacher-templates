/// Helper and utility functions

// Lines
#let lines(count) = {
    for _ in range(count) {
        block(above: 0.9cm, line(length:100%, stroke: 0.3pt + black.lighten(20%)) )
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

/// Checkbox
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
    context {
      let size = measure(value)
      box(
        width: size.width + 6pt,
        inset: (x: 3pt, y: 0pt),
        outset: (y: 3pt),
        radius: 2pt,
        fill: fill
      )[#value]
    }
  }
}


#let frame(body, ..args) = box(radius: 3pt, stroke: 0.5pt, inset: 1em, ..args, body)

