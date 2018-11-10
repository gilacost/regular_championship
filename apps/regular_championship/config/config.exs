use Mix.Config

config :regular_championship, csv: Path.expand("../priv/Data.csv", __DIR__)

import_config "#{Mix.env()}.exs"
