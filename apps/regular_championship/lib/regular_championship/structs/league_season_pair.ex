defmodule RegularChampionship.LeagueSeasonPair do
  @moduledoc """
  This struct defines the keys of a league season pair.
  """
  defstruct [
    :div,
    :season
  ]

  def build!([div, season]) do
    struct!(
      __MODULE__,
      div: div,
      season: season
    )
  end
end
