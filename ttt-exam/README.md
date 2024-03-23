# ttt-exam


`ttt-exam` is a *template* to create exams and belongs to the [typst-teacher-tools-collection](https://github.com/jomaway/typst-teacher-templates).

## Usage 

Run this command inside your terminal to init a new list. 

```sh
typst init @preview/ttt-exams my-exam
```

This will scaffold the following folder structure.

```ascii
my-exam/
├─ cover.typ
├─ details.toml
├─ exam.typ
├─ justfile
└─ logo.jpg
```

Replace the `logo.jpg` with your schools, university, ... logo or remove it. Then edit the `details.toml`.
Edit the `exam.typ` and replace the questions with your own.

If you have installed [just]() you can use it to build a *student* and *teacher* version of your exam by running `just build`.