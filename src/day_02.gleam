import gleam/bit_string
import gleam/erlang/file
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/result
import gleam/string

pub type Shape {
  Rock
  Paper
  Scissors
}

pub type Result {
  Win
  Draw
  Loose
}

fn parse_op(x) {
  case x {
    "A" -> Rock
    "B" -> Paper
    "C" -> Scissors
  }
}

fn parse_me(x) {
  case x {
    "X" -> Rock
    "Y" -> Paper
    "Z" -> Scissors
  }
}

fn parse_me2(x) {
  case x {
    "X" -> Loose
    "Y" -> Draw
    "Z" -> Win
  }
}

fn run(input) {
  input
  |> string.split("\n")
  |> list.map(fn(x) {
    case string.split(x, " ") {
      [op, me] -> game_result_score(parse_op(op), parse_me(me))
    }
  })
  |> int.sum
}

fn run2(input) {
  input
  |> string.split("\n")
  |> list.map(fn(x) {
    case string.split(x, " ") {
      [op, me] -> game_result_score2(parse_op(op), parse_me2(me))
    }
  })
  |> int.sum
}

fn game_result_score(op, me) {
  case op, me {
    Rock, Rock -> 3 + 1
    Rock, Paper -> 6 + 2
    Rock, Scissors -> 0 + 3
    Paper, Rock -> 0 + 1
    Paper, Paper -> 3 + 2
    Paper, Scissors -> 6 + 3
    Scissors, Rock -> 6 + 1
    Scissors, Paper -> 0 + 2
    Scissors, Scissors -> 3 + 3
  }
}

fn game_result_score2(op, me) {
  case op, me {
    Rock, Win -> 6 + 2
    Rock, Draw -> 3 + 1
    Rock, Loose -> 0 + 3
    Paper, Win -> 6 + 3
    Paper, Draw -> 3 + 2
    Paper, Loose -> 0 + 1
    Scissors, Win -> 6 + 1
    Scissors, Draw -> 3 + 3
    Scissors, Loose -> 0 + 2
  }
}

pub fn main() {
  assert Ok(input) = file.read("input/day_02")
  let input = string.trim(input)
  [run(input), run2(input)]
}
