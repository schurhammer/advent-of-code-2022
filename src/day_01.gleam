import gleam/bit_string
import gleam/erlang/file
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/result
import gleam/string

fn run(input, n) {
  input
  |> string.split("\n\n")
  |> list.map(string.split(_, "\n"))
  |> list.map(list.map(_, fn(x) {
    assert Ok(n) = int.parse(x)
    n
  }))
  |> list.map(int.sum)
  |> list.sort(int.compare)
  |> list.reverse()
  |> list.take(n)
  |> int.sum()
}

pub fn main() {
  assert Ok(input) = file.read("input/day_01")
  let input = string.trim(input)
  [run(input, 1), run(input, 3)]
}
