defmodule RegularChampionship.Result do
  @moduledoc """
  This struct defines the columns that will be parsed from each of the CSV
  rows
  """
  defstruct [
    :id,
    :div,
    :season,
    :date,
    :home_team,
    :away_team,
    :fthg,
    :ftag,
    :ftr,
    :hthg,
    :htag,
    :htr
  ]

  def build_struct!(
        {:ok, [id, div, season, date, home_team, away_team, fthg, ftag, ftr, hthg, htag, htr]}
      ) do
    struct!(
      __MODULE__,
      id: parse_int(id),
      div: div,
      season: parse_int(season),
      date: date,
      home_team: home_team,
      away_team: away_team,
      fthg: parse_int(fthg),
      ftag: parse_int(ftag),
      ftr: ftr,
      hthg: parse_int(hthg),
      htag: parse_int(htag),
      htr: htr
    )
  end

  def build_struct!({:error, message}), do: raise(message)

  defp parse_int(binary) do
    binary
    |> Integer.parse()
    |> case do
      :error -> 0
      {int, ""} -> int
    end
  end
end
