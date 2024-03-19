#import "utils.typ": tag, checkbox
#import "random.typ": shuffle

// Global states
#let __show_solution = state("s", false);
#let __assignment_counter = counter("assignment-counter");
#let __point_list = state("point-list", ())

#let push_with_return(a_list, value) = {
  a_list.push(value)
  return a_list
}

#let increase_last(a_list, value) = {
  a_list.last() += value
  return a_list
}

#let get_total_points() = {
  context {
    return __point_list.final().sum()
  }
}

/// function for the numbering of the tasks and questions
#let __assignment_numbering = (..args) => {
  let nums = args.pos()
  if nums.len() == 1 {
    set text(1em, weight: "semibold")
    numbering("1. ", nums.last())
  } else if nums.len() == 2 {
    numbering("a) ", nums.last())
  }
}

/// use for global config with show rule
#let schulzeug-assignments(
  show_solutions: false, 
  reset_assignment_counter: false,
  reset_point_counter: false,
  body 
) = {
  __show_solution.update(show_solutions)
  // check reset_assignment_counter
  if reset_assignment_counter {
    __assignment_counter.update(0)
  }
  // check reset_point_counter
  if reset_point_counter {
    __point_list.update(())
  }
  body
}

// draws a small gray box which indicates the amount of points for that assignment/question  
// points: given points -> needs to be an integer
// plural: if true it displays an s if more than one point
#let point-box(points, plural: false) = {
  assert.eq(type(points),int)
  __point_list.update(l => increase_last(l, points))
  tag(fill: gray.lighten(35%))[#points #text(0.8em,smallcaps[#if points==1 [PT] else [PTs]])]
}

/* template for a grid to display the point-box on the right side. */
#let point-grid(body, points) = {
  grid(
    columns: (1fr, auto),
    gutter: 1.5em,
    body,
    if points != none {
      point-box(points)
    }
  )
}

// assignment indicates a new section of questions.
// It updates the assignment-counter on the first level.
// It displays the title of the new assignment and numbers it with digits.
// optional a point box can be displayed for a whole assignment.
#let assignment(desc, points: none, level: 1) = {
  __assignment_counter.step(level: level)
  point-grid(
    {
      if (level == 1) {
        // on Assignments, add another item to the list of assignments
        __point_list.update(l => push_with_return(l, 0))
        __assignment_counter.display(__assignment_numbering);
        desc
      } else {
        __assignment_counter.display(__assignment_numbering);
        desc
      }
    },
    points
  )
}

// Second level assignment
#let question(desc, points: none, level: 2) = assignment(
  desc, points: points,level: level)


//  body will only be printed if __show_solution is false
#let placeholder(body) = {
  context {
    if __show_solution.get() == false { body }
  }
}

// only print if __show_solution is true
#let solution(solution, alt: []) = {
    placeholder(alt)
    set text(fill: rgb( 255, 87, 51 ))
    context {
      if __show_solution.get() == true { solution }
    }
}

// multiple choice 
#let mct(distractors: (), answer: (), dir: ttb) = {
  let answers = if (type(answer) == array ) { answer } else { (answer,) }
  let choices = (..distractors, ..answers)

  choices = shuffle(choices).map(choice => {
    box(inset:(x:0.5em))[
      #context {
        let is-solution =  __show_solution.get() and choice in answers
        checkbox(fill: if is-solution { red }, tick: is-solution )
      }
    ]; choice
  })

  stack(dir:dir, spacing: 1em, ..choices)
}

#let mct_question(data) = {
  // assertions
  assert(type(data) == dictionary, message: "expected data to be a dictionary, found " + type(data))
  let keys = data.keys()
  assert("prompt" in keys, message: "could not find prompt in keys");
  assert("distractors" in keys, message: "could not find distractors in keys");
  assert("answer" in keys, message: "could not find answer in keys");

  // create output
  question[#data.prompt]
  mct(
    distractors: data.distractors, 
    answer: data.answer
  )

  // show context hint if available.
  if ("context" in data.keys()) {
    text(weight: 100)[Hint: #data.at("context", default: none)]
  }
}