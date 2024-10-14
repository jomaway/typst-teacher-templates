#import "@preview/ttt-utils:0.1.2": assignments, components, grading, helpers
#import "i18n.typ": ling

#import components: *
#import assignments: *
#import grading: *

#import "points.typ": *
#import "headers.typ": *

#let get-from-input(key, default: none) = {
  sys.inputs.at(key,default: default)
}

#let date-input(default: "") = {
   let value = sys.inputs.at("date", default: none)
   if value != none {
    let decoded-data = toml.decode("date="+value)
    return decoded-data.at("date")
   }
   return default
}

#let last-page-number = counter("last-page-number")

#let _appendix(body, title: auto, ..args) = [
  #set page(footer: auto, header:none, numbering: ("[A]"), ..args.named())
  #metadata((appendix: true)) <appendix>
  #counter(page).update(1)
  #if-auto-then(title, heading(ling("appendix")))

  #body
]
// The exam function defines how your document looks.
#let exam(
  // metadata
  logo: none,
  title: "exam", // shoes the title of the exam -> 1. Schulaufgabe | Stegreifaufgabe | Kurzarbeit
  subtitle: none,
  date: none,     // date of the exam
  class: "",
  subject: "" ,
  authors: "",
  // config
  solution: auto, // auto | false | true
  cover: false, // false | true
  header: auto, // auto | false | true
  eval-table: true,
  appendix: none,
  footer-msg: auto,
  body
) = {
  // Set the document's basic properties.
  set document(author: authors, title: "exam-"+subject+"-"+class)
  // set page properties
  set page(
    margin: (left: 20mm, right: 20mm, top: 20mm, bottom: 20mm),
    footer: {
      // Copyright symbol
      sym.copyright;
      // YEAR
      if type(date) == datetime { date.display("[year]") } else { datetime.today().display("[year]") }
      // Authors
      if (type(authors) == array) [
        #authors.join(", ", last: " and ")
      ] else [
        #authors
      ]
      h(1fr)
      // Footer message: Default Good luck
      if footer-msg == auto {
        text(10pt, weight: "semibold")[
            #ling("good_luck")  #box(height: 1em, image("assets/four-leaf-clover.svg"))
        ]
      } else {
        footer-msg
      }

      h(1fr)
      // Page Counter
      context [#counter(page).display("1") /  #last-page-number.final().at(0)]
      // todo: rethink page number implementation. Want to include/exclude appendix?
      // context last-page-number.final()
    },
    header: context if (counter(page).get().first() > 1) { box(stroke: ( 0.5pt), width: 100%, inset: 6pt)[ Name: ] },
  )

  // check cli input for solution
  if solution == auto {
    set-solution-mode(helpers.bool-input("solution"))
  } else {
    set-solution-mode(solution)
  }

  // check cli input for meta

  let cover-page = header-page(
    logo: logo,
    title,
    subtitle: subtitle,
    class,
    subject,
    date,
    point-field: point-sum-box
  )

  let header-block = header-block(
    title,
    subtitle: subtitle,
    class,
    subject,
    date,
    logo: logo
  )

  // Include Header-Block
  if (cover) {
    cover-page
  } else if (header != false) {
    header-block
  }

  // Content-Body
  body

  if not cover and eval-table {

    align(bottom + end,block[
      #set align(start)
      *#ling("points"):* \
      #point-sum-box
    ])
  }

  context last-page-number.update(counter(page).get())

  if appendix != none {
    _appendix(appendix)
  }

}
