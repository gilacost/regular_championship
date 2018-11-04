defmodule Match do
  defstruct [
    :day,
    :div,
    :season,
    :date,
    :home_team,
    :away_team,
    :fthg,
    :ftag,
    :ftr,
    :hthg,
    :htag,
    :htr
  ]
end

defmodule LaLiga.Repo do
  use GenServer

  @csv File.cwd!() |> Path.join(["priv/", "Data.csv"]) |> File.stream!()

  @doc """
  GenServer that load csv data once.
  """
  def start_link(_options \\ []) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Callbacks

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

  @impl true
  def handle_call({:league_and_season, [division, season]}, _, data) do
    season_and_leage =
      data
      |> Enum.filter(fn
        %Match{div: d, season: s} -> d == division && s == season
        _ -> false
      end)

    {:reply, season_and_leage, []}
  end
end
