defmodule ApiWeb.LeagueSeasonControllerTest do
  use ApiWeb.ConnCase

  describe "league season results" do
    test "lists all results", %{conn: conn} do
      conn = get(conn, league_season_path(conn, :index, "SP1", "201617"))

      assert json_response(conn, 200)["data"] != []
    end
  end
end
