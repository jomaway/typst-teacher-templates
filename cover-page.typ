#import "utils.typ": checkbox, lines, field

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
  line-color: luma(70),
) = {
  // Header Box
  let header-box = {
    box(
      width: 100%, 
      stroke: luma(70), 
      inset: 1em, 
      radius: 3pt
    )[
      #align(center)[#text(22pt)[Deckblatt Leistungsnachweis]]
    ]
  }

  // Date Field
  let date-field(date, label) = {
    box(
      stroke: (bottom: 1pt), 
      width: 3.5cm, 
      inset: (bottom: 3pt)
    )[
      #align(center)[
        #if type(date) == datetime { 
          date.display("[day].[month].[year]") 
        } else {date}
      ]
      #place(end,dy: 7pt)[#text(10pt, label)]
    ]
  } // end date-field

  // Signature field
  let signature-field(label) = {
    box(
      stroke: (bottom: 0.5pt), 
      width: 6cm, 
      height: 1cm
    )[
      #place(bottom + end,dy: 11pt)[#text(10pt, label)]
    ] 
  }
 
  return page(
    margin: (left: 20mm, right: 20mm, top: 10mm, bottom: 20mm),
    footer: none
  )[
    #show line: set line(stroke: line-color)
    #set text(16pt, font:"New Computer Modern Sans" )

    // header - title
    #header-box

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
      [Fehlende SchülerInnen: #box(width: 1fr)[#align(end)[ Anzahl Teilnehmer: #box(width:1.5cm, stroke: (bottom: 0.5pt + line-color))]]],
      line(length: 100%),
      line(length: 100%),
    )


    // Dates
    Datum: #h(1fr)
    #field("gehalten", value: dates.gehalten.display("[day].[month].[year]")) #h(1fr) 
    #field("zurückgegeben") #h(1fr) 
    #field("eingetragen")
    
    #v(0.5cm)

    // Grading table uses the ihk grading distribution
    
      #let max_points = total_points;
      #let dist = range(max_points * 10, step: 5).map(el => {
        let points = el*0.1;
        let percent = calc.round(points/max_points, digits:2);
        let grade = if percent < 0.3 {6} else if percent < 0.5 {5} else if percent < 0.67 {4} else if percent < 0.81 {3} else if percent < 0.92 {2} else {1}
        return (points, grade)
      })
      #dist.push((max_points, 1));

      // Using a second table in a block for colspan effect
      #block[
        #show table: set block(below: 0pt)
        #table(
          columns: (2cm, 1fr, 5cm),
          inset: 0.7em,
          align: center,
          "Note", "Punkteschlüssel", "Anzahl",
          ..range(6).map(el => ([#{el + 1}],align(start)[#h(2cm,)
            von #box(width: 2.2em, inset: (left: 4pt))[#dist.find(val => val.at(1) ==  el+1).at(0)]
            bis #box(width: 2.2em, inset: (left: 4pt))[#dist.rev().find(val => val.at(1) == el+1).at(0)]
          ], "")).flatten(),
        )
        #table(
          columns: (1fr, 5cm),
          inset: 0.7em,
          [#align(end)[Notendurchschnitt #text(22pt,sym.diameter):]], "",
        )
      ]
    

    // Comment
    #grid(
      columns: (auto),
      row-gutter: 1cm,
      smallcaps("Bemerkung:"),
      if (comment != none) {comment} else {
          stack(dir:ttb, spacing: 1.2cm, line(length: 100%), line(length: 100%))
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
  