use Mix.Config

config :la_liga, ecto_repos: [LaLiga.Repo]

import_config "#{Mix.env}.exs"
