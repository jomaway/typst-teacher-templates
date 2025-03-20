#import "components.typ": point-tag, checkbox, caro, lines as _lines
#import "helpers.typ": if-auto-then
#import "random.typ": shuffle

// States
#let _solution = state("ttt-solution", false);
#let _answer_field = state("ttt-auto-field", none)

/// wrapper for updating the `_answer_field` state
///
/// -> content (state-update)
#let set-default-answer-field(
  /// Content to be shown if @answer field parameter is `auto`
  /// -> content
  field
) = _answer_field.update(field)

// Counters
#let _question_counter = counter("ttt-question-counter");

/// Wrapper to reset the `_question_counter` back to zero
#let reset-question-counter() = { _question_counter.update(0) }

// Labels
#let _question_label = label("ttt-question-label")

// -----------------
// Solution methods
// -----------------

// Wrapper to set solution-mode to true
#let show-solutions = { _solution.update(true) }
// Wrapper to set solution-mode to false
#let hide-solutions = { _solution.update(false) }

// Wrapper to get the current value of the _solution state
// ! needs context
// -> bool
#let is-solution-mode() = {
  _solution.get()
}

/// Sets the solution to a defined state.
///
/// -> content
#let set-solution-mode(
  /// the solution state
  /// -> bool
  value
) = {
  assert.eq(type(value), bool, message: "expected bool, found " + str(type(value)))
  _solution.update(value)
}

/// Sets whether solutions are shown for a particular part of the document.
///
/// -> content
#let with-solution(
  /// the solution state to apply for the body
  /// -> bool
  solution,
  /// - body (content): the content to show
  /// -> content
  body
) = context {
  assert.eq(type(solution), bool, message: "expected bool, found " + str(type(solution)))
  let orig-solution = _solution.get()
  _solution.update(solution)
  body
  _solution.update(orig-solution)
}


/// Add the current assignment number
///
/// -> content
#let a-nr(
  /// style of the number gets passed to typst `numbering` function. default: "1."
  /// -> string
  style: "1."
) = context numbering(style, _question_counter.get().first())

/// Add the current question number
///
/// -> content
#let q-nr(
  /// style of the number gets passed to typst `numbering` function. default: "a)"
  /// -> string
  style: "a)"
) = context numbering(style, _question_counter.get().last())



// the assignment environment state
// should contain `none` or an `integer` with the current assignment number
#let _assignment_env = state("ttt-assignment-state", none)

// Starts a new assignment environment.
// All following questions will be grouped into this assignment until a `end-assignment` statement occurs.
#let new-assignment = {
  _question_counter.step(level: 1)
  context _assignment_env.update(_question_counter.get().first())
}

// Ends the assignment environment.
// All following questions will be treated as stand alone questions.
#let end-assignment = _assignment_env.update(none)

// Wrapper to check if the assignment environment is active.
#let is-assignment() = {
  _assignment_env.get() != none
}

/// Add an assignment environment.
/// By default this adds the current assignment number up front.
///
/// ```example
/// #assignment[
///   Answer the following questions.
/// ]
///
/// #assignment[
///   Answer the following questions.
///   #question[What is the result of $1+1$?]
/// ]
/// ```
///
/// -> content
#let assignment(
  /// the content to be displayed for this assignment
  /// -> content
  body,
  /// if none no number will be displayed otherwise the string gets passed to typst `numbering` function.
  /// -> string | none
  number: "1.",
  /// if true the assignment can be broken over multiple pages
  /// -> bool
  breakable: true
) = {
  set block(breakable: breakable)
  new-assignment

  if (number != none and number != "hide") { a-nr(style: number) }
  body

  end-assignment
}

// Add a question and some metadata to your document.
//
// This function will just render the given body and store the points as metadata inside the document.
// You mostly want to use the higher level `question` function.
//
// -> content
#let _question(
  // the content to be displayed for this assignment
  // -> content
  body,
  // the given points for a correct answer of this question. Will be stored as metadata.
  // -> int
  points: none
) = {
  if points != none {
    assert.eq(type(points), int, message: "expected points argument to be an integer, found " + str(type(points)))
  }
  context {
    let level = if is-assignment() { 2 } else { 1 }
    _question_counter.step(level: level)
    // note: metadata must be a new context to fetch the updated _question_counter value correct
    context [#metadata((type: "ttt-question", num: _question_counter.get() ,points: points, level: level)) #_question_label]
  }
  body
}

/// Add a question with number and point-tag to your document.
///
/// This function adds the current question number up front and a `point-tag` on the right side.
/// If you just want the plain question to render use the low level `_question` function.
///
/// ```example
/// #question(points: 2)[
///   What is the result of $1 + 1$ ?
/// ]
///
/// #assignment[
///   Assignment with questions.
///   #question(points: 2)[
///     What is the result of $1 + 1$ ?
///   ]
/// ]
/// ```
///
/// -> content
#let question(
  /// the content to be displayed for this assignment
  /// -> content
  body,
  /// the given points for a correct answer of this question. Will be stored as metadata.
  /// -> int | none
  points: none,
  /// if none no number will be displayed otherwise the string gets passed to typst `numbering` function.
  /// -> string | none | auto
  number: auto,
  /// if true the question can be broken over multiple pages
  /// -> bool
  breakable: true
) = {
  set block(breakable: breakable)
  grid(
    columns: if points == none {1} else {(1fr, auto)},
    column-gutter: 0.5em,
    _question(points: points)[
      #context q-nr(style: if-auto-then(number, { if is-assignment() { "a)" } else { "1." }  }))
      #body
    ],
    if points != none {
      align(top, point-tag(points))
    }
  )
}

