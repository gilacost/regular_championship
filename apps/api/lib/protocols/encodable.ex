defprotocol Api.Json do
  @fallback_to_any true
  def encode(struct)
end

defprotocol Api.Protobuf do
  def encode(struct)
end

defimpl Api.Json, for: Any do
  def encode(struct) do
    Poison.encode!(struct)
  end
end
