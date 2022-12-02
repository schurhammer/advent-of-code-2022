#!/bin/bash

cookie=`cat .cookie`

n=`printf %02d $1`
x=`echo "$n" | sed "s/^0*//"`

if [ ! -f "input/day_$n" ]; then
  echo "Downloading input/day_$n"
  curl --header "cookie: $cookie" \
  "https://adventofcode.com/2022/day/$x/input" \
  | install -D "/dev/stdin" "input/day_$n"
else
  echo "input/day_$n already exists"
fi

if [ ! -f "src/day_$n.gleam" ]; then
  echo "Generating src/day_$n.gleam"
  cat "src/day_xx.template" \
  | sed "s/%N%/$n/g" \
  > "src/day_$n.gleam"
else
  echo "src/day_$n.gleam already exists"
fi

if [ ! -f "test/day_${n}_test.gleam" ]; then
  echo "Generating test/day_${n}_test.gleam"
  cat "test/day_xx_test.template" \
  | sed "s/%N%/$n/g" \
  > "test/day_${n}_test.gleam"
else
  echo "test/day_${n}_test.gleam already exists"
fi

echo "updating src/aoc2022.gleam"
cat "src/aoc2022.template" \
  | sed "s/%N%/$n/g" \
  > "src/aoc2022.gleam"

echo "Done"
