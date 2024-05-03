#import "assignments.typ": get-questions, _question_counter

/// Fetch the total points which can be reached from the questions metadata
/// ! needs context.
///
/// -> integer
#let total-points() = get-questions().map(q => q.points).sum(default: 0)

/// Sums up all question points, grouped by assignments. 
/// ! needs context.
///
/// -> array
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


/// Generate a grade distribution with upper and lower point limits.
///
/// - step (integer): smallest unit of a point. 0.5 for half points and 1 for full points.
/// - max (integer): total points which can be reached.
/// ..args (float, integer, string, content): excepts conditional arguments with a lower bound followed by the grade as content or string.
/// -> array
#let grades(step: 1, max: none, ..args) = {
  assert(args.named().len() == 0)
  assert(step in (0.5,1), message: "only steps of [0.5] or [1] is supported.")
  let args = args.pos()
  assert(calc.odd(args.len()))

  range(0, args.len(), step: 2).map((i) => (
    grade: args.at(i),
    lower-limit: if i > 0 { calc.round(args.at(i - 1)) } else { 0 },
    upper-limit: if i < args.len() - 1 { calc.round(args.at(i + 1)) - step } else { max },
  ))
}


/// The german IHK grading distribution
///
/// - total (integer): total points which can be reached
/// - step: smallest unit of a point. 0.5 for half points and 1 for full points.
/// -> array
#let ihk-grades(total, step: 1) = grades(
  max: total,
  step: step, 
  6, 
  0.3 * total, 5, 
  0.5 * total, 4, 
  0.67 * total, 3, 
  0.81 * total, 2, 
  0.91 * total, 1, 
)


/// Fetch a grade for a certain amount of points
///
/// - points (integer, float): the points a student reached.
/// - grades (dictionary): The dictionary returned from the @@grades function.
/// -> (any) The grade. Type depending on the value inside the dictionary.at("grade")
#let points-to-grade(points, grades) = {
  let result = grades.find(g => g.lower-limit <= points and g.upper-limit >= points)
  result.grade 
}


/// calculates the grade average for an given grade distribution 
/// currently the grades need to be int-values, like in germany.
///
/// - dist (dictionary): The grade distribution as dict. e.x. ("1":0,"2":0,"3":0,"4":0,"5":0,"6":0)
/// - digits: (integer): Number of digits which the result is rounded to. Default: 2
/// -> (float): The rounded grade average.
#let grade-average(dist, digits: 2) = {
  assert.eq(type(dist), dictionary, message: "Expected dist to be of type dictionary, found " + type(dist))
  let sum = dist.pairs().fold(0, (sum,(k,v)) => {
    sum = sum + int(k) * v
    sum
  })
  calc.round(sum / dist.values().sum(), digits: digits)
}
