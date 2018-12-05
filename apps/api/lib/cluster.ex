defmodule Api.Cluster do
  @moduledoc """
  """
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  @doc false
  def init([]) do
    IO.inspect("init")
    reconnect_interval = 6 * 1000

    send(self(), :connect)
    {:ok, {String.to_atom(service_name), "api", reconnect_interval}}
    end
  end

  @impl true
  @doc false
  def handle_info(:connect, {service_name, app_name, reconnect_interval} = state) do
    IO.inspect("connect")

    case :inet_tcp.getaddrs(service_name) do
      {:ok, ip_list} ->
        ip_list
        |> Enum.map(fn {a, b, c, d} -> :"#{app_name}@#{a}.#{b}.#{c}.#{d}" end)
        |> Enum.reject(&Kernel.==(&1, node()))
        |> Enum.map(&Node.connect/1)

      {:error, reason} ->
        IO.puts("Cannot resolve #{inspect(service_name)}: #{inspect(reason)}")
    end

    Process.send_after(self(), :connect, reconnect_interval)
    {:noreply, state}
  end
end
