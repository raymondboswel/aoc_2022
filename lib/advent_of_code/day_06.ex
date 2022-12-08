defmodule AdventOfCode.Day06 do
  def parse_input do
    input = AdventOfCode.Input.get!(6)
    input |> String.graphemes()
  end

  def part1(_args) do
    input = parse_input()

    start_of_x(input, 4)
  end

  def part2(_args) do
    input = parse_input()
    start_of_x(input, 14)
  end

  def start_of_x(input, uniq_seq_length) do
    Enum.reduce_while(input, {[], 0}, fn x, {acc, offset} ->
      enough_data = length(acc) >= uniq_seq_length

      if(enough_data) do
        offset_list =
          acc
          |> Enum.reverse()
          |> Enum.drop(offset - uniq_seq_length)

        last_four = offset_list |> Enum.take(uniq_seq_length)
        all_uniq = Enum.uniq(last_four) |> length() == uniq_seq_length

        if all_uniq == true do
          {:halt, acc}
        else
          {:cont, {[x | acc], offset + 1}}
        end
      else
        {:cont, {[x | acc], offset + 1}}
      end
    end)
    |> length()
  end
end
