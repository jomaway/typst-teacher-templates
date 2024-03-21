#import "utils.typ": tag, checkbox, if-auto-then, caro, lines as _lines
#import "random.typ": shuffle

// Global states
#let _solution = state("schulzeug-solution", false);
#let _question_counter = counter("schulzeug-assignment-counter");
#let reset-question-counter() = { _question_counter.update(0) }

// Labels
#let _assignment_label = label("schulzeug-assignment-label")
#let _question_label = label("schulzeug-question-label")

// Queries 
#let current-assignment() = { query(selector(_assignment_label).before(here())).last().value }
#let all-assignments() = { query(_assignment_label).map(m => m.value) }
#let current-question() = { query(selector(_question_label).before(here())).last().value }
#let all-questions() = { query(_question_label).map(m => m.value) }
#let get-questions(filter: none) = {
  if filter != none {
    all-questions().filter(filter)
  } else {
    all-questions()
  }
}

// Numbering utility functions
#let q-nr(style: "a)") = context numbering(style, current-question().num.last())
#let a-nr(style: "1.") = context numbering(style, current-assignment().num.first())

/// returns an array with points, grouped by assignments. 
/// ! needs context
#let get_points() = {
  let a_count = _question_counter.final().first()
  let list = ()
  for i in range(a_count) {
    let filter = q => (q.points != none and q.num.first() == i+1)
    list.push(
      get-questions(filter: filter).map(q => q.points ).sum(default: 0)
    )
  }
  return list
}

// Solution methods
#let show-solutions() = { _solution.update(true) }
#let hide-solutions() = { _solution.update(false) }

/// ! needs context
#let is-solution-mode() = {
  _solution.get()
}

#let set-solution-mode(value) = {
  assert.eq(type(value), bool, message: "expected bool, found " + type(value))
  _solution.update(value)
}

/// Sets whether solutions are shown for a particular part of the document.
///
/// - solution (boolean): the solution state to apply for the body
/// - body (content): the content to show
/// -> content
#let with-solution(solution, body) = context {
  let orig-solution = _solution.get()
  _solution.update(solution)
  body
  _solution.update(orig-solution)
}


// draws a small gray box which indicates the amount of points for that assignment/question  
// points: given points -> needs to be an integer
// plural: if true it displays an s if more than one point
#let point-tag(points, plural: false) = {
  assert.eq(type(points),int)
  // __point_list.update(l => increase_last(l, points))
  tag(fill: gray.lighten(35%))[#points #text(0.8em,smallcaps[#if points==1 [PT$\u{0020}$] else [PTs]])]
}


// assignments
#let _assignment_env = state("schulzeug-assignment-state", none)

#let enter_assignment_environment() = {
  _question_counter.step(level: 1)
  // __point_list.update(l => push_and_return(l, 0))
  context [#metadata((type: "schulzeug-assignment", num: _question_counter.get() )) #_assignment_label]
  _assignment_env.update(_question_counter.get())
}

#let leave_assignment_environment() = {
  _assignment_env.update(none)
}

#let is-inside-ass-env() = {
  _assignment_env.get() != none
}

#let assignment(body, number: "1.") = {
  context enter_assignment_environment()
  
  if (number != none and number != "hide") { a-nr(style: number) }
  body

  context leave_assignment_environment()
}

// questions low level api
#let _question(body, points: none) = {
  if points != none {
    assert.eq(type(points), int, message: "expected points argument to be an integer, found " + type(points))
  }
  context {
    let level = if is-inside-ass-env() { 2 } else { 1 }
    _question_counter.step(level: level)
    // note: metadata must be a new context to fetch the updated _question_counter value correct
    context [#metadata((type: "schulzeug-question", num: _question_counter.get() ,points: points, level: level)) #_question_label]
    // __point_list.update(l => increase_last(l, points))
  }
  body
}

// questions high level api
#let question(body, points: none, num_style: auto) = {
  grid(
    columns: (1fr, auto),
    column-gutter: 0.5em,
    // ass(points: points,level: 2)[
    _question(points: points)[
      #context q-nr(style: if-auto-then(num_style, { if is-inside-ass-env() { "a)" } else { "1." }  }))
      #body
    ],
    if points != none {
      place(end, dx: 1cm,point-tag(points))
    }
  )
}


//  body will only be printed if _solution is false
#let placeholder(body) = {
  context {
    if _solution.get() == false { body }
  }
}

// only print if _solution is true
#let solution(solution, alt: []) = {
    placeholder(alt)
    context {
      if _solution.get() == true { 
        set text(fill: rgb( 255, 87, 51 )) // set a red text.
        solution 
      }
    }
}

// multiple choice 
#let mct(distractors: (), answer: (), dir: ttb) = {
  let answers = if (type(answer) == array ) { answer } else { (answer,) }
  let choices = (..distractors, ..answers)

  choices = shuffle(choices).map(choice => {
    box(inset:(x:0.5em))[
      #context {
        let is-solution =  _solution.get() and choice in answers
        checkbox(fill: if is-solution { red }, tick: is-solution )
      }
    ]; choice
  })

  stack(dir:dir, spacing: 1em, ..choices)
}

#let multiple-choice(data) = {
  // assertions
  assert(type(data) == dictionary, message: "expected data to be a dictionary, found " + type(data))
  let keys = data.keys()
  assert("prompt" in keys, message: "could not find prompt in keys");
  assert("distractors" in keys, message: "could not find distractors in keys");
  assert("answer" in keys, message: "could not find answer in keys");

  // create output
  block(breakable: false,
    question(points: if (type(data.answer) == array) { data.answer.len() } else { 1 })[
      #data.prompt
      #mct(
        distractors: data.distractors, 
        answer: data.answer
      )
      // show context hint if available.
      #if ("context" in data.keys()) {
        text(weight: 100)[Hint: #data.at("context", default: none)]
      }
    ]
  )
}

#let free-text-question(body, points: 0, area: _lines(4), sol: none) = {
  question(points: points)[
    #body
    #placeholder(area)
  ]
}