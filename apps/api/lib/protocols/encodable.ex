defprotocol Api.Json do
  @doc "Returns a json"
  @fallback_to_any true
  def encode(struct)
end

defprotocol Api.Protobuf do
  @doc "Returns a protobuf"
  def encode(struct)
end

# Posion encode for all structs
defimpl Api.Json, for: Any do
  def encode(struct) do
    Poison.encode!(struct)
  end
end
