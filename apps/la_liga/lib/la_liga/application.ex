defmodule LaLiga.Application do
  @moduledoc """
  The LaLiga Application Service.

  The la_liga system business domain lives in this application.

  Exposes API to clients such as the `LaLigaWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link(
      [
        supervisor(LaLiga.Repo, [], name: LaLiga.Repo)
      ],
      strategy: :one_for_one,
      name: LaLiga.Supervisor
    )
  end
end
