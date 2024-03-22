#import "@local/ttt-exam:0.1.0": assignment, multiple-choice

#let data = toml("quizzes.toml")

#assignment[Kreuzen Sie die richtige Lösung an.
  #for mct in data.questions {
    multiple-choice(mct)
  }
]

