defmodule ApiWeb.LeagueView do
  use ApiWeb, :view
  alias ApiWeb.LeagueView
  alias ApiWeb.ResultView
  # alias RegularChampionship.Match

  def render("results.json", %{results: results}) do
    %{data: render_many(results, LeagueView, "result.json")}
  end

  def render("result.json", %{result: result}) do
    result
  end

  def render("index.json", %{leagues: leagues}) do
    %{data: render_many(leagues, ResultView, "league.json")}
  end

  def render("league.json", %{league: league}) do
    league
  end
end
