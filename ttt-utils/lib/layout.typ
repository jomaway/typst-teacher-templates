#import "components.typ": tag, checkbox

// ------------
//  States
// ------------
#let _render_style = state("ttt-render-style", "classic")

#let set-render-style(style) = {
  assert(
    style == "classic" or style == "block",
    message: "invalid render style: " + style
  )
  _render_style.update(style)
}

#let pt(points) = [
  #points #text(0.8em,smallcaps[#if points==1 [PT$\u{0020}$] else [PTs]])
]


#let render-point-tag(points) = {
  let style = _render_style.get()
  if style == "classic" {
    tag(fill: gray.lighten(35%), pt(points))
  } else if style == "block" {
    box(fill: gray.lighten(35%), stroke: black, inset: 0.5em, pt(points))
  } else {
    panic("unknown tag render style: " + style)
  }
}


#let block-question-renderer(
  body,
  points: none,
  border: (top: 1pt, left: 1pt, rest: 3pt)
) = {
  block(
    stroke: border,
    inset: if border != none { 1em } else { 0pt },
    clip: true
  )[
    #import "@preview/meander:0.4.2"

    #meander.reflow({
      import meander: *

      if points != none {
        placed(
          top + right,
          move(dx: 1em, dy: -1em, render-point-tag(points))
        )
      }

      container()
      content[
        #body
      ]
    })
  ]
}


#let default-question-renderer(
  body, points: none
) = {
  import "@preview/meander:0.4.2"

  meander.reflow({
    import meander: *
    if points != none {
      placed(
        top + right,
        render-point-tag(points)
      )
    }

    container()
    content[
      #body
    ]
  })
}



#let render(body, points: none) = context {
  let style = _render_style.get()
  if style == "classic" {
    default-question-renderer(body, points: points)
  } else if style == "block" {
    block-question-renderer(body, points: points)
  } else {
    panic("unknown render style: " + style)
  }
}

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
