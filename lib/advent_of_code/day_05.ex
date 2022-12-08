defmodule AdventOfCode.Day05 do
  def parse_input do
    input = AdventOfCode.Input.get!(5)

    [raw_crates, raw_procedure] = String.split(input, "\n\n")

    crates_lines =
      raw_crates
      |> String.split("\n")
      |> Enum.reverse()

    stack_index_line =
      crates_lines
      |> hd
      |> String.graphemes()

    stack_indexes =
      stack_index_line
      |> Enum.map(fn i -> {Enum.find_index(stack_index_line, fn el -> el == i end), i} end)

    stack_indexes = Enum.filter(stack_indexes, fn {idx, _stack} -> idx != 0 end)

    stacks =
      crates_lines
      |> tl
      |> Enum.reverse()
      |> Enum.filter(fn x -> x != "" end)
      |> Enum.map(fn line ->
        line |> String.graphemes()
      end)

    filtered_stacks =
      Enum.map(stack_indexes, fn {idx, _stack} ->
        Enum.map(stacks, fn stack -> Enum.at(stack, idx) end)
      end)

    crates =
      filtered_stacks
      |> Enum.map(fn stack ->
        Enum.filter(stack, fn el -> el != " " end)
        |> Enum.reverse()
      end)

    filtered_lines =
      Regex.replace(~r/[A-Za-z]/i, raw_procedure, "")
      |> String.split("\n")
      |> Enum.map(fn line ->
        String.trim(line)
      end)
      |> Enum.filter(fn l -> l != "" end)

    procedure =
      filtered_lines
      |> Enum.map(fn line ->
        line
        |> String.split("  ")
        |> Enum.map(fn el -> String.to_integer(el) end)
      end)

    {crates, procedure}
  end

  def part1(_args) do
    {crates, procedure} = parse_input()

    Enum.reduce(procedure, crates, fn move, acc ->
      [count, source, destination] = move
      apply_move(acc, count, source - 1, destination - 1, false)
    end)
    |> Enum.map(fn stack -> List.last(stack) end)
    |> Enum.join()
  end

  def apply_move(crates, count, source, destination, multiple) do
    source_stack = Enum.at(crates, source)
    destination_stack = Enum.at(crates, destination)
    dest_crates = source_stack |> Enum.reverse() |> Enum.take(count)

    dest_crates =
      if multiple do
        dest_crates |> Enum.reverse()
      else
        dest_crates
      end

    source_stack = source_stack |> Enum.reverse() |> Enum.drop(count) |> Enum.reverse()
    destination_stack = Enum.concat(destination_stack, dest_crates)

    crates
    |> List.replace_at(source, source_stack)
    |> List.replace_at(destination, destination_stack)
  end

  def part2(_args) do
    {crates, procedure} = parse_input()

    Enum.reduce(procedure, crates, fn move, acc ->
      [count, source, destination] = move
      apply_move(acc, count, source - 1, destination - 1, true)
    end)
    |> Enum.map(fn stack -> List.last(stack) end)
    |> Enum.join()
  end
end
