alias RegularChampionship.Messages.NotFound, as: NotFoundProto
alias RegularChampionship.NotFound

defimpl Api.Protobuf, for: NotFound do
  def encode(not_found) do
    not_found
    |> Map.from_struct()
    |> NotFoundProto.new()
    |> NotFoundProto.encode()
  end
end
