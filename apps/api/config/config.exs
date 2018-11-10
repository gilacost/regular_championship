use Mix.Config

config :logger, backends: [{LoggerFileBackend, :info}]

config :logger, :info,
  path: Path.expand("../log/info.log", __DIR__),
  level: :info

import_config "#{Mix.env()}.exs"
