import gleam/erlang/file
import gleam/int
import gleam/list
import gleam/map
import gleam/string

fn parse_stacks(stacks) {
  stacks
  |> string.split("\n")
  |> fn(lines) { list.take(lines, list.length(lines) - 1) }
  |> list.map(fn(line) {
    string.concat([line, " "])
    |> string.to_graphemes()
    |> list.sized_chunk(4)
    |> list.map(fn(stack) {
      assert [_, content, _, _] = stack
      content
    })
  })
  |> list.transpose
  |> list.map(list.filter(_, fn(x) { x != " " }))
  |> list.index_map(fn(i, x) { #(i + 1, x) })
  |> map.from_list
}

fn parse_moves(moves) {
  moves
  |> string.trim()
  |> string.split("\n")
  |> list.map(fn(line) {
    assert [_, n, _, from, _, to] = string.split(line, " ")
    assert Ok(n) = int.parse(n)
    assert Ok(from) = int.parse(from)
    assert Ok(to) = int.parse(to)
    #(n, from, to)
  })
}

fn do_move_p1(from, to, stack) {
  assert Ok([f, ..fs]) = map.get(stack, from)
  assert Ok(ts) = map.get(stack, to)
  let stack = map.insert(stack, from, fs)
  let stack = map.insert(stack, to, [f, ..ts])
  stack
}

fn do_moves_p1(moves, stacks) {
  case moves {
    [#(0, _, _), ..rest] -> do_moves_p1(rest, stacks)
    [#(n, f, t), ..rest] ->
      do_moves_p1([#(n - 1, f, t), ..rest], do_move_p1(f, t, stacks))
    [] -> stacks
  }
}

fn do_move_p2(move, stacks) {
  let #(n, from, to) = move
  assert Ok(from_stack) = map.get(stacks, from)
  assert Ok(to_stack) = map.get(stacks, to)
  let stacks = map.insert(stacks, from, list.drop(from_stack, n))
  let stacks =
    map.insert(stacks, to, list.append(list.take(from_stack, n), to_stack))
  stacks
}

fn do_moves_p2(moves, stacks) {
  case moves {
    [m, ..rest] -> do_moves_p2(rest, do_move_p2(m, stacks))
    [] -> stacks
  }
}

fn top_of_stacks(stacks) {
  map.to_list(stacks)
  |> list.sort(fn(a, b) { int.compare(a.0, b.0) })
  |> list.map(fn(a) {
    assert [top, ..] = a.1
    top
  })
  |> string.join("")
}

fn run(input) {
  assert [stacks, moves] = string.split(input, "\n\n")
  let stacks = parse_stacks(stacks)
  let moves = parse_moves(moves)
  [
    top_of_stacks(do_moves_p1(moves, stacks)),
    top_of_stacks(do_moves_p2(moves, stacks)),
  ]
}

pub fn main() {
  assert Ok(input) = file.read("input/day_05")
  run(input)
}
