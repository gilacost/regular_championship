defmodule Api.Plug.ContentAccept do
  import Plug.Conn, only: [get_req_header: 2, assign: 3]

  @accepted_content_types [
    "application/json",
    "application/octet-stream",
    "application/protobuf"
  ]

  def init(options), do: options

  def call(%Plug.Conn{} = conn, _opts) do
    [content_type] = get_req_header(conn, "content-type")

    if content_type in @accepted_content_types do
      assign(conn, :content_type, content_type)
    else
      assign(conn, :invalid_content_type, content_type)
    end
  end
end