/// A single/multiple choice question. \
/// The checkbox of an answer will be filled red and ticked if solution-mode is set to true.
///
/// ```example
/// #choice(
///   prompt: [What is the result of $1+1$?],
///   distractors: (1, 3, 4),
///   answers: 2,
///   hint: "The result is even.",
///   dir: ltr
/// )
/// ```
#let choice(
  /// the question prompt
  /// -> content
  prompt: none,
  /// all wrong choices
  /// -> array
  distractors: (),
  /// one or multiple correct choices.
  /// -> array
  answers: (),
  /// some hint for the question
  /// -> none | content
  hint: none,
  /// the amount of points for this question. \
  /// - if auto the amount of correct answers will be used. \
  /// - if none no points will be given.
  /// - otherwise the given number will be used.
  /// -> int | auto | none
  points: auto,
  /// direction of the options. Get's passed to typst `stack` function.
  dir: ttb,
) = {
  let answers = if (type(answers) == array ) { answers } else { (answers,) }
  answers = answers.map(entry => [#entry])
  distractors = distractors.map(entry => [#entry])

  block(breakable: false,
    question(points: if-auto-then(points, answers.len()))[
      #prompt
      #let choices = (..distractors, ..answers)

      #let choices = shuffle(choices).map(choice => {
        box(inset:(x:0.5em))[
          #context {
            let is-solution = is-solution-mode() and choice in answers
            checkbox(fill: if is-solution { red }, tick: is-solution )
          }
        ]; choice
      })

      #stack(dir:dir, spacing: 1em, ..choices)


      // show hint if available.
      #if (hint != none) {
        strong(delta: -100)[Hint: #hint]
      }
    ]
  )
}


/// An answer field which is only shown if solution-mode is false.
///
/// ```example
/// *With solution mode off:*
///
/// #assignment[
///   What is the result of $1+1$?
///
///   #answer-field(box(stroke: 1pt+ blue, width: 2cm, height: 1cm)[])
/// ]
///
/// *With solution mode on:*
/// #set-solution-mode(true)
///
/// #assignment[
///   What is the result of $1+1$?
///
///   #answer-field(box(stroke: blue, width: 5cm, height: 5cm)[])
/// ]
/// >>> #set-solution-mode(false)
/// ```
/// -> content
#let answer-field(
  /// the content to show if solution-mode is off
  /// -> content
  body
) = {
  context {
    if not is-solution-mode() { body }
  }
}


/// An answer to a question which is only shown if solution-mode is true.
///
/// ```example
/// *With solution mode off:*
///
/// #assignment[
///   What is the result of $1+1$?
///
///   #answer[$1+1 = 2$]
/// ]
/// *With solution mode on:*
/// #set-solution-mode(true)
///
/// #assignment[
///   What is the result of $1+1$?
///
///   #answer[$1+1 = 2$]
/// ]
/// >>> #set-solution-mode(false)
/// ```
/// -> content
#let answer(
  /// the content to show if solution-mode is on
  /// -> content
  body,
  /// text color of the answer. default: red
  /// -> color
  color: red,
  /// some content which is shown if solution-mode is off. default: `_answer_field` state value
  /// -> auto | content
  field: auto
) = {
    if field == hide {
      answer-field( hide(body))
    } else {
      answer-field(context if-auto-then(field, _answer_field.get()))
    }
    context {
      if is-solution-mode() {
        set text(fill: color)
        body
      }
    }
}

// ---------
// Queries
// ---------

/// Fetch the metadata of the last defined question
///
/// ```example
/// #context current-question()
/// ```
///
/// -> dictionary
#let current-question() = { query(selector(_question_label).before(here())).last().value }

/// Fetch the metadata of all questions  in the document.
///
/// -> dictionary
#let get-questions(
  /// a filter which is applied before returning
  /// -> function
  filter: none
) = {
  let all-questions = query(_question_label).map(m => m.value)
  if filter != none {
    all-questions.filter(filter)
  } else {
    all-questions
  }
}
