#import "utils.typ": tag, checkbox

// Language settings
#let lang_dict = toml("lang.toml");
#let __lang = state("lang", "en");

// Helpers for lang
#let _get_str_for(key) = {
  locate(loc => {
    let selected_lang = __lang.at(loc)
    if (not lang_dict.keys().contains(selected_lang)) {  selected_lang = "en" }
    let string = lang_dict.at(selected_lang).at(key, default: none)
    return string
  })
}

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
  locate(loc => {
    return __point_list.final(loc).sum()
  })
}


/*  function for the numbering of the tasks and questions */
#let __assignment_numbering = (..args) => {
  let nums = args.pos()
  if nums.len() == 1 {
    numbering("1. ", nums.last())
  } else if nums.len() == 2 {
    numbering("a) ", nums.last())
  }
}

// use for global config with show rule
#let schulzeug-assignments(
  lang: "en",
  show_solutions: false, 
  reset_assignment_counter: false,
  reset_point_counter: false,
  body 
) = {
  assert(
    type(lang) == str, 
    message: "The lang parameter needs to be of type string."
  );
  __lang.update(lang);
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
  tag(fill: gray.lighten(35%))[#points #smallcaps[#if points==1 [#_get_str_for("pt")] else [#_get_str_for("pts")]]]
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
        set text(size: 1.1em, weight: "semibold")
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
  locate(loc => {
    if __show_solution.at(loc) == false { body }
  })
}

// only print if __show_solution is true
#let solution(solution, alt: []) = {
    placeholder(alt)
    set text(fill: rgb( 255, 87, 51 ))
    locate(loc => {
      if __show_solution.at(loc) == true { solution }
    })
}

// multiple choice 
#let mct(choices: (), answer: none, dir: ttb) = {
  assert(
    (type(answer) == int or type(answer) == array), 
    message: "Answer needs to be an integer with the index of the correct answer"
  )
  if type(answer) == int { answer = (answer,)}

  assert(
    type(choices) == array, 
    message: "Choises must be given as an array"
  )
  for a in answer {
    assert(
      choices.len() >= a, 
      message: "anwers outside of bound"
    )

  }

  choices = choices.enumerate().map(((i,a)) => 
      block[
        #box(inset: (x: 0.5em))[
          #locate(loc => {
          checkbox(fill: if __show_solution.at(loc) and answer.contains(i+1) {red})
          })
        ] 
        #a
      ]
  )

  stack(dir:dir, spacing: 1em, ..choices)
}