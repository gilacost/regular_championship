use Mix.Config

config :regular_championship, ecto_repos: [RegularChampionship.Repo]

import_config "#{Mix.env}.exs"
