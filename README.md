# Advent of Code 2022

Advent of Code 2022 written in gleam!

## Scaffold

There is a scaffold script to help you get started with each day of AoC.

How to use it:

1. create a `.cookie` file containing your AoC session cookie, e.g. `session=xxxyyyzzz`
2. run `./scaffold.sh <day number>` to create files for the given day, e.g. `./scaffold.sh 1`

What it does:

1. download the day's input into `input/day_xx`
2. create `src/day_xx.gleam` containing code to load the input
3. create `test/day_xx_test.gleam` containing a dummy test
4. overwrite `src/aoc2022.gleam` to execute the current day's main function (you can run it with the `gleam run` command)

## Quick start

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```
