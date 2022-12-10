import gleam/erlang/file
import gleam/int
import gleam/list
import gleam/string
import gleam/io

fn parse(lines) {
  lines
  |> string.split("\n")
  |> list.flat_map(fn(x) {
    case x {
      "noop" -> [0]
      "addx " <> x -> {
        assert Ok(x) = int.parse(x)
        [0, x]
      }
    }
  })
}

fn run(input) {
  let numbers = parse(input)
  list.map(
    list.range(1, list.length(numbers)),
    fn(i) {
      case { i + 20 } % 40 {
        0 -> i * { 1 + int.sum(list.take(numbers, i - 1)) }
        _ -> 0
      }
    },
  )
  |> int.sum()
}

fn run2(input) {
  let numbers = parse(input)
  list.range(1, list.length(numbers))
  |> list.map(fn(i) {
    let r = 1 + int.sum(list.take(numbers, i - 1))
    case i % 40 - r {
      0 | 1 | 2 -> "#"
      _ -> " "
    }
  })
  |> list.sized_chunk(40)
  |> list.map(string.join(_, ""))
  |> string.join("\n")
}

pub fn main() {
  assert Ok(input) = file.read("input/day_10")
  let input = string.trim(input)
  run2(input)
  |> io.println()
  run(input)
}
