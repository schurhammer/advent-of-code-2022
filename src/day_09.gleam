import gleam/erlang/file
import gleam/int
import gleam/list
import gleam/string
import gleam/map

fn move_tail(head, tail) {
  let #(hx, hy) = head
  let #(tx, ty) = tail
  let dx = hx - tx
  let dy = hy - ty
  case dx, dy {
    2, 2 -> #(hx - 1, hy - 1)
    2, -2 -> #(hx - 1, hy + 1)
    -2, -2 -> #(hx + 1, hy + 1)
    -2, 2 -> #(hx + 1, hy - 1)
    2, _ -> #(hx - 1, hy)
    -2, _ -> #(hx + 1, hy)
    _, 2 -> #(hx, hy - 1)
    _, -2 -> #(hx, hy + 1)
    _, _ -> tail
  }
}

fn move_tails(head, tails) {
  case tails {
    [] -> []
    [x, ..xs] -> {
      let tail = move_tail(head, x)
      [tail, ..move_tails(tail, xs)]
    }
  }
}

fn step(d, head, tails) {
  let #(hx, hy) = head
  let head = case d {
    "R" -> #(hx + 1, hy)
    "L" -> #(hx - 1, hy)
    "D" -> #(hx, hy + 1)
    "U" -> #(hx, hy - 1)
  }
  #(head, move_tails(head, tails))
}

fn steps(in, head, tails, visited) {
  case in {
    [] -> visited
    [#(_, 0), ..xs] -> steps(xs, head, tails, visited)
    [#(d, n), ..xs] -> {
      let #(head, tails) = step(d, head, tails)
      assert Ok(last) = list.last(tails)
      let visited = map.insert(visited, last, True)
      steps([#(d, n - 1), ..xs], head, tails, visited)
    }
  }
}

fn run(input, knots) {
  let head = #(0, 0)
  let tails = list.repeat(#(0, 0), knots - 1)
  assert Ok(last) = list.last(tails)
  let visited = map.new()
  let visited = map.insert(visited, last, True)
  input
  |> string.split("\n")
  |> list.map(fn(line) {
    assert [d, n] = string.split(line, " ")
    assert Ok(n) = int.parse(n)
    #(d, n)
  })
  |> steps(head, tails, visited)
  |> map.size()
}

pub fn main() {
  assert Ok(input) = file.read("input/day_09")
  let input = string.trim(input)
  [run(input, 2), run(input, 10)]
}
