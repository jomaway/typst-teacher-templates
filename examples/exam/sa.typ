#import "@local/ttt-exam:0.1.0": *
#import components: lines, frame
#import layout: side-by-side

#set text(size: 12pt, font: ("Rubix","Source Sans Pro"), weight: 300, lang: "en")

#let logo = box(height: 2cm, image("logo.jpg", fit: "contain")) 
#let details = toml("details.toml")
#show: exam.with(..details.exam, title: logo_title(logo, details.exam.title));

= Part 1: Free text answers

#question(points: 12)[Short task to do some fancy math calculations.
    #solution(alt:caro(4))[$ pi + x = 7 $]
]

#assignment[
    Test assignment with three sub-questions. 
    #question(points: 3)[This question will give 3 points.
        #placeholder(lines(2))
        #solution[
            - First
            - Second
            - Third
        ]
    ]

    #side-by-side(gutter: 2cm)[
        #question(points: 1)[
            Short question only valid 1 point.

            #solution(alt: lines(1))[quick] 
        ]
    ][
        #question(points: 1)[
            Short question only valid 1 point. 
            #solution[badass] 
            #lines(1)
        ]
    ]

    #with-solution(true)[

        #frame(question[
            Question with solution is only an example and not valid any points.
        
            #pad(x: 1em,solution[This is right?])
        ])
    ]
]


// #include "a1.typ"
= Part 2: Some single and multiple Choice fun.

#include "mc.typ"


= Part 3: Evaluation

#free-text-question(points: 5, area: lines(5))[
    Describe how did you manage?

    #solution[Done.]
]


= Punkteverteilung
#point-table
#h(1fr)
#point-sum-box
