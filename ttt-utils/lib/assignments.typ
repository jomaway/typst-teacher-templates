#import "components.typ": point-tag, checkbox
#import "helpers.typ": if-auto-then
#import "random.typ"
#import "layout.typ": *
// ------------
// Counters
// ------------
#let _question_counter = counter("ttt-question-counter");

/// Wrapper to reset the `_question_counter` back to zero
#let reset-question-counter() = { _question_counter.update(0) }

// ------------
// Labels
// ------------
#let _question-label = label("ttt-question-label")
#let _option-label = label("ttt-option-label")

// ------------
//  States
// ------------
#let _solution = state("ttt-solution", false);
// the assignment environment state
// should contain `none` or an `integer` with the current assignment number
#let _assignment_env = state("ttt-assignment-state", none)

// Starts a new assignment environment.
// All following questions will be grouped into this assignment until a `end-assignment` statement occurs.
#let new-assignment = {
  _question_counter.step(level: 1)
  context _assignment_env.update(
    (
      number: _question_counter.get().first(),
      collect: false
    )
  )
}

// Ends the assignment environment.
// All following questions will be treated as stand alone questions.
#let end-assignment = _assignment_env.update(none)

// Wrapper to check if the assignment environment is active.
#let is-assignment() = {
  _assignment_env.get() != none
}

/// Get the current assignment number.
///
/// -> int | none
#let get-assignment-number() = {
  _assignment_env.get().number
}

#let set-assignment-collect-points(value) = {
  _assignment_env.update(
    (
      number: get-assignment-number(),
      collect: value
    )
  )
}

#let get-assignment-collect-points() = {
  _assignment_env.get().collect
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
#let current-question() = { query(selector(_question-label).before(here())).last().value }

/// Fetch the metadata of the options of the current question
/// ```example
/// #context current-options()
/// ```
/// -> array of dictionaries
#let current-options() = {
  query(selector(_option-label)).filter(meta => {
    meta.value.question-number == _question_counter.get()
  }).map(meta => meta.value)
}

/// Fetch the metadata of all questions  in the document.
///
/// -> dictionary
#let get-questions(
  /// a filter which is applied before returning
  /// -> function
  filter: none
) = {
  let all-questions = query(_question-label).map(m => m.value)
  if filter != none {
    all-questions.filter(filter)
  } else {
    all-questions
  }
}

// -----------------
// Solution methods
// -----------------

/// Wrapper to set solution-mode to true
#let show-solutions = { _solution.update(true) }
/// Wrapper to set solution-mode to false
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
#let _get-a-nr(
  /// style of the number gets passed to typst `numbering` function. default: "1."
  /// -> string
  style: "1."
) = context numbering(style, _question_counter.get().first())

/// Add the current question number
///
/// -> content
#let _get-q-nr(
  /// style of the number gets passed to typst `numbering` function. default: "a)"
  /// -> string
  style: "a)"
) = context numbering(style, _question_counter.get().last())




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
  breakable: true,
  /// collect all points for this assignment and display the summary.
  /// -> bool
  collect-points: false,
) = {
  set block(breakable: breakable)
  new-assignment

  body = {
    if (number != none and number != "hide") {
      _get-a-nr(style: number)
      [ ]
    }
    body
  }

  if collect-points {
    context {
      set-assignment-collect-points(true)
      let points = get-questions(filter: q => q.num.first() == get-assignment-number()).map(q => q.points).sum(default: 0)

      default-question-renderer(body, none, points: points)
    }
  } else {
    default-question-renderer(body, none)
  }

  end-assignment
}

/// Alias
#let scenario = assignment

#let scenario(
  body,
  collect-points: false,
) = {
  new-assignment
  // _question_counter.step(level: 1)

  body = [
    #_get-a-nr() #body
  ]

  block-question-renderer(body, none, border:none)
  end-assignment
}

/// Add a question with number and point-tag to your document.
///
/// This function adds the current question number up front and a `point-tag` on the right side.
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
  /// -> int | none | auto
  points: auto,
  /// if none no number will be displayed otherwise the string gets passed to typst `numbering` function.
  /// -> string | none | auto
  number-style: auto,
  /// if true the question can be broken over multiple pages
  /// -> bool
  breakable: false,
  render: block-question-renderer,
) = {
  // assertions
  if points != none and points != auto {
    assert.eq(type(points), int, message: "expected points argument to be an integer, found " + str(type(points)))
  }


  context {
    let level = if is-assignment() { 2 } else { 1 }
    _question_counter.step(level: level)
  }


  context {
    // reassign points as we can't change values from outside of this context.
    let points = if-auto-then(points, current-options().filter(option => option.correct).len())
    points = if points == 0 { none } else { points }

    // note: metadata must be a new context to fetch the updated _question_counter value correct
    [#metadata((
      type: "ttt-question",
      num: _question_counter.get() ,
      points: points,
      // szenario: none,
    )) #_question-label]

    // reassign number as we can't change values from outside of this context.
    let number = number-style
    if number != none {

    number = if is-assignment() {
      if get-assignment-collect-points() {
        points = none
      }
      _get-q-nr(style: if-auto-then(number, { "a)" }))
    } else {
      _get-q-nr(style: if-auto-then(number, { "1." }))
    }

    }

    // render the question
    set block(breakable: breakable)
    render([#number #body],none, points: points)
  }
}


/// A wrapper for the content of a choice option which adds a checkbox in front of it. The checkbox will be filled red and ticked if solution-mode is set to true and the correct argument is set to true.
///
/// -> content
#let option(
  /// the content of the option
  /// -> content
  body,
  /// if true the checkbox will be filled red and ticked if solution-mode is set to true. default: false
  /// -> bool
  correct: false,
) = {
  context {
    [
      #metadata(
        (
          type: "ttt-answer-option",
          question-number: _question_counter.get(),
          correct:correct,
          // body: body,
        )
      ) #_option-label
    ]

    let is-sol-mode = is-solution-mode()

    grid(
      columns: (auto, 1fr),
      gutter: 0.5em,
      align: (center, start),
      checkbox(fill: if correct and is-sol-mode { red }, tick: correct and is-sol-mode),
      body
    )
  }
}

/// Helper functions
#let correct(option) = { (correct: true, body: option) }

/// Helper function to quickly create options with a list style.
/// Use bullet list (`-`) for distractors and numbered list (`+`) for correct options
///  Example:
/// ```example
/// #quick-options[
///   - javascript
///   + typst
///   - python
///   - rust
/// ]
/// ```
#let quick-options(
  body
) = {
  show list.item: it => option(it.body)
  show enum.item: it => option(correct: true, it.body)

  body
}

/// Add multiple options to a question. The options get shuffled by default, but can be turned off with the `shuffle` argument. Each option is rendered with the `option` function, so the correct answer can be marked by using the `correct` helper function.
#let options(
  cols: 1,
  shuffle: true,
  ..seq
) = {
  let options-ordered = seq.pos()

  context {
    let options-shuffled = if shuffle {
      random.shuffle(options-ordered, _question_counter.get())
    } else {
        options-ordered
    }

    return grid(
      columns: cols,
      gutter: 1em,
      ..options-shuffled.map(o => {
        if type(o) == dictionary {
          option(o.body, correct: o.correct)
        } else {
          option(o)
        }
      })
    )
  }
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
  field: none,
  /// if true the answer is only hidden if solution mode is false.
  /// -> bool
  hide: false
) = {
    if hide == true {
      answer-field(hide(body))
    } else {
      answer-field(field)
    }

    context {
      if is-solution-mode() {
        set text(fill: color)
        body
      }
    }
}
