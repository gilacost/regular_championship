use Mix.Config

# config :logger, backends: [{LoggerFileBackend, :info}]

# config :logger, :info,
#   path: Path.expand("../log/info.log", __DIR__),
#   level: :info

config :logger,
  backends: [:console],
  compile_time_purge_matching: [
    [level_lower_than: :info]
  ]

import_config "#{Mix.env()}.exs"
