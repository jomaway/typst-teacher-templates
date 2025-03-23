#import "../lib/assignments.typ": *

= Test assignments

== Seperated tests
=== Assignment without questions
#assignment[
  This is a first assignment.
]

=== Question without points
#question[
  This is a question.
]

=== Question with points
#question(points:3)[
  This is a pointed question.
]

#with-solution(true)[
  #answer[Answer]
]

== Assignment with questions
=== without points
#assignment[
  This is a second assignment.

  #question[
    This is a question.
  ]

  #question[
    This is another question.
  ]
]

=== with points
#assignment[
  This is a second assignment.

  #question(points:2)[
    This is a question.
  ]

  #question(points:1)[
    This is another question.
  ]
]


== Collect points

#assignment(collect-points: true)[
  This is a third assignment.

  #question(points:2)[
    This is a question.
  ]

  #question(points:1)[
    This is another question.
  ]
]


== Multiple choice

#assignment(collect-points: true)[
  Tick the correct answers.
  #choice(
    prompt: [What is the result of $1+1$?],
    distractors: (1, 3, 4, 0),
    answers: 2,
    hint: "The result is even.",
    dir: ltr
  )

  #choice(
    prompt: [What is the result of $1-1$?],
    distractors: (2, 1, 3, 4),
    answers: 0,
    hint: "The result is even.",
    dir: ltr
  )
]

=== with solution-mode turned on
#with-solution(true)[
  #assignment(collect-points: true)[
    Tick the correct answers.
    #choice(
      prompt: [What is the result of $1+1$?],
      distractors: (1, 3, 4, 0),
      answers: 2,
      hint: "The result is even.",
      dir: ltr
    )

    #choice(
      prompt: [What is the result of $1-1$?],
      distractors: (2, 1, 3, 4),
      answers: 0,
      hint: "The result is even.",
      dir: ltr
    )
  ]
]


== Long assignments

#assignment[
  #lorem(30)
]

#question[
  #lorem(30)
]

#question(points: 13)[
  #lorem(30)
]

#assignment[
  #lorem(30)
  #question[
    #lorem(30)
  ]
  #question(points: 9)[
    #lorem(30)
  ]
]


#assignment(collect-points: true)[
  #lorem(30)
  #question[
    #lorem(30)
  ]
  #question(points: 7)[
    #lorem(30)
  ]
]
