defmodule ApiWeb.SeasonView do
  use ApiWeb, :view
  alias ApiWeb.SeasonView

  def render("index.json", %{seasons: seasons}) do
    inspect(seasons)
    %{data: render_many(seasons, SeasonView, "season.json")}
  end

  def render("season.json", %{season: season}) do
    season
  end
end
