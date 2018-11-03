use Mix.Config

config :logger,
  backends: [:console],
  compile_time_purge_matching: [
    [level_lower_than: :info]
  ]

config :api, page_size: 10

import_config "#{Mix.env()}.exs"
