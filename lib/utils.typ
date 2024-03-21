/* Helpers */
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

/// utility function to stick header and following block together
#let stick-together(a, b, threshold: 3em) = {
  block(a + v(threshold), breakable: false)
  v(-1 * threshold)
  b
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

#let if-auto-then(val, ret) = {
  if (val == auto) {
    ret
  } else {
    val
  }
}


#let frame(body, ..args) = box(radius: 3pt, stroke: 0.5pt, inset: 1em, ..args, body)

// #let push_and_return(a_list, value) = {
//   a_list.push(value)
//   return a_list
// }

// #let increase_last(a_list, value) = {
//   a_list.last() += value
//   return a_list
// }