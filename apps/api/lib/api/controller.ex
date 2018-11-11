defmodule Api.Controller do
  @moduledoc """
  This is the controller of the API. It gathers data from the
  the GenServer Repo and assigns response data and response code
  to the `Plug.Conn` and passes it to the next pipeline.

  This module also contains helper functions to specify the type
  of response that will be sent to the client.
  """
  alias RegularChampionship.{Repo, ResultList, NotFound}
  alias Plug.{Conn, Conn.Status}
  import Plug.Conn, only: [assign: 3, put_status: 2]

  @doc """
  Gets the league season pairs from the repo and then
  calls `respond_ok`.

  Returns `%Conn{}`.
  """
  @spec league_season(%Plug.Conn{}) :: %Plug.Conn{}
  def league_season(%Conn{} = conn) do
    response_data = Repo.league_season_pairs()
    respond_ok(conn, response_data)
  end

  @doc """
  Gets the results of an specific league season pair from the repo
  and if there are results calls `respond_ok`. If repo returns an
  empty list then calls `respond_not_found`.

  Returns `%Conn{}`.
  """
  @type params() :: %{required(String.t()) => String.t(), required(String.t()) => String.t()}
  @type results_request() :: %Plug.Conn{params: params()}

  @spec results(results_request()) :: %Plug.Conn{}
  def results(%Conn{params: %{"league" => league, "season" => season}} = conn) do
    league
    |> Repo.results(season)
    |> case do
      %ResultList{data: []} ->
        respond_not_found(conn, "no season #{season} for league: #{league}")

      resp_data ->
        respond_ok(conn, resp_data)
    end
  end

  @doc """
  Updates the conn by assigning `404` as response code and a
  `%NotFound{}` struct as response data.

  Returns `%Conn{}`.
  """

  @spec respond_not_found(%Conn{}, String.t()) :: %Conn{}
  def respond_not_found(conn, message) do
    conn
    |> put_status(Status.code(:not_found))
    |> assign(:resp_data, %NotFound{message: message})
  end

  defp respond_ok(conn, resp_data) do
    conn
    |> put_status(Status.code(:ok))
    |> assign(:resp_data, resp_data)
  end
end
