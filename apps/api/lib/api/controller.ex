defmodule Api.Controller do
  alias RegularChampionship.{Repo, ResultList, NotFound}
  import Plug.Conn, only: [assign: 3]

  def league_season(conn) do
    response_data = Repo.league_season_pairs()
    respond_ok(conn, response_data)
  end

  def results(%{params: %{"league" => league, "season" => season}} = conn) do
    league
    |> Repo.results(season)
    |> case do
      %ResultList{data: []} ->
        respond_not_found(conn, "no season #{season} for league: #{league}")

      resp_data ->
        respond_ok(conn, resp_data)
    end
  end

  def respond_not_found(conn, message) do
    conn
    |> assign(:resp_code, 404)
    |> assign(:resp_data, %NotFound{message: message})
  end

  defp respond_ok(conn, resp_data) do
    conn
    |> assign(:resp_code, 200)
    |> assign(:resp_data, resp_data)
  end
end
