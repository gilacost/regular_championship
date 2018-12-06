defmodule RegularChampionship.Repo do
  @moduledoc """
  This is a supervised repo that loads in memory the csv file
  to be accessed in a later stage.
  """

  use GenServer

  require Logger

  alias RegularChampionship.{Result, ResultList, LeagueSeasonPair, LeagueSeasonPairList}
  alias Api.Plug.ContentAccept

  @csv Application.get_env(:regular_championship, :csv) |> File.stream!()

  @doc false
  def start_link(_opts) do
    IO.puts("start_link on #{node()}")

    case GenServer.start_link(__MODULE__, %{}, name: {:global, __MODULE__}) do
      {:ok, pid} ->
        Logger.info("---- #{__MODULE__} repo worker started")
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Logger.info("---- #{__MODULE__} repo worker already running")
        {:ok, pid}
    end
  end

  @doc """
  Parses the stream with `CSV` module and maps each row as Result struct.
  """
  @impl true
  def init(_) do
    struct_list =
      @csv
      |> CSV.decode()
      |> Enum.map(&Result.build!(&1))
      |> Enum.into([])

    {:ok, struct_list}
  end

  # Client
  @doc """
  Fetches the rows for a season and division and generates a list of
  Match structs.

  ## Example
      iex> RegularChampionship.Repo.results("SP1", "201617") |> Map.get(:data)|> List.first()
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
    ContentAccept.log_ip()

    __MODULE__
    |> :global.whereis_name()
    |> IO.inspect(label: "served by:")
    |> GenServer.call({:results, division, season})
  end

  @doc """
  Returns a list of list that contains two items. The first Item is
  the league and the second is the season.

  ## Example

      iex> RegularChampionship.Repo.league_season_pairs()
      %RegularChampionship.LeagueSeasonPairList{
        data: [
          %RegularChampionship.LeagueSeasonPair{div: "SP1", season: 201617},
          %RegularChampionship.LeagueSeasonPair{div: "SP1", season: 201516},
          %RegularChampionship.LeagueSeasonPair{div: "SP2", season: 201617},
          %RegularChampionship.LeagueSeasonPair{div: "SP2", season: 201516},
          %RegularChampionship.LeagueSeasonPair{div: "E0", season: 201617},
          %RegularChampionship.LeagueSeasonPair{div: "D1", season: 201617}
        ]
      }
  """
  @spec league_season_pairs() :: list(list(String.t()))
  def league_season_pairs() do
    ContentAccept.log_ip()

    __MODULE__
    |> :global.whereis_name()
    |> IO.inspect(label: "served by:")
    |> GenServer.call(:league_season_pairs)
  end

  # Server(callbacks))

  @doc false
  @impl true
  def handle_call({:results, division, season}, _from, struct_list) do
    league_season_pair =
      Enum.filter(struct_list, fn
        %Result{div: d, season: s} ->
          d == division && "#{s}" == season

        _ ->
          false
      end)

    result_list = ResultList.build!(league_season_pair)

    {:reply, result_list, struct_list}
  end

  @doc false
  @impl true
  def handle_call(:league_season_pairs, _from, struct_list) do
    league_season_pairs =
      struct_list
      |> List.pop_at(0)
      |> elem(1)
      |> Enum.map(&[&1.div, &1.season])
      |> Enum.uniq()
      |> Enum.map(&LeagueSeasonPair.build!(&1))

    league_season_pairs_list = LeagueSeasonPairList.build!(league_season_pairs)

    {:reply, league_season_pairs_list, struct_list}
  end
end
