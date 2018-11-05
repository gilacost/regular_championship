defmodule Api.Results do
  @moduledoc """
  The Results context.
  """

  alias Api.Results.Season
  alias Api.Results.League

  @doc """
  Returns the list of seasons.

  ## Examples

      iex> list_seasons()
      [%Season{}, ...]

  """
  def list_seasons do
    Season.list_all()
  end

  alias Api.Results.League
  alias RegularChampionship.Repo

  @doc """
  Returns the list of leagues.

  ## Examples

      iex> list_leagues()
      [%League{}, ...]

  """
  def list_leagues do
    League.list_all()
  end

  @doc """
  Gets a single league.

  Raises `Ecto.NoResultsError` if the League does not exist.

  ## Examples


      iex> league_season_pair("regional","198788", :json)
      []

  """
  def league_season_pair(division, season),
    do: GenServer.call(Repo, {:league_season_pair, [division, season]})
end
