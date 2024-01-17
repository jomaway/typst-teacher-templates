# typst-teacher-tools (Schulzeug)

Collection of tools, which makes the teacher life easier.

> Old version of this repo is still available under the branch [depricated](https://github.com/jomaway/typst-teacher-templates/tree/depricated)

⚠️ **Warning: Still in alpha state**

## Usage

For the moment you need to Download this repo and pack it into a local package `schulzeug` then you can use it in typst like this:

```typst
    #import "@local/schulzeug:0.1.0": *
```

> Planning to publish it as a package soon.

### Create an exam

```typst
#show: exam.with(
    title: logo_title(logo,"1. Schulaufgabe"),
    date: datetime(year: 2024, month: 02, day: 01), 
    class: "Klasse",
    subject: "BSA",
    authors: "jomaway",
    show_solutions: false,  // Print solutions in red color
)
// Add Assignments
#assignment[Task number one]
#question(points: 2)[question a]  // question is basically a level 2 assignment
#placeholer[#lines(2)]
#solution[The solution to this question is ...]
#question(points: 4)[question b]
#solution(placeholder: caro(4))[Solution is ...]
#question(points: 3)[question c]
#solution[Multiple solutions possible.]
```

# Changelog

See [CHANGELOG.md](CHANGELOG.md)
