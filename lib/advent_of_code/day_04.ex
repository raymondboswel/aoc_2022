defmodule AdventOfCode.Day04 do
  def parse_input do
    input = AdventOfCode.Input.get!(4)

    input
    |> String.split("\n")
    |> Enum.filter(fn x -> x != "" end)
    |> Enum.map(fn line ->
      String.split(line, ",")
      |> Enum.map(fn range ->
        String.split(range, "-")
        |> Enum.map(fn s_id -> String.to_integer(s_id) end)
      end)
    end)
  end

  def part1(_args) do
    input = parse_input()

    total =
      input
      |> Enum.filter(fn elf_pair ->
        [elf_a, elf_b] = elf_pair
        contains(elf_a, elf_b)
      end)

    length(total)
  end

  def contains(p1, p2) do
    [p1_start, p1_end] = p1
    [p2_start, p2_end] = p2

    cond do
      p1_start >= p2_start && p1_end <= p2_end ->
        true

      p2_start >= p1_start && p2_end <= p1_end ->
        true

      true ->
        false
    end
  end

  def overlaps(p1, p2) do
    [p1_start, p1_end] = p1
    [p2_start, p2_end] = p2

    cond do
      p2_start <= p1_end && p2_end >= p1_end ->
        true

      p2_start <= p1_start && p2_end >= p1_start ->
        true

      true ->
        false
    end
  end

  def part2(_args) do
    input = parse_input()

    total =
      input
      |> Enum.filter(fn elf_pair ->
        [elf_a, elf_b] = elf_pair
        overlaps(elf_a, elf_b) || contains(elf_a, elf_b)
      end)

    IO.inspect(total, charlists: :as_lists)

    length(total)
  end
end
