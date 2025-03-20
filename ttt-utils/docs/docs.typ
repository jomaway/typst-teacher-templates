// WIP - coming soon!
#import "../lib/lib.typ": assignments, components, grading
#import "@preview/tidy:0.4.2"

// extract version from typst.toml package file.
#let pkg-data = toml("../typst.toml").package
#let version = pkg-data.at("version")
#let import_statement = raw(block: true, lang: "typ", "#import \"@preview/ttt-utils:" + version +"\": *")

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
= ttt-utils

#block(inset: 1em)[
  #emph[An utility package for teachers.]
]
`ttt-utils` is a package for the typst ecosystem \
by #pkg-info.at("author").

#block(inset: 1em)[
  *Version:* #version
]

#outline(depth: 2)

#pagebreak()
#set align(start)
= References
test

// tidy docs
#let docs-assign = tidy.parse-module(
  read("../lib/assignments.typ"),
  name: "Assignments",
  scope: (assignments: assignments),
  preamble: "#import assignments: *;",
  label-prefix: "assign"
)

#show: tidy.render-examples.with(
  layout: (code,preview) => grid(columns: 1, gutter: 1em, box(inset: 0.5em,code))
)

#tidy.show-module(
  docs-assign,
  style: tidy.styles.default,
  omit-private-definitions: true,
)
