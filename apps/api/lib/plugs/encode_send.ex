defmodule Api.Plug.EncodeSend do
  alias Api.{Protobuf, Json}
  import Plug.Conn, only: [put_resp_content_type: 2, send_resp: 3]

  def init(options), do: options

  def call(
        %Plug.Conn{
          assigns: %{
            content_type: content_type,
            resp_data: resp_data,
            resp_code: resp_code
          }
        } = conn,
        _opts
      ) do
    formated_resp_data = format_output(content_type, resp_data)

    conn
    |> put_resp_content_type(content_type)
    |> send_resp(resp_code, formated_resp_data)
  end

  def call(%Plug.Conn{assigns: %{invalid_content_type: content_type}} = conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(401, "invalid conten-type: #{content_type}")
  end

  defp format_output("application/json", data), do: Json.encode(data)
  defp format_output("application/octet-stream", data), do: Protobuf.encode(data)
  defp format_output("application/protobuf", data), do: Protobuf.encode(data)
end
