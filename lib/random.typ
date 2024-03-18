#let lcg(seed, m: 100) = {
  assert(seed >= 0 and seed < calc.pow(2, 32))
  let a = 17  
  let c = 43

  calc.rem((a * seed + c),m)
}

#let hash(value, seed) = {
  array(bytes(repr(value))).fold(seed, (a,b) => (a.bit-lshift(1)).bit-xor(b))
}

#let shuffle(arr, seed: auto) = arr.sorted(key: it => {
  let now = datetime.today()
  let rand = if (seed == auto) { int(now.year() + now.month() * 256 * now.day() * 65535) } else { seed }
  hash(it,rand)
})

