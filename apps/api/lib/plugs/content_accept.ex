defmodule Api.Plug.ContentAccept do
  @moduledoc """
  This module validates the content type header sent by the clien is allowed.
  It also logs the ip of the server that will be send the final response.
  """
  import Plug.Conn, only: [get_req_header: 2, assign: 3]
  require Logger

  @accepted_content_types [
    "application/json",
    "application/octet-stream",
    "application/protobuf"
  ]

  @doc """
  Logs the node ip.
  """
  def init(options) do
    ip = get_ip(:inet.getif())
    Logger.info("Request served by node with ip #{ip}")
    options
  end

  @doc """
  if the content-type header sent is in `@accepted_content_types` assigns a
  :valid_content_type, if not assigns an :invalid_content_type.

  Returns: `Plug.Conn`
  """

  def call(%Plug.Conn{} = conn, _opts) do
    [content_type] = get_req_header(conn, "accept")

    if content_type in @accepted_content_types do
      assign(conn, :content_type, content_type)
    else
      assign(conn, :invalid_content_type, content_type)
    end
  end

  @doc """
  Returns the list of accepted content types.
  """
  @spec list() :: [String.t()]
  def list(), do: @accepted_content_types

  # gets the ip
  @spec get_ip({:atom, list(tuple)}) :: String.t()
  defp get_ip(
         {:ok,
          [
            {ip, _, _},
            {_, _, _}
          ]}
       ),
       do: inspect(ip)
end
