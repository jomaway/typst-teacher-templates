// WIP - coming soon!
#import "../lib/lib.typ": assignments, components, grading
#import "@preview/tidy:0.4.2"

// extract version from typst.toml package file.
#let pkg-data = toml("../typst.toml").package
#let version = pkg-data.at("version")
#let import_statement(modules: "*") = raw(block: true, lang: "typ", "#import \"@preview/ttt-utils:" + version +"\": " + str(modules))

#let pkg-info = (
  author: link("<https://github.com/jomaway>", "jomaway"),
  repo: link(pkg-data.at("repository")),
  version: version
)
// global page settings
#set page(
  margin: 2cm,
  header: align(start,text(font:"Noto Sans Mono")[Docs for #link("https://typst.app/universe/package/ttt-utils",[ttt-utils:#version])]),
  footer: [Author: #link("https://github.com/jomaway","jomaway"), License: MIT #h(1fr) #context {counter(page).display("1/1", both: true)}]
);
#set text(font: "Rubik", weight: 300, lang: "en")
#set heading(
  numbering: (..numbers) =>
    if numbers.pos().len() >= 2 and numbers.pos().len() <= 3 {
      return numbering("1.", ..numbers.pos().slice(1))
    }
)
#show link: set text(blue)


#set align(center)
#v(3cm)
#text(24pt, weight: 500)[ttt-utils]

#block(inset: 1em)[
  #emph[An utility package for teachers.]
]
`ttt-utils` is a package for the typst ecosystem \
by #pkg-info.at("author").

#block(inset: 1em)[
  *Version:* #version
]

#v(3cm)
#outline(depth: 2)

#set align(start)
#pagebreak()
= Getting started

`ttt-utils` is a utility package for teachers.

It consists of multiple modules that can be used to create assignments, worksheets, and other educational materials.

== Usage

To use the `ttt-utils` package in your typst document, you need to import it first. \
Here is an example of how to import the package:

#import_statement()

This includes the `assignments`, `components`, and `grading` modules.

If you only need to use a specific module, you can import it like this:

#import_statement(modules: "<MODULE-NAME>")

=== Assignment module

The `assignments` module provides functions and definitions for creating assignments, questions, and solutions.
To use the functions and definitions from the imported module without prefixing them with the module name, you can import them with the wildcard `*` like this:

#import_statement(modules: "assignments")
```typ
#import assignments: *
```

#box(stroke: 0.5pt + blue, radius: 3pt, inset:1em, width: 100%)[
  #assignments.assignment[
    Create your first assignment here.

    #assignments.question[How to do that?]
    #assignments.question(points:2)[Do i get points?]
    #assignments.question(points: 3)[What is the answer?]
  ]

  #assignments.question(points: 1)[What's the difference between an assignment and a question?]
]
#pagebreak()
= API - References


// tidy docs for assignments
#let docs-assign = tidy.parse-module(
  read("../lib/assignments.typ"),
  name: "Assignments",
  scope: (assignments: assignments),
  preamble: "#import assignments: *;",
  label-prefix: "assign"
)


// tidy docs for assignments
#let docs-components = tidy.parse-module(
  read("../lib/components.typ"),
  name: "Components",
  scope: (components: components),
  preamble: "#import components: *;",
  label-prefix: "assign"
)

#let my-show-example = tidy.show-example.show-example.with(
  layout: (code, preview) => [
    #set text(0.8em)
    Example:
    #grid(
      columns: (1fr,1fr),
      gutter: 1em,
      box(width: 100%, stroke: 0.5pt + gray, fill: luma(240), inset: 1em, radius: 3pt, code),
      box(width: 100%, stroke: 0.5pt + blue, inset:1em, radius: 3pt, preview)
    )
  ]
)

#let custom-style = dictionary(tidy.styles.default) + (show-example: my-show-example)

#tidy.show-module(
  docs-components,
  style: custom-style,
  omit-private-definitions: true,
)

#pagebreak()



#tidy.show-module(
  docs-assign,
  style: custom-style,
  sort-functions: none,
  omit-private-definitions: true,
)
