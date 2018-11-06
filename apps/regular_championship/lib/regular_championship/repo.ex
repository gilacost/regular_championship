defmodule RegularChampionship.Repo do
  @moduledoc """
  This is a supervised repo that loads in memory the csv file
  to be accessed in a later stage.
  """

  use GenServer
  alias RegularChampionship.Result

  @csv File.cwd!()
       |> Path.join(["priv/", "Data.csv"])
       |> File.stream!()

  @doc """
  Starts a RegularChampionship genserver process linked to the current process.

  This is used to start this Genserver as part of a supervision tree.

  Once the server is started, the `init/1` function of the given module is called with args as its arguments to initialize the server. To ensure a synchronized start-up procedure, this function does not return until `init/1` has returned.
  """
  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  Parses the stream with CSV and maps each row as MATCH struct
  and ProtoMatch Message.
  """
  @impl true
  def init(_) do
    struct_list =
      @csv
      |> CSV.decode()
      |> Enum.map(&Result.build_struct!(&1))
      |> Enum.into([])

    {:ok, struct_list}
  end

  # Client
  @doc """
  Fetches the rows for a season and division and generates a list of
  Match structs.

  ## Example
      iex> RegularChampionship.Repo.results(["SP1", "201617"]) |> List.first()
      %RegularChampionship.Result{
        away_team: "Eibar",
        date: "19/08/2016",
        div: "SP1",
        ftag: 1,
        fthg: 2,
        ftr: "H",
        home_team: "La Coruna",
        htag: 0,
        hthg: 0,
        htr: "D",
        id: 1,
        season: 201617
      }
  """
  @type division() :: String.t()
  @type season() :: String.t()
  @type match() :: %Result{}

  @spec results(division(), season()) :: list(match())
  def results(division, season) do
    GenServer.call(__MODULE__, {:results, [division, season]})
  end

  @doc """
  Returns a list of list that contains two items. The first Item is
  the league and the second is the season.

  ## Example

      iex> RegularChampionship.Repo.league_season_pairs()
      [
        ["SP1", 201617],
        ["SP1", 201516],
        ["SP2", 201617],
        ["SP2", 201516],
        ["E0", 201617],
        ["D1", 201617]
      ]
  """
  @spec league_season_pairs() :: list(list(string))
  def league_season_pairs() do
    GenServer.call(__MODULE__, {:league_season_pair})
  end

  # Server(callbacks)

  @doc false
  @impl true
  def handle_call({:results, [division, season]}, _, struct_list) do
    league_season_pair =
      Enum.filter(struct_list, fn
        %Result{div: d, season: s} ->
          d == division && "#{s}" == season

        _ ->
          false
      end)

    {:reply, league_season_pair, struct_list}
  end

  @impl true
  def handle_call({:league_season_pair}, _, struct_list) do
    keys_list =
      struct_list
      |> List.pop_at(0)
      |> elem(1)
      |> Enum.map(&[&1.div, "#{&1.season}"])
      |> Enum.uniq()

    {:reply, keys_list, struct_list}
  end
end
