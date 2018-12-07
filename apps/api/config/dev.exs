defmodule Api.Helpers do
  def get_env_with_default(key, default) do
    key
    |> System.get_env()
    |> case do
      nil ->
        default

      value ->
        value
    end
  end
end

use Mix.Config

# PORT=8080 HOSTNAMES=one,two,three iex --sname one -S mix
# PORT=8081 HOSTNAMES=one,two,three iex --sname two -S mix
# PORT=8082 HOSTNAMES=one,two,three iex --sname three -S mix
#
config :api,
  port:
    "PORT"
    |> Api.Helpers.get_env_with_default("8080")
    |> Integer.parse()
    |> elem(0),
  env: :dev,
  hosts:
    "HOSTS"
    |> Api.Helpers.get_env_with_default("one")
    |> String.split(",")
