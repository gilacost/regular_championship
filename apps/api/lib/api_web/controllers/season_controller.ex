defmodule ApiWeb.SeasonController do
  use ApiWeb, :controller

  alias Api.Results

  action_fallback(ApiWeb.FallbackController)

  def index(conn, _params) do
    seasons = Results.list_seasons()

    render(conn, "index.json", seasons: seasons)
  end
end
