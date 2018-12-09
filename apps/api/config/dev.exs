use Mix.Config

# PORT=8080 HOSTNAMES=one,two,three iex --sname one -S mix
# PORT=8081 HOSTNAMES=one,two,three iex --sname two -S mix
# PORT=8082 HOSTNAMES=one,two,three iex --sname three -S mix
#
config :api,
  port:
    "PORT"
    |> System.get_env()
    |> (case do
          nil ->
            8080

          value ->
            value
            |> Integer.parse()
            |> elem(0)
        end),
  env: :dev,
  hosts:
    "HOSTS"
    |> System.get_env()
    |> (case do
          nil ->
            "one"

          value ->
            value
        end)
    |> String.split(",")
