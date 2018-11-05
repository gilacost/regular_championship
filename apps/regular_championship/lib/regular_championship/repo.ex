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
  # Starts the genserver.

  # ## Parameters

  #   - name: String that represents the name of the person.

  # ## Examples

  #     iex> Greeter.hello("Sean")
  #     "Hello, Sean"

  #     iex> Greeter.hello("pete")
  #     "Hello, pete"

  """
  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, options, name: __MODULE__)
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

  @doc """
  Fetches the match list for a season and division and generates a list of structs
  that will be used to print the json output.
  """
  @impl true
  def handle_call({:league_season_pair, [division, season]}, _, struct_list) do
    league_season_pair =
      Enum.filter(struct_list, fn
        %Result{div: d, season: s} ->
          d == division && "#{s}" == season

        _ ->
          false
      end)

    {:reply, league_season_pair, struct_list}
  end

  @doc """
  Returns a list with all the unique values of season or division
  """
  @impl true
  def handle_call({:single_values, column}, _, struct_list)
      when column in [:div, :season] do
    keys_list =
      struct_list
      |> List.pop_at(0)
      |> elem(1)
      |> Enum.group_by(&Map.get(&1, column))
      |> Map.keys()

    {:reply, keys_list, struct_list}
  end
end
