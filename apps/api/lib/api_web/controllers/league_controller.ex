defmodule ApiWeb.LeagueController do
  use ApiWeb, :controller

  alias Api.Results

  action_fallback(ApiWeb.FallbackController)

  def index(conn, _params) do
    leagues = Results.list_leagues()
    render(conn, "index.json", leagues: leagues)
  end

  def league_season_pair(conn, %{"league" => league, "season" => season}) do
    results = Results.league_season_pair!(league, season)

    conn
    |> put_view(ApiWeb.ResultView)
    |> render("results.json", results: results)
  end
end
