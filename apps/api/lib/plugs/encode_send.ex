defmodule Api.Plug.EncodeSend do
  @moduledoc """
  This is the final pipeline in ther router. It has the responsability
  of formatting the output, putting the response type header adn sending
  the response.

  The output can be "application/json", "application/octet-stream",
  "application/protobuf" or "text/plain"
  """
  alias Api.{Protobuf, Json, Plug.ContentAccept}
  alias Plug.Conn.Status
  import Plug.Conn, only: [put_resp_content_type: 2, send_resp: 3]

  @doc false
  def init(options), do: options

  @doc """
  Encodes the response data depending on the content type and then sends
  the response.
  """
  def call(
        %Plug.Conn{
          assigns: %{
            content_type: content_type,
            resp_data: resp_data
          },
          status: resp_code
        } = conn,
        _opts
      ) do
    formated_resp_data = format_output(content_type, resp_data)

    conn
    |> put_resp_content_type(content_type)
    |> send_resp(resp_code, formated_resp_data)
  end

  @doc """
  Sends text/plain response with a list of accepted types.
  """
  def call(%Plug.Conn{assigns: %{invalid_content_type: content_type}} = conn, _opts) do
    accepts = Enum.join(ContentAccept.list(), ", ")

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(
      Status.code(:not_acceptable),
      "invalid conten-type: #{content_type}\nACCEPTS: #{accepts}"
    )
  end

  # Encodes into jason or protobuf
  defp format_output("application/json", data), do: Json.encode(data)
  defp format_output("application/octet-stream", data), do: Protobuf.encode(data)
  defp format_output("application/protobuf", data), do: Protobuf.encode(data)
end
