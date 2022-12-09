import gleam/erlang/file
import gleam/int
import gleam/list
import gleam/string

pub type Folder {
  Folder(name: String, files: List(Int), folders: List(Folder))
}

fn parse(input, dir) {
  case input {
    [] -> #([], dir)
    ["$ cd ..", ..xs] -> #(xs, dir)
    ["$ ls", ..xs] | ["dir " <> _, ..xs] -> parse(xs, dir)
    ["$ cd " <> x, ..xs] -> {
      let #(xs, subdir) = parse(xs, Folder(x, [], []))
      parse(xs, Folder(..dir, folders: [subdir, ..dir.folders]))
    }
    [x, ..xs] -> {
      assert [size, _name] = string.split(x, " ")
      assert Ok(size) = int.parse(size)
      parse(xs, Folder(..dir, files: [size, ..dir.files]))
    }
  }
}

fn flatten(dir: Folder) -> List(List(Int)) {
  let sub =
    dir.folders
    |> list.map(flatten)
    |> list.flatten()
  [list.append(dir.files, list.flatten(sub)), ..sub]
}

fn size(dir: Folder) -> Int {
  let sub = list.map(dir.folders, size)
  int.sum(dir.files) + int.sum(sub)
}

fn subdirs(dir: Folder) -> List(Folder) {
  [dir, ..list.flat_map(dir.folders, subdirs)]
}

fn run(input) {
  input
  |> string.split("\n")
  |> parse(Folder("", [], []))
  |> fn(x: #(List(String), Folder)) { x.1 }
  |> flatten()
  |> list.filter(fn(x) { int.sum(x) < 100000 })
  |> list.flatten()
  |> int.sum()
}

fn run2(input) {
  let target = 70000000 - 30000000
  let root =
    input
    |> string.split("\n")
    |> parse(Folder("", [], []))
    |> fn(x: #(List(String), Folder)) { x.1 }
  let root_size = size(root)
  let delete_amount = root_size - target

  assert [ans, ..] =
    root
    |> subdirs()
    |> list.map(size)
    |> list.filter(fn(a) { a >= delete_amount })
    |> list.sort(int.compare)
  ans
}

pub fn main() {
  assert Ok(input) = file.read("input/day_07")
  let input = string.trim(input)
  [run(input), run2(input)]
}
