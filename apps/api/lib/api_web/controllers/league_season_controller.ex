defmodule ApiWeb.LeagueSeasonController do
  use ApiWeb, :controller

  alias Api.Results

  action_fallback(ApiWeb.FallbackController)

  def index(conn, %{"league" => league, "season" => season}) do
    results = Results.league_season_pair(league, season)

    render(conn, "results.json", results: results)
  end
end
