use Mix.Config

config :logger, backends: [{LoggerFileBackend, :info}]

config :logger, :info,
  path: "/var/log/info.log",
  level: :info

import_config "#{Mix.env()}.exs"
