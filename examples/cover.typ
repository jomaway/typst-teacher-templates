#import "@local/schulzeug:0.1.0": cover-page

#let details = toml("details.toml")

#let meta = (
    class: details.class,
    subject: details.subject,
    dates: (
        gehalten: details.sa1.date,
        zurückgegeben: none, 
        eingetragen: none,
    ),
    comment: none, 
    total_points:  70,
)

#cover-page(..meta)