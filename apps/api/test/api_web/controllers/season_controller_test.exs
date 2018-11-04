defmodule ApiWeb.SeasonControllerTest do
  use ApiWeb.ConnCase

  alias Api.Results
  alias Api.Results.Season

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:season) do
    {:ok, season} = Results.create_season(@create_attrs)
    season
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all seasons", %{conn: conn} do
      conn = get conn, season_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create season" do
    test "renders season when data is valid", %{conn: conn} do
      conn = post conn, season_path(conn, :create), season: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, season_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, season_path(conn, :create), season: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update season" do
    setup [:create_season]

    test "renders season when data is valid", %{conn: conn, season: %Season{id: id} = season} do
      conn = put conn, season_path(conn, :update, season), season: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, season_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn, season: season} do
      conn = put conn, season_path(conn, :update, season), season: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete season" do
    setup [:create_season]

    test "deletes chosen season", %{conn: conn, season: season} do
      conn = delete conn, season_path(conn, :delete, season)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, season_path(conn, :show, season)
      end
    end
  end

  defp create_season(_) do
    season = fixture(:season)
    {:ok, season: season}
  end
end
