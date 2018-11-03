alias RegularChampionship.ResultList
alias RegularChampionship.Messages.Result, as: ResultProto
alias RegularChampionship.Messages.ResultList, as: ResultListProto

# implements specific encoding for a ResultList struct
defimpl Api.Protobuf, for: ResultList do
  def encode(%ResultList{
        data: %Scrivener.Page{
          entries: entries,
          page_number: page_number,
          page_size: page_size,
          total_entries: total_entries,
          total_pages: total_pagees
        }
      }) do
    result_list =
      entries
      |> Enum.map(&Map.from_struct/1)
      |> Enum.map(&ResultProto.new/1)

    %{
      data: result_list,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pagees
    }
    |> ResultListProto.new()
    |> ResultListProto.encode()
  end
end
