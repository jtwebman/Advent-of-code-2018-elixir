defmodule AOC.Day2 do
  def part1() do
    {twice, three} =
      Path.expand('./lib/day2/input.txt')
      |> File.read!()
      |> String.split("\n")
      |> Enum.reduce({0, 0}, &count_repeats/2)

    twice * three
  end

  def count_repeats(text, {twice, three}) do
    {line_twice, line_three} = char_repeats(text)
    {twice + line_twice, three + line_three}
  end

  def char_repeats(test) do
    test
    |> String.split("", trim: true)
    |> Enum.reduce(%{}, fn x, acc ->
      {_, new_acc} =
        Map.get_and_update(acc, x, fn current_value ->
          case current_value do
            nil -> {current_value, 1}
            _ -> {current_value, current_value + 1}
          end
        end)

      new_acc
    end)
    |> Enum.reduce({0, 0}, fn {_, value}, {twice, three} ->
      case value do
        3 -> {twice, 1}
        2 -> {1, three}
        _ -> {twice, three}
      end
    end)
  end

  def part2() do
    list =
      Path.expand('./lib/day2/input.txt')
      |> File.read!()
      |> String.split("\n")
      |> Enum.map(&String.to_charlist(&1))

    check_code(list, list) |> in_common([])
  end

  def check_code(_, []) do
    {nil, nil}
  end

  def check_code(list, [next | rest]) do
    case check_code_count(list, next) do
      {1, found} -> {next, found}
      _ -> check_code(list, rest)
    end
  end

  def check_code_count(list, check) do
    Enum.reduce_while(list, {0, nil}, fn x, {count, found} ->
      case {has_small_diff(check, x, 0), count} do
        {true, 0} -> {:cont, {1, x}}
        {true, 1} -> {:halt, {2, x}}
        _ -> {:cont, {count, found}}
      end
    end)
  end

  def has_small_diff(_, _, diff) when diff > 1 do
    false
  end

  def has_small_diff([], [], diff) do
    case diff do
      1 -> true
      _ -> false
    end
  end

  def has_small_diff([next1 | rest1], [next2 | rest2], diff) do
    diff_char = next1 != next2

    case {diff_char, diff} do
      {true, 1} -> false
      {true, 0} -> has_small_diff(rest1, rest2, 1)
      _ -> has_small_diff(rest1, rest2, diff)
    end
  end

  def in_common({[], []}, common) do
    common
  end

  def in_common({[next1 | rest1], [next2 | rest2]}, common) do
    case next1 == next2 do
      true -> in_common({rest1, rest2}, common ++ [next1])
      _ -> in_common({rest1, rest2}, common)
    end
  end
end
