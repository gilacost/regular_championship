defmodule RegularChampionship.Match do
  @moduledoc """
  This struct defines the columns that will be parsed from the CSV
  """
  defstruct [
    :day,
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
end
