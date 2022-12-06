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

  def part2(_args) do
    parsed_input = parse_input()

    total =
      Enum.map(parsed_input, fn round -> calc_score_2(round) end)
      |> Enum.sum()

    IO.puts(total)
  end

  def deduce_move_b(move_a, outcome) do
    if outcome == :draw do
      move_a
    else
      cond do
        move_a == :rock ->
          cond do
            outcome == :b_loses ->
              :scissors

            outcome == :b_wins ->
              :paper
          end

        move_a == :paper ->
          cond do
            outcome == :b_loses ->
              :rock

            outcome == :b_wins ->
              :scissors
          end

        move_a == :scissors ->
          cond do
            outcome == :b_loses ->
              :paper

            outcome == :b_wins ->
              :rock
          end
      end
    end
  end

  def calc_score_2(round) do
    [move_a, outcome] =
      String.split(round, " ")
      |> Enum.map(fn m ->
        cond do
          m == "A" ->
            :rock

          m == "B" ->
            :paper

          m == "C" ->
            :scissors

          m == "X" ->
            :b_loses

          m == "Y" ->
            :draw

          m == "Z" ->
            :b_wins
        end
      end)

    move_b = deduce_move_b(move_a, outcome)
    calc_score(outcome, [move_a, move_b])
  end

  # Calculation for part1
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

  def move_score(move) do
    cond do
      move == :rock -> 1
      move == :paper -> 2
      move == :scissors -> 3
    end
  end

  def outcome_score(outcome) do
    cond do
      outcome == :b_loses -> 0
      outcome == :draw -> 3
      outcome == :b_wins -> 6
    end
  end

  def calc_score(outcome, moves) do
    [_, move_b] = moves
    move_total = move_score(move_b)
    outcome_total = outcome_score(outcome)
    move_total + outcome_total
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
end
