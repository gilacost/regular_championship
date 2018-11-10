use Mix.Config

config :regular_championship,
  csv:
    "/opt/app/lib/regular_championship-#{System.get_env("REGULAR_CHAMPIONSHIP_VSN")}/priv/Data.csv"
