#import "utils.typ": tag

#let studentlist(data, class: none, numbered: false, rh: auto) = {
    assert(type(numbered) == bool, message: "The numbered parameter can only be [true] or [false].")
    assert(type(rh) == length or rh == auto, message: "The row height (rh) parameter musst be a [length] or [auto]")
    assert(type(class) == str or class == none, message: "The class parameter must be a [str] or [none]")

    let header = data.at(0);
    let body = data.slice(1);

    if (numbered) {
        header.insert(0, "Nr |");
        body = body.enumerate().map(((i, content)) => (str(i+1) + " |", content).flatten());
    }
    
    let cols = range(header.len()).map(_ => auto)
    cols.last() = 1fr;

    header = header.map(col => (strong(col)))
    if (class != none){
        header.last() = [#header.last(); #h(1fr); #tag(class)]
    }

    
    let t = table(
        columns: cols,
        stroke: none,
        rows: rh,
        inset: 0.6em,
        fill: (_, row) => if calc.odd(row) { luma(240) } else { white },
        align: (col,_) => if (numbered and col == 0) {horizon + end} else {horizon + start },
        ..header,
        ..body.flatten()
    )
    
    block(
        stroke: luma(200),
        inset:0pt,
        outset: 0pt,
        radius: 5pt,
        clip: true,
        t
    )
}