// WIP - coming soon!
#import "../lib/lib.typ": assignments, components, grading
#import "@preview/tidy:0.4.2"
#import "@preview/gentle-clues:1.2.0": info, code as code-block, example

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

#let example-layout(code, preview) = [
  #set text(0.8em)
  #grid(
    columns: (1fr,1fr),
    gutter: 1em,
    code-block(code),
    example(title: "Result", preview)
  )
]

#show: tidy.show-example.render-examples.with(
  scope: (assignments: assignments, components: components, grading: grading),
  layout: example-layout,
)

// ---------------------------------------------
// Document starts here
// ---------------------------------------------

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

#info[
  All following examples are using the `assignments` module. Make sure to import it!
  #import_statement(modules: "assignments")
]

The `assignments` module provides functions and definitions for creating assignments, questions, and solutions.
Here is an example of how to create an assignment with questions:

```example
#assignments.question(points: 1)[What's the difference between an assignment and a question?]

#assignments.assignment[
  Assignments are collections of questions, while questions are individual tasks or problems.

  #assignments.question[How to do that?]
  #assignments.question(points:2)[Do i get points?]
]

```

To use the functions and definitions from the imported module without prefixing them with the module name, you can import them with the wildcard `*`.
Then you can use the functions and definitions directly in your document, like shown in the examples below.

```example
#import assignments: *
#assignment[
  Create your first assignment here.

  #question[How to do that?]
  #question(points:2)[Do i get points?]
]
```

If those names interfere with other names in your document, you can use the `as` keyword to rename the imported module.

```example
#import assignments: assignment as assign, question as q, answer as a
#assign[
  With this approach you don't need to type that much as well.

  #q[What do you think about this?]
  #a[I think it's great!]
]
```

As you can see the `answer` is not shown in the output. This is because the `answer` is only shown if the `solution` flag is set to `true`.
You can do this with `#set-solution-mode(true)` or use `#with-solution` directive.

```example
#import assignments: *

#set-solution-mode(true)
#answer[This answer is visible.]

#set-solution-mode(false)
#answer[This answer is not visible.]

#with-solution(true)[
  #answer[This answer is visible as well.]
]
```

Often you want to display a field for the student to write their answer. You can do this with the `#answer-field` directive. Or setting the `field` argument in the `#answer` directive.

```example
>>> #import components: *
#import assignments: *

#set-solution-mode(true)
_Only the answer will be visible._

#answer(field: caro(2))[Correct answer!]
#answer-field[_You can't see me!_]

#set-solution-mode(false)
_Only the field will be visible._

#answer(field:caro(2))[Not visible.]
#answer-field[#checkbox() Check me!]
```

There is also a handy function to create single or multiple choice questions. You can use the `#choice` directive for this.
By default, the choices are displayed in a random order and for each correct answer 1 point is assigned to the question.

```example
#import assignments: choice
#choice(
  prompt: [What is the result of $1+1$?],
  distractors: (1, 3, 4),
  answers: 2,
  hint: "The result is even.",
  dir: ltr
)
```

The numbering scheme for questions is automatically generated. But can be changed with the `number` parameter.

```example
>>> #import assignments: *
#assignment(number: none)[
    This is the assignment
    #question(number: "I.")[This is the question.]
]
```

If for some reason you want to reset the question counter, you can use the `reset-question-counter()` function.

```example
>>> #import assignments: *
#question[This is some question.]
#reset-question-counter()
#question[This is question 1 again.]
```

=== Components module

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
