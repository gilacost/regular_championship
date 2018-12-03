defmodule Api.ControllerTest do
  use ExUnit.Case, async: true
  alias RegularChampionship.{LeagueSeasonPairList, ResultList, NotFound}
  alias Plug.Conn

  @valid_params %{
    "league" => "SP1",
    "season" => "201617"
  }

  @invalid_params %{
    "league" => "",
    "season" => ""
  }

  describe "league_season/1" do
    test "responds a league season pair list with ok status" do
      [code, response_data] =
        conn()
        |> Api.Controller.league_season()
        |> code_and_resp_data()

      assert code == 200
      assert %LeagueSeasonPairList{} = response_data
    end
  end

  describe "results/1" do
    test "responds a result list for an existing league season pair" do
      [code, response_data] =
        @valid_params
        |> conn()
        |> Api.Controller.results()
        |> code_and_resp_data()

      assert code == 200
      assert %ResultList{} = response_data
    end

    test "responds not found for a non existing league season pair" do
      [code, response_data] =
        @invalid_params
        |> conn()
        |> Api.Controller.results()
        |> code_and_resp_data()

      assert code == 404
      assert %NotFound{} = response_data
    end

    test "default response data contains n items specified in config file" do
      page_size = Application.get_env(:api, :page_size)

      [_code, response_data] =
        @valid_params
        |> conn()
        |> Api.Controller.results()
        |> code_and_resp_data()

      assert page_size = length(response_data)
    end
  end

  defp code_and_resp_data(%Conn{assigns: assigns, status: code}) do
    [
      code,
      Map.get(assigns, :resp_data)
    ]
  end

  defp conn(%{} = params), do: %Plug.Conn{params: params}
  defp conn(), do: %Plug.Conn{}
end
