#import "@local/ttt-exam:0.1.0":  cover-page

#let details = toml("details.toml")

#let meta = (
    class: details.exam.class,
    subject: details.exam.subject,
    kind: "sa",
    dates: (
        gehalten: details.exam.date,
        zurückgegeben: none, 
        eingetragen: none,
    ),
    comment: none, 
    total_points:  70,
)

#set text(lang: "de", font: "Rubik", weight: 300)
#set strong(delta: 200)

#cover-page(..meta)