#import "@preview/ttt-utils:0.1.2": grading, components
#import "@preview/ttt-exam:0.1.1": small-grading-table

#let get-info(data) = {
  return data.at("info", default: (
    class:"unknown", 
    subject:"unknown",
    title: "1. Exam",
    subtitle: "",
    date: 2024-01-01,
    authors: "unknown",
  ))
}


#let process-students(students, grade-scale) = {
  students.pairs().map( ((name, points)) => {
    // sum points
    points = if type(points) == array { points.sum() } else {points}
    // get grade
    let grade = grading.points-to-grade(points,grade-scale)
    // return dict for each student
    ("name": name, "points": points, "grade": grade)
  })
}


// get file from input.
#let file = sys.inputs.at("file", default: "meta.toml")
// #assert.ne(file, none, message: "Need an file input.")

// read data from file
#let data = toml(file)

#set page(
  "a4", 
  margin:2cm, 
  header: [Auswertung #h(1fr) #components.tag(get-info(data).class)]
)

#set text(font: "Rubik", lang: "de")
#set table(fill: (_,y) => if y == 0 { luma(230)})

// title
#align(center, text(16pt)[#get-info(data).title im Fach #get-info(data).subject])

// calculations
#let total-points = data.at("points", default: 0).at("total", default: 0)
#let grade-scale = grading.ihk-scale(total-points, step: 0.5, offset: 1)

#let grade-dist = state("grade-dist",("1":0,"2":0,"3":0,"4":0,"5":0,"6":0))

#let student-data = process-students(data.students, grade-scale)

Total-Points: #total-points
#table(
  columns: 3,
  inset: (_,y) => if (y < 1) {(x: 1em, y:0.5em)} else {1em},
  fill: (_,y) => if (y < 1) {luma(230)} else { none },
  align: center + horizon,  
  table.header("Name/ID", "Points", "Grade"),
  ..student-data.map(s => (s.name, [#s.points], if s.grade != none [*#s.grade* #grade-dist.update(d => { d.at(str(s.grade)) = d.at(str(s.grade)) + 1; d})] else [ invalid ])).flatten()
)

= Verteilung


#context small-grading-table(grade-scale, grade-dist.final())

*Durchschnitt:* #context grading.grade-average(grade-dist.final())
