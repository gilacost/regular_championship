alias RegularChampionship.Messages.NotFound, as: NotFoundProto
alias RegularChampionship.NotFound

# implements specific encoding for a NotFound struct
defimpl Api.Protobuf, for: NotFound do
  def encode(not_found) do
    not_found
    |> Map.from_struct()
    |> NotFoundProto.new()
    |> NotFoundProto.encode()
  end
end
