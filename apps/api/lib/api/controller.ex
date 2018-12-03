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
  @spec league_season(%{}) :: struct()
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
  @type params_for_results() :: %{
          required(String.t()) => String.t(),
          required(String.t()) => String.t()
        }

  @spec results(params_for_results()) :: struct()
  def results(%Conn{params: %{"league" => league, "season" => season}} = conn) do
    league
    |> Repo.results(season)
    |> case do
      %ResultList{data: []} ->
        respond_not_found(conn, "no season #{season} for league: #{league}")

      resp_data ->
        resp_data =
          conn
          |> Conn.fetch_query_params()
          |> paginate(resp_data)

        respond_ok(conn, resp_data)
    end
  end

  @doc """
  Updates the conn by assigning `404` as response code and
  the received struct as response data.

  Returns `%Conn{}`.
  """

  @spec respond_not_found(Plug.Conn.t(), String.t()) :: struct()
  def respond_not_found(conn, message) do
    conn
    |> put_status(Status.code(:not_found))
    |> assign(:resp_data, %NotFound{message: message})
  end

  @doc """
  Updates the conn by assigning `200` as response code and a
  `%NotFound{}` struct as response data.

  Returns `%Conn{}`.
  """
  @spec respond_ok(Plug.Conn.t(), String.t()) :: struct()
  def respond_ok(conn, resp_data) do
    conn
    |> put_status(Status.code(:ok))
    |> assign(:resp_data, resp_data)
  end

  # Uses `Scrivener` dependency to paginate the received list
  #
  # Returns received map with new paginated :data.
  @spec paginate(Plug.Conn.t(), list()) :: map()
  defp paginate(%Conn{params: params}, %{data: data} = resp_data) do
    config = maybe_put_default_config(params)
    paginated_data = Scrivener.paginate(data, config)
    Map.put(resp_data, :data, paginated_data)
  end

  # If page as page number and page size are sent as query params
  # uses these params as config for pagination.
  #
  # returns `Scrivener.Config`
  defp maybe_put_default_config(%{"page" => page_number, "page_size" => page_size}) do
    %Scrivener.Config{page_number: to_int(page_number), page_size: to_int(page_size)}
  end

  # defaults config to be first page and page size one defined in
  # config file
  # uses these params as config for pagination.
  #
  # returns `Scrivener.Config`
  defp maybe_put_default_config(_params) do
    page_size = Application.get_env(:api, :page_size)
    %Scrivener.Config{page_number: 1, page_size: page_size}
  end

  # parses query parameter reeceived as string into an integer
  #
  # returns `integer`
  defp to_int(string) do
    string
    |> Integer.parse()
    |> elem(0)
  end
end
