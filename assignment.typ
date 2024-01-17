#import "helpers.typ": tag, checkbox
// Global state 
#let __show_solution = state("s", false);
#let total_points = state("t", 0);

#let assignment_counter = counter("assignment-counter");

/*  function for the numbering of the tasks and questions */
#let assignment-numbering = (..args) => {
  let nums = args.pos()
  if nums.len() == 1 {
    numbering("1. ", nums.last())
  } else if nums.len() == 2 {
    numbering("a) ", nums.last())
  }
}


// draws a small gray box which indicates the amount of points for that assignment/question  
// points: given points -> needs to be an integer
// plural: if true it displays an s if more than one point
#let point-box(points, plural: false) = {
  assert.eq(type(points),int)
  total_points.update(t => t + points)
  tag(fill: gray.lighten(35%))[#points #smallcaps[pt#if points > 1 and plural [s]]]
}

// Show a box with the total_points
#let point-sum-box = {
  place(bottom + end)[
    #box(stroke: 1pt, inset: 0.8em, radius: 2pt)[
      #text(1.4em, sym.sum) :  \_\_\_\_ \/ #total_points.display() #smallcaps("PT")
    ]
  ]
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

/*
  assignment indicates a new section of questions.
  It updates the assignment-counter on the first level.
  It displays the title of the new assignment and numbers it with digits.
  optional a point box can be displayed for a whole assignment.
*/
#let assignment(desc, points: none, level: 1) = {
  assignment_counter.step(level: level)
  point-grid(
    {
      if (level == 1) {
        set text(size: 1.1em, weight: "semibold")
        assignment_counter.display(assignment-numbering);
        desc
      } else {
        assignment_counter.display(assignment-numbering);
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

