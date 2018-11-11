defmodule Api.Plug.ContentAccept do
  import Plug.Conn, only: [get_req_header: 2, assign: 3]
  require Logger

  @accepted_content_types [
    "application/json",
    "application/octet-stream",
    "application/protobuf"
  ]

  defmodule Api.Net do
    def get_ip(
          {:ok,
           [
             {ip, _, _},
             {_, _, _}
           ]}
        ),
        do: inspect(ip)
  end

  def init(options), do: options

  def call(%Plug.Conn{} = conn, _opts) do
    ip = Api.Net.get_ip(:inet.getif())
    Logger.info("Request served by node with ip #{ip}")
    [content_type] = get_req_header(conn, "content-type")

    if content_type in @accepted_content_types do
      assign(conn, :content_type, content_type)
    else
      assign(conn, :invalid_content_type, content_type)
    end
  end

  def list(), do: @accepted_content_types
end
