defmodule ApiWeb.LeagueControllerTest do
  use ApiWeb.ConnCase

  alias Api.Results
  alias Api.Results.League

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:league) do
    {:ok, league} = Results.create_league(@create_attrs)
    league
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all leagues", %{conn: conn} do
      conn = get conn, league_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create league" do
    test "renders league when data is valid", %{conn: conn} do
      conn = post conn, league_path(conn, :create), league: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, league_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, league_path(conn, :create), league: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update league" do
    setup [:create_league]

    test "renders league when data is valid", %{conn: conn, league: %League{id: id} = league} do
      conn = put conn, league_path(conn, :update, league), league: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, league_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn, league: league} do
      conn = put conn, league_path(conn, :update, league), league: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete league" do
    setup [:create_league]

    test "deletes chosen league", %{conn: conn, league: league} do
      conn = delete conn, league_path(conn, :delete, league)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, league_path(conn, :show, league)
      end
    end
  end

  defp create_league(_) do
    league = fixture(:league)
    {:ok, league: league}
  end
end
