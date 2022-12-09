import gleam/erlang/file
import gleam/list
import gleam/string
import gleam/set

fn n_distinct(l, n) {
  let x = list.take(l, n)
  let y = set.from_list(x)
  let x = list.length(x)
  let y = set.size(y)
  x == n && y == n
}

fn jump_to_start(letters, n) {
  case letters {
    [] -> []
    _ ->
      case n_distinct(letters, n) {
        True -> list.drop(letters, n)
        False -> jump_to_start(list.drop(letters, 1), n)
      }
  }
}

fn run(input, n) {
  let input = string.to_graphemes(input)
  let start = jump_to_start(input, n)
  list.length(input) - list.length(start)
}

pub fn main() {
  assert Ok(input) = file.read("input/day_06")
  let input = string.trim(input)
  [run(input, 4), run(input, 14)]
}
