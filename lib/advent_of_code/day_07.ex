defmodule AdventOfCode.Day07 do
  def parse_input do
    input =
      AdventOfCode.Input.get!(7)
      |> String.split("\n")

    Enum.reduce(input, %{fs: %{}, path: []}, fn l, acc ->
      cond do
        String.starts_with?(l, "$ cd") and not String.match?(l, ~r/\.\.$/) ->
          current_dir = String.split(l, " ") |> Enum.at(2)
          new_path = Enum.concat(acc.path, [current_dir])

          Map.put(acc, :path, new_path)
          |> put_in([:fs | new_path], %{children: [], name: List.last(new_path)})

        String.starts_with?(l, "$ cd") and String.match?(l, ~r/\.\.$/) ->
          new_path = acc.path |> Enum.reverse() |> Enum.drop(1) |> Enum.reverse()
          Map.put(acc, :path, new_path)

        String.match?(l, ~r/^\d/) ->
          parent_dir = get_in(acc.fs, acc.path)
          [size, name] = String.split(l, " ")

          parent_dir =
            %{
              parent_dir
              | children: [%{name: name, size: size |> String.to_integer()} | parent_dir.children]
            }
            |> Map.put(:name, List.last(acc.path))

          put_in(acc, [:fs | acc.path], parent_dir)

        true ->
          acc
      end
    end)
    |> Map.get(:fs)
  end

  def child_directories(dir) do
    Map.keys(dir)
    |> Enum.filter(fn k -> k != :children && k != :name end)
    |> Enum.map(fn k -> Map.get(dir, k) end)
  end

  def calc_size(dir, size) do
    child_directories = child_directories(dir)

    child_files = dir.children
    direct_size = Enum.reduce(child_files, 0, fn c, acc -> acc + c.size end)
    total_size = direct_size + size

    case child_directories do
      [] ->
        total_size

      _ ->
        total_size +
          (Enum.map(child_directories, fn d -> calc_size(d, 0) end)
           |> Enum.reduce(fn x, acc -> x + acc end))
    end
  end

  def get_directories(dir, filter_fn, valid_dirs \\ []) do
    dir_size = calc_size(dir, 0)
    child_directories = child_directories(dir)

    case child_directories do
      [] ->
        if filter_fn.(dir_size) do
          [{dir.name, dir_size}]
        else
          []
        end

      _ ->
        new_dir =
          if filter_fn.(dir_size) do
            {dir.name, dir_size}
          else
            []
          end

        new_valid_dirs =
          [new_dir | valid_dirs] ++
            Enum.flat_map(child_directories, fn c -> get_directories(c, filter_fn, valid_dirs) end)

        new_valid_dirs
    end
  end

  def part1(_args) do
    file_struct = parse_input()
    less_than_100k = fn dir_size -> dir_size <= 100_000 end

    dirs =
      get_directories(Map.get(file_struct, "/"), less_than_100k)
      |> Enum.filter(fn x -> x != [] end)

    dirs |> Enum.reduce(0, fn x, acc -> elem(x, 1) + acc end)
  end

  def part2(_args) do
    file_struct = parse_input()
    total_size = calc_size(Map.get(file_struct, "/"), 0)

    filter_fn = fn _x -> true end
    dirs = get_directories(Map.get(file_struct, "/"), filter_fn)

    Enum.filter(dirs, fn el ->
      available_space = 70_000_000 - (total_size - elem(el, 1))
      available_space >= 30_000_000
    end)
    |> Enum.sort_by(&elem(&1, 1))
  end
end
