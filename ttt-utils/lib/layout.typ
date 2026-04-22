#import "components.typ": point-tag, checkbox

/// display some content side-by-side
///
/// - columns (none, auto, integer): Set the amount of columns
/// - gutter (length): grid gutter
/// - ..cols (content): content to show
/// -> content
#let side-by-side(columns: auto, gutter: 1em, ..cols) = {

  let cols = cols.pos()
  let columns = if columns == auto { (1fr,) * cols.len() } else { columns }

  assert(
    columns.len() == cols.len(),
    message: "number of columns must match number of cols"
  )

  grid(columns: columns, gutter: gutter, ..cols)

}

#let point-grid(points, body) = {
  if points != none {
    grid(
      columns: (1fr, auto),
      column-gutter: 0.5em,
      body,
      align(top, point-tag(points))
    )
  } else {
    block(body)
  }
}

#let place-point-tag(points) = {
  if points != none {
    place(top + end, point-tag(points))
  }
}

#let pt(points) = [
  #points #text(0.8em,smallcaps[#if points==1 [PT$\u{0020}$] else [PTs]])
]



#let block-question-renderer(
  prompt,
  answer,
  points: none,
  border: (top: 1pt, left: 1pt, rest: 3pt)
) = {
  // let border =  (top: 1pt, left: 1pt, rest: 3pt)

  block(
    stroke: border,
    inset: if border != none { 1em } else { 0pt },
    clip: true)[
    #grid(
      columns: if points != none {(1fr, auto)} else {1fr},
      column-gutter: 0.5em,
      block( prompt),
      if points != none {
        move(dx: 1em, dy: -1em, box(fill: gray, stroke: black, inset: 0.5em)[#pt(points)])
      }
    )
    #if answer != none {
      block(
        width: 100%,
        answer,
      )
    }
  ]
}


#let default-question-renderer(
  prompt, answer, points: none
) = {
  let body = [
    #prompt

    #answer
  ]

  block(width: 100%)[
    #place-point-tag(points)
    #body
  ]

}
