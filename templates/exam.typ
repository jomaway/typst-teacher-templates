#import "../assignment.typ": __show_solution, schulzeug-assignments as assignments, get_total_points, _get_str_for, __point_list

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

// Show a box with the total_points
#let point-sum-box = {
  align(end)[
    #box(stroke: 1pt, inset: 0.8em, radius: 2pt)[
      #text(1.4em, sym.sum) :  \_\_\_\_ \/ #get_total_points() #smallcaps(_get_str_for("pt"))
    ]
  ]
}

// Show a table with point distribution
#let point-table = {
  locate(loc => {
    let pl = __point_list.final(loc)
    table(
      align: (col, _) => if (col == 0) { end} else {center},
      columns: pl.len() + 2,
      _get_str_for("assignment"), ..pl.enumerate().map(((i,_)) => [#{i+1}]), _get_str_for("total"),
      _get_str_for("points"), ..pl.map(str), get_total_points(),
      _get_str_for("awarded"),
    )
  })
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
          Viel Erfolg #box(height: 1em, image("../assets/four-leaf-clover.svg"))
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



// COVER PAGE
#let cover-page(
  class: none,
  subject: none,
  dates: (
          gehalten: none, 
          zurückgegeben: none, 
          eingetragen: none,
        ),
  comment: none,
  total_points: 100,
  ..args
) = {
  import "../utils.typ": checkbox, lines, field
  import "../grading.typ": calc_grade_distribution, grading_table

  return page(
    margin: (left: 20mm, right: 20mm, top: 10mm, bottom: 20mm),
    footer: none
  )[
    #set text(16pt)

    // header - title
    #box(
      width: 100%, 
      stroke: luma(70),
      inset: 1em, 
      radius: 3pt
    )[
      #align(center)[#text(22pt)[Deckblatt Leistungsnachweis]]
    ]

    // content
    #grid(
      columns: (auto, 4.7cm, auto, auto),
      column-gutter: 1em,
      row-gutter: 1em,
      "Klasse: ", text(weight: "semibold", class),
      "Schuljahr: ", 
      { 
        if type(dates.gehalten) == datetime {
          let date = dates.gehalten;
          if date.month() < 9 {str(date.year()-1) + "/" + str(date.year())} else { str(date.year()) + "/" + str(date.year()+1) }
        } else { align(bottom,line(length: 3cm))}
      },
      "Fach: ", text(weight: "semibold", subject),
      [#checkbox() SA #checkbox() KA],
      [ #checkbox() \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_]
    )
    #v(0.5cm)
    
    // Missing student and student count
    #table(
      columns: (auto),
      row-gutter: (1cm),
      stroke: none,
      inset: 0pt,
      align: bottom,
      [Fehlende SchülerInnen: #box(width: 1fr)[#align(end)[ Anzahl Teilnehmer: #box(width:1.5cm, stroke: (bottom: 0.5pt))]]],
      lines(2)
    )


    // Dates
    Datum: #h(1fr)
    #field("gehalten", value: dates.gehalten.display("[day].[month].[year]")) #h(1fr) 
    #field("zurückgegeben") #h(1fr) 
    #field("eingetragen")
    
    #v(0.5cm)

    // Grading table uses the ihk grading distribution
    #grading_table(calc_grade_distribution(total_points));

    // Comment
    #grid(
      columns: (auto),
      row-gutter: 1cm,
      smallcaps("Bemerkung:"),
      if (comment != none) {comment} else {
          lines(2)
      },
    )
    
    // Signature
    #align(bottom, 
      box(
        stroke: (top: (thickness:1pt, paint:blue, dash: "dashed") ), 
        width: 100%, 
        inset: (top: 4pt)
      )[
        #text(12pt)[#smallcaps("Unterschrift:")]
        
        #h(1cm) #field("Lehrer") 
        #h(1fr) #field("Fachbetreuer")
      ]
    )      

  ] // end page

}
