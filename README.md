# typst-teacher-tools (Schulzeug)

Collection of tools, which makes the teacher life easier.

> Old version of this repo is still available under the branch [deprecated](https://github.com/jomaway/typst-teacher-templates/tree/deprecated)

⚠️ **Still a work in progress**

## Features 

- Create assignments with automated point summary and solutions
- Create cover pages for the exams with grade distribution, ... (early stage, only german)
- Create beautiful student lists from a csv file.


## Usage

For the moment you need to Download this repo and pack it into a local package `schulzeug` then you can use it in typst like this:

```typst
#import "@local/schulzeug:0.1.0": *
```

> Planning to publish it as a package soon.

### Create an exam

```typst
#import "@local/schulzeug:0.1.0": *
#import templates.exam: *

#show: exam.with(
    title: "1. Schulaufgabe",
    date: datetime(year: 2024, month: 02, day: 01), 
    class: "Klasse",
    subject: "BSA",
    authors: "jomaway",
    show_solutions: false,  // Print solutions in red color
)
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
```

### Create a Studentlist

Take an `csv` file with your student data, like the following.
```csv
Firstname, Lastname,
Anton, Arbor,
Bernd, Bird,
```

Create a `students.typ` file like this.
```
#import "@local/schulzeug:0.1.0": studentlist

#let data = csv("students.csv")

= Studentlist

#studentlist(
  numbered: true, 
  class: "IAV 2425",
  data,
)
```
and voilà see the result. And yes you can add more columns to the csv file.

### Examples 

For more check out the [examples](./examples/).

# Changelog

See [CHANGELOG.md](CHANGELOG.md)
