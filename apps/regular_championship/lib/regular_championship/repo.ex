defmodule RegularChampionship.Repo do
  @moduledoc """
  This is a supervised repo that loads in memory the csv file
  to be accessed in a later stage.
  """

  use GenServer
  alias RegularChampionship.Match

  @csv File.cwd!()
       |> Path.join(["priv/", "Data.csv"])
       |> File.stream!()

  @doc """
  Starts the genserver.
  """
  def start_link(_options \\ []) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Callbacks

  @doc """
  Parses the stream with CSV and maps each row as MATCH struct.
  """
  @impl true
  def init(_) do
    data =
      @csv
      |> CSV.decode()
      |> Enum.map(fn
        {:ok, [day, div, season, date, home_team, away_team, fthg, ftag, ftr, hthg, htag, htr]} ->
          struct!(Match,
            day: day,
            div: div,
            season: season,
            date: date,
            home_team: home_team,
            away_team: away_team,
            fthg: fthg,
            ftag: ftag,
            ftr: ftr,
            hthg: hthg,
            htag: htag,
            htr: htr
          )
      end)
      |> Enum.into([])

    {:ok, data}
  end

  @doc """
  Fetches the matches for a season and division.
  """
  @impl true
  def handle_call({:league_season_pair, [division, season]}, _, data) do
    league_season_pair =
      data
      |> Enum.filter(fn
        %Match{div: d, season: s} -> d == division && s == season
        _ -> false
      end)

    {:reply, league_season_pair, data}
  end

  @doc """
  Returns a list with all the unique values of season or division
  """
  @impl true
  def handle_call({:single_values, column}, _, data) when column in [:div, :season] do
    keys_list =
      data
      |> List.pop_at(0)
      |> elem(1)
      |> Enum.group_by(&Map.get(&1, column))
      |> Map.keys()

    {:reply, keys_list, data}
  end
end
