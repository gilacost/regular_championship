defmodule RegularChampionship.Cluster do
  @moduledoc """
  """
  use GenServer

  alias RegularChampionship.Repo

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  @impl true
  @doc false
  def init([]) do
    reconnect_interval = 5 * 1000
    env = Application.get_env(:api, :env)
    send(self(), :connect)
    {:ok, {:api, env, reconnect_interval}}
  end

  @impl true
  @doc false
  def handle_info(:connect, {app_name, :prod, reconnect_interval} = state) do
    case :inet_tcp.getaddrs(app_name) do
      {:ok, ip_list} ->
        ip_list
        |> Enum.map(fn {a, b, c, d} -> :"#{app_name}@#{a}.#{b}.#{c}.#{d}" end)
        |> Enum.reject(&Kernel.==(&1, node()))
        |> Enum.map(&Node.connect/1)

      {:error, reason} ->
        IO.puts("Cannot resolve #{inspect(app_name)}: #{inspect(reason)}")
    end

    monitor_repo()

    Process.send_after(self(), :connect, reconnect_interval)
    {:noreply, state}
  end

  @impl true
  @doc false
  def handle_info(:connect, {_app_name, :dev, reconnect_interval} = state) do
    {:ok, host_name} = :inet.gethostname()

    :api
    |> Application.get_env(:hosts)
    |> Enum.map(&:"#{&1}@#{host_name}")
    |> Enum.reject(&Kernel.==(&1, node()))
    |> Enum.map(&Node.connect/1)

    IO.inspect([node() | Node.list()], label: "nodes")
    monitor_repo()

    Process.send_after(self(), :connect, reconnect_interval)
    {:noreply, state}
  end

  defp monitor_repo() do
    case :global.whereis_name(Repo) do
      :undefined ->
        Repo.start_link([])

      pid ->
        IO.inspect(pid)
        nil
    end
  end
end
