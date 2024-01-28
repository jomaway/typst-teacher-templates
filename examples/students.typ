#import "@local/schulzeug:0.1.0": studentlist

#let data = csv("students.csv")

#set page("a4", margin: 1cm)
#set text(14pt, font:"Rubik", weight: 300)

= Klassenliste

#studentlist(
  numbered: true, 
  class: "IAV 2425",
  data,
);
