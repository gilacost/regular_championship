defmodule RegularChampionship.LeagueSeasonPairList do
  @moduledoc """
  This is a list of results
  """
  defstruct [:data]

  def build_struct!(league_season_pair_list) do
    struct!(
      __MODULE__,
      data: league_season_pair_list
    )
  end
end
