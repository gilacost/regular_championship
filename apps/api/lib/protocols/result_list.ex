alias RegularChampionship.ResultList
alias RegularChampionship.Messages.Result, as: ResultProto
alias RegularChampionship.Messages.ResultList, as: ResultListProto

# implements specific encoding for a ResultList struct
defimpl Api.Protobuf, for: ResultList do
  def encode(%ResultList{data: data}) do
    result_list =
      data
      |> Enum.map(&Map.from_struct/1)
      |> Enum.map(&ResultProto.new/1)

    %{data: result_list}
    |> ResultListProto.new()
    |> ResultListProto.encode()
  end
end
