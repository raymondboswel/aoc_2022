defmodule AdventOfCode.Day02 do
  def parse_input() do
    input = AdventOfCode.Input.get!(2)

    input
    |> String.split("\n")
    |> Enum.filter(fn x -> x != "" end)
  end

  def part1(_args) do
    parsed_input = parse_input()

    total =
      Enum.map(parsed_input, fn round -> calc_round(round) end)
      |> Enum.sum()

    IO.puts(total)
  end

  def calc_round(round) do
    player_moves =
      String.split(round, " ")
      |> Enum.map(fn m ->
        cond do
          m == "A" || m == "X" ->
            :rock

          m == "B" || m == "Y" ->
            :paper

          m == "C" || m == "Z" ->
            :scissors
        end
      end)

    outcome = compare_moves(player_moves)
    calc_score(outcome, player_moves)
  end

  def calc_score(outcome, moves) do
    [_, move_b] = moves

    move_score =
      cond do
        move_b == :rock -> 1
        move_b == :paper -> 2
        move_b == :scissors -> 3
      end

    outcome_score =
      cond do
        outcome == :b_loses -> 0
        outcome == :draw -> 3
        outcome == :b_wins -> 6
      end

    move_score + outcome_score
  end

  def compare_moves(moves) do
    [move_a, move_b] = moves

    if(move_a == move_b) do
      :draw
    else
      cond do
        move_a == :rock ->
          cond do
            move_b == :paper -> :b_wins
            move_b == :scissors -> :b_loses
          end

        move_a == :paper ->
          cond do
            move_b == :rock -> :b_loses
            move_b == :scissors -> :b_wins
          end

        move_a == :scissors ->
          cond do
            move_b == :paper -> :b_loses
            move_b == :rock -> :b_wins
          end
      end
    end
  end

  def part2(_args) do
  end
end
