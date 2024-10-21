defmodule Conversion do
  @moduledoc """
  Utilities to convert one value into its parts
  """
  @time_units [
    {:microsecond, 1000},
    {:milisecond, 1000},
    {:second, 60},
    {:minute, 60},
    {:hour, 60},
    {:day, nil}
  ]

  def convert(value, units, opts \\ []) do
    min = Keyword.get(opts, :min, nil)
    max = Keyword.get(opts, :max, nil)

    Enum.reduce_while(units, %{rest: value}, fn
      _, %{rest: 0} = result ->
        {:halt, result}

      {unit, nil}, result ->
        {:cont, Map.put(result, unit, result.rest)}

      {^min = ^max = unit, rate}, %{rest: rest} = result ->
        {:halt,
         %{}
         |> Map.put(
           unit,
           rest +
             if round_up?(result) do
               1
             else
               0
             end
         )
         |> Map.put(:rest, div(rest, rate))}

      {^min = unit, rate}, %{rest: rest} = result ->
        {:cont,
         %{}
         |> Map.put(
           unit,
           rem(rest, rate) +
             if round_up?(result) do
               1
             else
               0
             end
         )
         |> Map.put(:rest, div(rest, rate))}

      {^max = unit, _}, %{rest: rest} = result ->
        {:halt,
         result
         |> Map.put(unit, rest)}

      {unit, rate}, %{rest: rest} = result ->
        {:cont,
         result
         |> Map.put(unit, rem(rest, rate))
         |> Map.put(:rest, div(rest, rate))}
    end)
    |> Map.delete(:rest)
  end

  defp round_up?(partial) do
    partial
    |> Map.delete(:rest)
    |> Enum.any?(fn {_, value} ->
      value > 0
    end)
  end

  def convert_micros(micros, opts \\ []), do: convert(micros, @time_units, opts)
  def convert_minutes(micros, opts \\ []), do: convert(micros, Enum.drop(@time_units, 3), opts)

  def minutes_to_string(time, opts \\ [min: :sec, max: :min]) do
    time_map = convert_minutes(time, opts)

    time_units()
    |> Enum.drop(3)
    |> Enum.reduce("", fn unit, acc ->
      if value = Map.get(time_map, unit) do
        value
        |> Cldr.Unit.new!(unit)
        |> Cldr.Unit.to_string!()
      else
        acc
      end
    end)
    |> String.trim()
  end

  def micros_to_string(time, opts \\ [min: :sec, max: :min]) do
    time_map = convert_micros(time, opts)

    time_units()
    |> Enum.reduce("", fn unit, acc ->
      if value = Map.get(time_map, unit) do
        "#{value} #{Atom.to_string(unit)} #{acc}"
      else
        acc
      end
    end)
    |> String.trim()
  end

  def time_units, do: @time_units |> Enum.map(fn {unit, _} -> unit end)
end
