defmodule Api.Results.Season do
  alias RegularChampionship.Repo
  @doc false

  def list_all() do
    GenServer.call(Repo, {:single_values, :season})
  end
end
