defmodule ApiWeb.LeagueSeasonView do
  use ApiWeb, :view
  alias ApiWeb.ResultView

  def render("results.json", %{results: results}) do
    %{data: render_many(results, ResultView, "result.json")}
  end

  def render("result.json", %{result: result}) do
    result
  end
end
