defmodule RegularChampionship.Application do
  @moduledoc """
  The RegularChampionship Application Service.

  The regular_championship system business domain lives in this application.

  Exposes API to clients such as the `RegularChampionshipWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  alias RegularChampionship.{Cluster, Repo}

  def start(_type, _args) do
    Supervisor.start_link(children(:all), opts())
  end

  defp children(:all), do: [{Cluster, []}, {Repo, []}]
  defp opts(), do: [strategy: :one_for_one, name: RegularChampionship.Supervisor]
end
