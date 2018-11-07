defmodule RegularChampionship.LeagueSeasonPair do
  @moduledoc """
  """
  defstruct [
    :div,
    :season
  ]

  def build_struct!([div, season]) do
    struct!(
      __MODULE__,
      div: div,
      season: season
    )
  end
end
