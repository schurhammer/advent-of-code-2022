import gleam/bit_string
import gleam/erlang/file
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/result
import gleam/string
import gleam/set

fn priority(i) {
  case bit_string.from_string(i) {
    <<x:int>> if x >= 97 -> x - 97 + 1
    <<x:int>> if x < 97 -> x - 65 + 27
  }
}

fn run(input) {
  string.split(input, "\n")
  |> list.map(fn(line) {
    let bag = string.to_graphemes(line)
    let len = list.length(bag)
    let a = set.from_list(list.take(bag, len / 2))
    let b = set.from_list(list.drop(bag, len / 2))
    assert [x] =
      set.intersection(a, b)
      |> set.to_list
      |> list.map(priority)
    x
  })
  |> int.sum
}

fn run2(input) {
  string.split(input, "\n")
  |> list.map(string.to_graphemes)
  |> list.sized_chunk(3)
  |> list.map(fn(group) {
    assert [a, b, c] = group
    let a = set.from_list(a)
    let b = set.from_list(b)
    let c = set.from_list(c)
    let in =
      a
      |> set.intersection(b)
      |> set.intersection(c)
    let [badge] = set.to_list(in)
    priority(badge)
  })
  |> int.sum
}

pub fn main() {
  assert Ok(input) = file.read("input/day_03")
  let input = string.trim(input)
  [run(input), run2(input)]
}
