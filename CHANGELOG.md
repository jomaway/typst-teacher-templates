# Changelog

## v0.1.0 (upcomming)

**Templates:**

- Added option to import templates with `#import templates.TEMPLATE_NAME`.
- Added `exam` template.
- Added `cover-page` to `exam` template.
- Added `worksheet` template.

**Assignments:**

- Added `assignment` function with different levels.
- Added `question` function as shortcut to level:2 assignment.
- Added `mct` function to add multiple choice questions.
- Added `solution` function.
- Added `placeholder` function which is only shown if solution is hidden.
- Added `point-sum-box` variable to show the total points.
- Added **point-counter** to calculate the total points.
- Added `__assignment_counter` for displaying numbers in front of each assignment.
- Added `schulzeug-assignments` for using as global show rule. 
    - Added option to show and hide a `solution` with `show_solutions: true`
    - Added option to reset the `__assignment_counter` with `reset_assignment_counter: true`
    - Added option to reset the **point-counter** with `reset_point_counter: true`


**Utils:** 

- Added function `caro`
- Added function `lines`
- Added function `tag`
- Added function `checkmark`
- Added function `field`
- Added function `side-by-side`
- Added variable `cc_by-sa-eu`
- Added function `intro-block`

**Grading:**

- Added function `calc_grade_distribution`
- Added function `get_max_points` and `get_min_points`
- Added function `grading_table`

**Examples:**

- Added example (*simple-assignments.typ*) for demonstrating the basic usage of the `assignment` module.
- Added example (*sa.typ*) for creating a exam with the `assignment` module.
- Added example (*cover.typ*) for creating an exam cover page with grade distribution.
- Added example (*students.typ*) for creating studentlists from `csv` files.