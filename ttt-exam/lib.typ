#import "@local/ttt-utils:0.1.0": assignments, components, grading
#import assignments: *
#import components: *
#import grading: *

#import "@preview/linguify:0.3.0": *

#let exam-header-block(
  title,
  class,
  subject,
  date,
) = {
  date = if type(date) == datetime { date.display("[day].[month].[year]") } else { date }

  table(
    columns: (3fr, 5fr, 35mm),
    rows: (25mm, 10mm),
    inset: 0.7em,
    table.cell(align: horizon)[
      #set par(leading: 1em)
      #smallcaps(linguify("class") + ":") #class \ 
      #smallcaps(linguify("subject") + ":") #subject \
      #smallcaps(linguify("date") + ":") #date
    ],
    table.cell(align: center + horizon)[
      #set text(18pt, weight: 800)
      #title
    ],
    table.cell(rowspan: 2)[#align(top + start)[#smallcaps(linguify("grade") + ":")]],
    table.cell(colspan: 2)[#smallcaps(linguify("name") + ":")]
  )
}

// stack for logo-title block
#let logo_title(image, title, dir: ltr) = {
    stack(spacing: 0.5em, dir:dir, image, title)
}

#let total_points = context get_points().sum()

// Show a box with the total_points
#let point-sum-box = {
  box(stroke: 1pt, inset: 0.8em, radius: 3pt)[
    #set align(bottom)
    #stack(
      dir:ltr,
      spacing: 0.5em,
      box[#text(1.4em, sym.sum) :],
      line(stroke: 0.5pt), "/",
      [#total_points #smallcaps(linguify("pt"))]
    )
  ]
}

// Show a table with point distribution
#let point-table = {
  context {
    let points = get_points()
    box(radius: 5pt, clip: true, stroke: 1pt,
      table(
        align: (col, _) => if (col == 0) { end } else { center },
        inset: (x: 1em, y:0.6em),
        fill: (x,y) =>  if (x == 0 or y == 0) { luma(230) },
        rows: (auto, auto, 1cm),
        columns: (auto, ..((1cm,) * points.len()), auto),
        linguify("assignment"), ..points.enumerate().map(((i,_)) => [#{i+1}]), linguify("total"),
        linguify("points"), ..points.map(str), total_points,
        linguify("awarded"),
      )
    )
  }
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
          #linguify("good_luck") #box(height: 1em, image("assets/four-leaf-clover.svg"))
      ]
      h(1fr)
      // Page Counter
      counter(page).display("1 / 1", both: true)
    }
  )

  let cli_arg_lsg = sys.inputs.at("solution", default: none)
  if (cli_arg_lsg != none) { show_solutions = json.decode(cli_arg_lsg) }
  assert.eq(type(show_solutions), bool, message: "expected bool, found " + type(show_solutions))

  linguify_set_database(toml("assets/lang.toml"));
  set-solution-mode(show_solutions)

  // Include Header-Block
  exam-header-block(title, class, subject, date)

  // Predefined show rules
  show par: set block(above: 1.2em, below: 1.2em)

  // Content-Body
  body

}



#let grading_table(dist) = {
  table(
    columns: (2cm, 1fr, 5cm),
    inset: 0.7em,
    align: center,
    "Note", "Punkteschlüssel", "Anzahl",
    ..range(6).map(el => ([#{el + 1}],align(start)[#h(2cm,)
      von #box(width: 2.2em, inset: (left: 4pt))[#get_min_points(dist, el+1)]
      bis #box(width: 2.2em, inset: (left: 4pt))[#get_max_points(dist, el+1)]
    ], "")).flatten(),
    table.cell(colspan: 2)[
      #align(end)[Notendurchschnitt #text(22pt,sym.diameter):]
    ]
  ) 
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
  
  return page(
    margin: (left: 20mm, right: 20mm, top: 10mm, bottom: 20mm),
    footer: none
  )[
    // setup linguify
    #linguify_set_database(toml("assets/lang.toml"));

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
      columns: (auto, 1fr, auto, auto),
      align: (col, _) => if ( calc.even(col) ) { end } else { auto },
      gutter: 1em,
      linguify("class") + ": ", text(weight: "semibold", class),
      "Schuljahr: ", 
      { 
        if type(dates.gehalten) == datetime {
          let date = dates.gehalten;
          if date.month() < 9 {str(date.year()-1) + "/" + str(date.year())} else { str(date.year()) + "/" + str(date.year()+1) }
        } else { align(bottom,line(length: 3cm))}
      },
      linguify("subject") + ": ", text(weight: "semibold", subject),
      grid.cell(colspan: 2, align: start)[#checkbox() SA #h(1em) #checkbox() KA \ #checkbox() #field(none)]
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
