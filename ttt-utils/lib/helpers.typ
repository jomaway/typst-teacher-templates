
/// if value is auto then return other value else return value itself
#let if-auto-then(val, ret) = {
  if (val == auto) {
    ret
  } else {
    val
  }
}

/// decode an input
#let decode-input(name, default: none) = {
  let input = sys.inputs.at(name, default: default)
  if input != none {
    return json.decode(input)
  } else { return none }
}

/// maps an input to an boolean
#let bool-input(name) = {
  let value = json.decode(sys.inputs.at(name, default: "false"))
  assert(type(value) == bool, message: "--input " + name + "=... must be set to true or false if present")
  value
}

// #let push_and_return(a_list, value) = {
//   a_list.push(value)
//   return a_list
// }

// #let increase_last(a_list, value) = {
//   a_list.last() += value
//   return a_list
// }