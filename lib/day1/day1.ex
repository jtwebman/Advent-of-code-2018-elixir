defmodule AOC.Day1 do
  def part1() do
    Path.expand('./lib/day1/input.txt')
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(0, &(&1 + &2))
  end

  def part2() do
    list =
      Path.expand('./lib/day1/input.txt')
      |> File.read!()
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)

    find_repeat(list, list, %{}, 0)
  end

  def find_repeat(list, [], seen, sum) do
    find_repeat(list, list, seen, sum)
  end

  def find_repeat(list, [next | rest], seen, sum) do
    new_value = next + sum

    case Map.has_key?(seen, new_value) do
      true -> new_value
      _ -> find_repeat(list, rest, Map.put(seen, new_value, true), new_value)
    end
  end
end
