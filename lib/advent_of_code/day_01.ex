defmodule AdventOfCode.Day01 do
   
  def get_elf_items() do 
    input = AdventOfCode.Input.get!(1)
    items = input |> String.split("\n")

    items = items |> Enum.reverse() |> tl() |> Enum.reverse()   # Enum.filter(items, fn l -> !String.contains?(l, "Part 1 Results") end)

    elf_items = items 
      |> Enum.chunk_by(fn i -> i == "" end) 
      |> Enum.filter(fn i -> List.first(i) != "" end) 
      |> Enum.map(
      fn items ->
          Enum.map(items, fn item -> String.to_integer(item) end)
      end
    )
    elf_items

  end

  def part1(_args) do

    elf_items = get_elf_items()
    elf_totals = elf_items 
      |> Enum.map(
       fn items -> Enum.sum(items) end
      )
    max = Enum.max(elf_totals)
    IO.puts max
  end

  def part2(_args) do
    elf_items = get_elf_items()
    elf_totals = elf_items 
      |> Enum.map(
       fn items -> Enum.sum(items) end
      )
    top_3 = elf_totals 
      |> Enum.sort() 
      |> Enum.reverse
      |> Enum.take(3)
      |> Enum.sum
  
    IO.puts "Top 3"
    IO.puts top_3

  end
end
