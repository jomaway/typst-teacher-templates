#import "../lib/utils.typ": tag
#import "@preview/chic-hdr:0.4.0": *
#import "@preview/gentle-clues:0.7.0": *


#let worksheet(topic: "", subject: "",  authors: "unknown", version: none, columns: 1, body) = {
  // Set the document's basic properties.
  set document(author: authors, title: topic)
  set page(margin: (left: 20mm, right: 20mm, top: 15mm, bottom: 20mm))
  authors = if (type(authors) == array) [
    #authors.join(", ", last: " and ")
  ] else [
    #authors
  ]

  version = if version != none [
    v#version
  ] else [
    last changed: #datetime.today().display("[year]-[month]-[day]")
  ]

  set text(12pt, font: "Rubik", weight: 300, lang: "de")
  // Header settings
  show: chic.with(
    chic-header(
      side-width: (auto, 1fr, auto),
      left-side: [#tag(subject) - #emph(chic-heading-name(fill: true))],
      right-side: smallcaps(topic)
    ),
    chic-footer(
      left-side: [ #sym.copyright; #datetime.today().display("[year]") #authors - #version],
      right-side: counter(page).display("1 / 1", both: true)
    ),
    chic-separator(1pt),
    chic-offset(7pt),
    chic-height(1.5cm)
  )

  // Show rules
  show: gentle-clues.with(lang: "de",show-task-counter: true)
  show heading.where(level: 1): set block(below: 1.1em);
  show heading.where(level: 1): set text(weight: 500);
  show link: set text(blue);
  show raw.where(block: false): it => tag(fill: luma(230))[#it]

  // Settings
  // Set text size, font and lang 
  set text(12pt, font: "Rubik", weight: 300, lang: "de")
  // Set spacing between lines and Blocksatz.
  set par(leading: 1em, justify: true)
  // Set header numbering only on the level 1 and 2.
  set heading(numbering: (..args) => {
    let nums = args.pos()
    if nums.len() < 3 {numbering("1.", ..nums)}
  })
  
  // Content-Body
  body
}


#let title(title) = [
  #align(center)[
    #text(1.6em, weight: 500, title)
  ]
]

