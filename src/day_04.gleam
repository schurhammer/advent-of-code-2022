import gleam/erlang/file
import gleam/int
import gleam/list
import gleam/string

fn part1(a1, a2, b1, b2) {
  case True {
    _ if a1 <= b1 && a2 >= b2 -> 1
    _ if b1 <= a1 && b2 >= a2 -> 1
    _ -> 0
  }
}

fn part2(a1, a2, b1, b2) {
  case True {
    _ if a2 < b1 -> 0
    _ if b2 < a1 -> 0
    _ -> 1
  }
}

fn run(input, pair_score) {
  input
  |> string.split("\n")
  |> list.map(fn(line) {
    assert [a, b] = string.split(line, ",")
    assert [Ok(a1), Ok(a2)] = list.map(string.split(a, "-"), int.parse)
    assert [Ok(b1), Ok(b2)] = list.map(string.split(b, "-"), int.parse)
    pair_score(a1, a2, b1, b2)
  })
  |> int.sum
}

pub fn main() {
  assert Ok(input) = file.read("input/day_04")
  let input = string.trim(input)
  [run(input, part1), run(input, part2)]
}
