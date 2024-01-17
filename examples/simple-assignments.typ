#import "@local/schulzeug:0.1.0": *

= Simple example of the assignment module
== Student version without solutions.

// Add Assignments
#assignment[Answer those questions.]
#question(points: 2)[question a]  // question is basically a level 2 assignment
#placeholder[#lines(2)]
#solution[The solution to this question is ...]
#question(points: 4)[question b]
#solution(alt: caro(4))[Solution is ...]
#question(points: 3)[question c]
#solution[Multiple solutions possible.]

#assignment[Write some text about ...]

#point-sum-box

== Teacher version with solutions.
// Show solutions
#show: schulzeug-assignments.with(
  show_solutions: true,
  reset_assignment_counter: true,
  reset_point_counter: true
);

// Add Assignments
#assignment[Answer those questions.]
#question(points: 2)[question a]  // question is basically a level 2 assignment
#placeholder[#lines(2)]
#solution[The solution to this question is ...]
#question(points: 4)[question b]
#solution(alt: caro(4))[Solution is ...]
#question(points: 3)[question c]
#solution[Multiple solutions possible.]

#assignment[Write some text about ...]

#place(end,point-sum-box)
