#import "assignment.typ": __show_solution, schulzeug-assignments as assignments

// Header block
#let exam-header-block(
  title,
  class,
  subject,
  date,
) = {
  // HEADER BLOCK
  let cell(content) = {
    set align(left)
    rect(
      width: 100%,
      height: 100%,
      inset: 0.7em,
      stroke: 1pt, //(left: 1pt, right: 1pt),
      [
        #set text(13pt)
        #set align(top + left)
        #content
      ]
    )
  }
  // header
  rect(
    inset: 0mm, 
    outset: 0mm, 
    stroke: (bottom: 1pt, top: 1pt),
    grid(
      columns: (auto),
      rows: (35mm),
      grid(
        columns: (1fr, 35mm),
        rows: (25mm),
        grid(
          columns: (3fr, 5fr),
          cell()[
            #set text(13pt)
            #set align(horizon)
            #set par(leading: 1em)
            #smallcaps("Klasse: ") #class \ 
            #smallcaps("Fach: ") #subject \
            #smallcaps("Datum: ") #if type(date) == datetime { date.display("[day].[month].[year]") } else {date}
          ],
          cell()[
            #align(horizon + center)[
              #block(below: 0.6em)[
                #set text(18pt, weight: 800)
                #title
              ]
            ]
          ],
        ),
        grid(
          rows: 35mm,
          cell()[
            #align(top + start)[
            #smallcaps("Note:")]
          ],  
        ),
        grid(
          columns: 100%,
          rows: 10mm,
          cell()[#smallcaps("Name:")]
        )
      )
    )
  )

} // END HEADER BLOCK

// stack for logo-title block
#let logo_title(image, title, dir: ltr) = {
    stack(spacing: 0.5em, dir:dir, image, title)
}

// The exam function defines how your document looks.
#let exam(
  title: "exam", // shoes the title of the exam -> 1. Schulaufgabe | Stegreifaufgabe | Kurzarbeit
  date: datetime.today(),     // date of the exam
  class: "",    
  subject: "" ,
  authors: "",
  show_solutions: false,
  body
) = {

  // Error checks
  assert(
    type(date) == datetime, 
    message: "The date parameter needs to be of type datetime."
  );

  // Set the document's basic properties.
  set document(author: authors, title: "exam-"+subject+"-"+class)
  set page(
    margin: (left: 20mm, right: 20mm, top: 10mm, bottom: 20mm),
    footer: {
      // Copyright symbol
      sym.copyright; 
      // YEAR
      if type(date) == datetime { date.display("[year]") } else { datetime.today().display("[year]") }
      // Authors
      if (type(authors) == array) [
      #authors.join(", ", last: " and ")
      ] else [
      #authors
      ]
      // Erfolg
      h(1fr)
      text(10pt, weight: "semibold", font: "Atma")[
          Viel Erfolg #box(height: 1em, image("assets/four-leaf-clover.svg"))
      ]
      h(1fr)
      // Page Counter
      counter(page).display("1 / 1", both: true)
    }
  )

  show: assignments.with(show_solutions: show_solutions);

  // Include Header-Block
  exam-header-block(
    title,
    class,
    subject,
    date,
  )

  // Predefined show rules
  show par: set block(above: 1.2em, below: 1.2em)


  // Content-Body
  body

}



