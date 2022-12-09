import gleam/erlang/file
import gleam/int
import gleam/list
import gleam/string

fn parse_line(line) {
  case line {
    [] -> []
    [c, ..rest] -> {
      assert Ok(c) = int.parse(c)
      [c, ..parse_line(rest)]
    }
  }
}

fn reverse_score(line, score_fn) {
  list.reverse(score_fn(list.reverse(line)))
}

fn transpose_score(input, score_fn) {
  list.transpose(list.map(list.transpose(input), score_fn))
}

fn zip4(zip: #(List(a), List(b), List(c), List(d))) {
  let #(a, b, c, d) = zip
  let ab = list.zip(a, b)
  let cd = list.zip(c, d)
  list.zip(ab, cd)
  |> list.map(fn(zip) {
    let #(ab, cd) = zip
    #(ab.0, ab.1, cd.0, cd.1)
  })
}

fn run(
  input,
  score_fn: fn(List(Int)) -> List(a),
  merge_fn: fn(#(a, a, a, a)) -> b,
) {
  let input =
    string.split(input, "\n")
    |> list.map(string.to_graphemes)
    |> list.map(parse_line)

  let r = list.map(input, score_fn)
  let l = list.map(input, reverse_score(_, score_fn))
  let d = transpose_score(input, score_fn)
  let u = transpose_score(input, reverse_score(_, score_fn))

  zip4(#(r, l, d, u))
  |> list.map(zip4)
  |> list.flatten()
  |> list.map(merge_fn)
}

fn do_visible(line) {
  case line {
    [] -> #(-1, [])
    [x, ..rest] -> {
      let #(max, acc) = do_visible(rest)
      #(int.max(x, max), [x > max, ..acc])
    }
  }
}

fn visible(line) {
  do_visible(line).1
}

fn or4(zip: #(Bool, Bool, Bool, Bool)) {
  zip.0 || zip.1 || zip.2 || zip.3
}

fn scenic(line) {
  case line {
    [] -> []
    [x, ..rest] -> {
      let score =
        rest
        |> list.take_while(fn(y) { y < x })
        |> list.length()
      let score = case score < list.length(rest) {
        True -> score + 1
        False -> score
      }
      [score, ..scenic(rest)]
    }
  }
}

fn mul4(zip: #(Int, Int, Int, Int)) {
  zip.0 * zip.1 * zip.2 * zip.3
}

pub fn main() {
  assert Ok(input) = file.read("input/day_08")
  let input = string.trim(input)
  let part1 =
    run(input, visible, or4)
    |> list.filter(fn(x) { x })
    |> list.length()
  let part2 =
    run(input, scenic, mul4)
    |> list.fold(0, int.max)
  [part1, part2]
}
