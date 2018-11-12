defmodule RegularChampionship.ResultList do
  @moduledoc """
  This is a list of results
  """
  defstruct [:data]

  def build!(result_list) do
    struct!(
      __MODULE__,
      data: result_list
    )
  end
end
