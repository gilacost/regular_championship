defmodule Api.Results.League do
  alias RegularChampionship.Repo
  @doc false

  def list_all() do
    GenServer.call(Repo, {:single_values, :div})
  end
end
