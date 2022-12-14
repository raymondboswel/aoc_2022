defmodule AdventOfCode.Day07 do
  def test_data do
    """
    $ cd /
    $ ls
    dir a
    14848514 b.txt
    8504156 c.dat
    dir d
    $ cd a
    $ ls
    dir e
    29116 f
    2557 g
    62596 h.lst
    $ cd e
    $ ls
    584 i
    $ cd ..
    $ cd ..
    $ cd d
    $ ls
    4060174 j
    8033020 d.log
    5626152 d.ext
    7214296 k
    """
  end

  def parse_input do
    # input = test_data() |> String.split("\n")

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

  def get_directories(dir, valid_dirs \\ []) do
    dir_size = calc_size(dir, 0)
    child_directories = child_directories(dir)

    case child_directories do
      [] ->
        if dir_size <= 100_000 do
          [{dir.name, dir_size}]
        else
          []
        end

      _ ->
        new_dir =
          if dir_size <= 100_000 do
            {dir.name, dir_size}
          else
            []
          end

        new_valid_dirs =
          [new_dir | valid_dirs] ++
            Enum.flat_map(child_directories, fn c -> get_directories(c, valid_dirs) end)

        new_valid_dirs
    end
  end

  def part1(_args) do
    file_struct = parse_input()

    dirs = get_directories(Map.get(file_struct, "/")) |> Enum.filter(fn x -> x != [] end)
    IO.inspect("Result dirs")

    IO.inspect(dirs)
    res = dirs |> Enum.reduce(0, fn x, acc -> elem(x, 1) + acc end)
    IO.inspect(res)
  end

  def part2(_args) do
  end
end

# map = %{
#   "/" => %{
#     "jmtrrp" => %{},
#     "jssn" => %{},
#     "lbrmb" => %{},
#     "pcccp" => 11968
#   }
# }
