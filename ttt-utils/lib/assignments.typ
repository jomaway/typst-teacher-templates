#import "components.typ": point-tag, checkbox, caro, lines as _lines
#import "helpers.typ": if-auto-then
#import "random.typ": shuffle

// States
#let _solution = state("ttt-solution", false);
#let _answer_field = state("ttt-auto-field", _lines(2))
#let set-default-answer-field(field) = _answer_field.update(field)

// Counters
#let _question_counter = counter("ttt-question-counter");
#let reset-question-counter() = { _question_counter.update(0) }

// Labels
#let _question_label = label("ttt-question-label")

// Queries 
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
#let a-nr(style: "1.") = context numbering(style, _question_counter.get().first())
#let q-nr(style: "a)") = context numbering(style, _question_counter.get().last())


// Solution methods
#let show-solutions = { _solution.update(true) }
#let hide-solutions = { _solution.update(false) }

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


// assignments
#let _assignment_env = state("ttt-assignment-state", none)

#let new-assignment = {
  _question_counter.step(level: 1)
  context _assignment_env.update(_question_counter.get().first())
}

#let end-assignment = _assignment_env.update(none)

#let is-assignment() = {
  _assignment_env.get() != none
}


#let assignment(body, number: "1.") = {
  new-assignment
  
  if (number != none and number != "hide") { a-nr(style: number) }
  body

  end-assignment
}

// questions low level api
#let _question(body, points: none) = {
  if points != none {
    assert.eq(type(points), int, message: "expected points argument to be an integer, found " + type(points))
  }
  context {
    let level = if is-assignment() { 2 } else { 1 }
    _question_counter.step(level: level)
    // note: metadata must be a new context to fetch the updated _question_counter value correct
    context [#metadata((type: "ttt-question", num: _question_counter.get() ,points: points, level: level)) #_question_label]
  }
  body
}

// questions high level api
#let question(body, points: none, num_style: auto) = {
  grid(
    columns: (1fr, auto),
    column-gutter: 0.5em,
    _question(points: points)[
      #context q-nr(style: if-auto-then(num_style, { if is-assignment() { "a)" } else { "1." }  }))
      #body
    ],
    if points != none {
      place(end, dx: 1cm,point-tag(points))
    }
  )
}

// multiple choice 
#let _multiple-choice(distractors: (), answer: (), dir: ttb) = {
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

#let multiple-choice(..args) = {
  // assertions
  let data = args.named()
  assert(type(data) == dictionary, message: "expected data to be a dictionary, found " + type(data))
  let keys = data.keys()
  assert("prompt" in keys, message: "could not find prompt in keys");
  assert("distractors" in keys, message: "could not find distractors in keys");
  assert("answer" in keys, message: "could not find answer in keys");

  // create output
  block(breakable: false,
    question(points: if (type(data.answer) == array) { data.answer.len() } else { 1 })[
      #data.prompt
      #_multiple-choice(
        distractors: data.distractors, 
        answer: data.answer,
        dir: if data.at("dir", default: none) != none { data.at("dir") } else { ttb }
      )
      // show hint if available.
      #if ("hint" in data.keys()) {
        strong(delta: -100)[Hint: #data.at("hint", default: none)]
      }
    ]
  )
}

// only print if _solution is true
#let solution(solution) = {
    context {
      if _solution.get() == true { 
        set text(fill: rgb( 255, 87, 51 )) // set a red text.
        solution 
      }
    }
}

//  body will only be printed if _solution is false
#let answer-field(body) = {
  context {
    if _solution.get() == false { body }
  }
}

#let answer(body, field: auto) = {
    answer-field(context if-auto-then(field, _answer_field.get()))
    solution(body)
}

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
