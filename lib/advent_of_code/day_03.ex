defmodule AdventOfCode.Day03 do
  def parse_input do
    input = AdventOfCode.Input.get!(3)

    input
    |> String.split("\n")
    |> Enum.filter(fn x -> x != "" end)
    |> Enum.map(&String.graphemes/1)
  end

  def part1(_args) do
    input = parse_input()

    sack = List.first(input)
    {comp1, comp2} = Enum.split(sack, trunc(length(sack) / 2))

    total =
      Enum.map(input, fn sack ->
        {comp1, comp2} = Enum.split(sack, trunc(length(sack) / 2))

        Enum.filter(comp1, fn item -> Enum.any?(comp2, fn item2 -> item2 == item end) end)
        |> Enum.dedup()
        |> List.first()
        |> letter_to_score()
      end)
      |> Enum.sum()

    IO.inspect(total)
  end

  def letter_to_score(letter) do
    is_upper = String.upcase(letter) == letter
    ascii = letter |> String.to_charlist() |> hd

    if(is_upper) do
      ascii - 38
    else
      ascii - 96
    end
  end

  def part2(_args) do
  end
end
