#import "@local/schulzeug:0.1.0": studentlist, add_check_column


#set page("a4", margin: 1cm)
#set text(14pt, font:"Rubik", weight: 300)

= Klassenliste

#let data = csv("students.csv")

#{ data = add_check_column(data, title: "Attending") }

#studentlist(
  numbered: true, 
  lines: true,
  tag: "Year 24/25",
  data,
);
