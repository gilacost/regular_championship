defmodule RegularChampionship.Application do
  @moduledoc """
  The RegularChampionship Application Service.

  The regular_championship system business domain lives in this application.

  Exposes API to clients such as the `RegularChampionshipWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link(
      [
        supervisor(RegularChampionship.Repo, [], name: LaLiga.Repo)
      ],
      strategy: :one_for_one,
      name: LaLiga.Supervisor
    )
  end
end