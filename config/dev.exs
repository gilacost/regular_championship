use Mix.Config

config :pre_commit,
  commands: ["test", "format", "dialyzer"],
  verbose: true
