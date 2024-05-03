#import "@preview/linguify:0.3.1": *

// load linguify database file
#let ling_db = toml("assets/lang.toml")

#let ling(key) = linguify(key, from: ling_db)