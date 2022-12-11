import gleam/erlang/file
import gleam/int
import gleam/list
import gleam/string

pub type Operand {
  Num(x: Int)
  Old
}

pub type Operation {
  Operation(operator: String, operand: Operand)
}

pub type Monkey {
  Monkey(
    id: Int,
    items: List(Int),
    op: Operation,
    test: Int,
    if_true: Int,
    if_false: Int,
    ins: Int,
  )
}

fn parse_items(items) {
  string.split(items, ", ")
  |> list.map(fn(x) {
    assert Ok(x) = int.parse(x)
    x
  })
}

fn parse_op(op) {
  assert [op, b] = string.split(op, " ")
  let b = case b {
    "old" -> Old
    x -> {
      assert Ok(x) = int.parse(x)
      Num(x)
    }
  }
  Operation(op, b)
}

fn parse_monkey(input) {
  assert [
    "Monkey " <> id,
    "  Starting items: " <> items,
    "  Operation: new = old " <> op,
    "  Test: divisible by " <> test,
    "    If true: throw to monkey " <> if_true,
    "    If false: throw to monkey " <> if_false,
  ] = string.split(input, "\n")
  assert Ok(id) = int.parse(string.replace(id, ":", ""))
  let items = parse_items(items)
  let op = parse_op(op)
  assert Ok(test) = int.parse(test)
  assert Ok(if_true) = int.parse(if_true)
  assert Ok(if_false) = int.parse(if_false)
  Monkey(id, items, op, test, if_true, if_false, 0)
}

fn parse(input) {
  input
  |> string.split("\n\n")
  |> list.map(parse_monkey)
}

fn apply_operator(operator, a, b) {
  case operator {
    "+" -> a + b
    "*" -> a * b
  }
}

fn get(monks: List(Monkey), id: Int) {
  list.find(monks, fn(x) { x.id == id })
}

fn set(monks: List(Monkey), id: Int, to: Monkey) {
  use monk <- list.map(monks)
  case monk.id == id {
    True -> to
    False -> monk
  }
}

fn inspect_and_throw(monks: List(Monkey), from, mod, div) {
  assert Ok(from_monk) = get(monks, from)
  assert [item, ..rest] = from_monk.items
  let ins = from_monk.ins + 1
  let monks = set(monks, from, Monkey(..from_monk, items: rest, ins: ins))
  let item = case from_monk.op {
    Operation(op, Old) -> apply_operator(op, item, item)
    Operation(op, Num(x)) -> apply_operator(op, item, x)
  }
  let item = item / div % mod
  let to = case item % from_monk.test {
    0 -> from_monk.if_true
    _ -> from_monk.if_false
  }
  assert Ok(to_monk) = get(monks, to)
  let to_items = list.append(to_monk.items, [item])
  set(monks, to, Monkey(..to_monk, items: to_items))
}

fn turn(monks: List(Monkey), from, mod, div) {
  assert Ok(from_monk) = get(monks, from)
  case from_monk.items {
    [] -> monks
    _ -> {
      let monks = inspect_and_throw(monks, from, mod, div)
      turn(monks, from, mod, div)
    }
  }
}

fn round(monks: List(Monkey), mod, div) {
  list.fold(monks, monks, fn(monks, monk) { turn(monks, monk.id, mod, div) })
}

fn monkey_business(monks: List(Monkey)) {
  monks
  |> list.map(fn(monk) { monk.ins })
  |> list.sort(fn(a, b) { int.compare(b, a) })
  |> list.take(2)
  |> list.fold(1, fn(a, b) { a * b })
}

fn find_modulo(monks: List(Monkey)) {
  monks
  |> list.map(fn(monk) { monk.test })
  |> list.fold(1, fn(a, b) { a * b })
}

fn run(input, n, div) {
  let init = parse(input)
  let mod = find_modulo(init)
  let result =
    list.range(1, n)
    |> list.fold(init, fn(monks, _) { round(monks, mod, div) })
  monkey_business(result)
}

pub fn main() {
  assert Ok(input) = file.read("input/day_11")
  let input = string.trim(input)
  [run(input, 20, 3), run(input, 1000, 1)]
}
