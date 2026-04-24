#import "../lib/assignments.typ": *
#import "../lib/components.typ": *

#set page(margin: 2cm)
#set text(size: 12pt, font: "Rubik", weight: 300, lang: "de")


#show-solutions

#question(points: auto)[
  First test question.

  #option[A]
  #option(correct:true)[D]
  #option[B]
  #option[C]
]


#question[
  Which is the Symbol for CreativeCommons?

  #options(
    cols: 4,
    shuffle: false,
    sym.copyright,
    sym.copyleft,
    correct(sym.cc),
    sym.CC
  )
]

#question[
  What is your favorite programming language?

  #quick-options[
  - javascript
  + typst
  - python
  - rust
  ]

  #hint[Choose wisely]
]


#question[
  Which is right? #lorem(15)

  #options(
    cols:2,
    correct[This is fucking awesome!!!],
    lorem(33),
    correct[
      ```py
      x = "hello"
      print(x)
      exit(1)
      ```
    ],
    ```py
    #What the fuck goes wrong
    x = 5
    list = [true, false, True, False, "True", "False", "true", "false"]
    ```,
  )
]

  #question[
      Um zu verhindern, dass ungültige Werte eingegeben werden soll der Verbrauch positiv sein und die Außentemperatur zwischen -30 °C und 50 °C liegen.

      Welche der folgenden Bedingungen würde dies sicherstellen?

      #quick-options[
      + `if verbrauch > 0 and temperatur >= -30 and temperatur <= 50:`
      - `if verbrauch > 0 or (temperatur >= -30 and temperatur <= 50):`
      - `if verbrauch > 0 and (temperatur >= -30 or temperatur <= 50):`
      - `if verbrauch > 0 and temperatur >= -30 or temperatur <= 50:`
      ]
  ]
