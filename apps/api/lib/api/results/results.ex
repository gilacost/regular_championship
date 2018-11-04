defmodule Api.Results do
  @moduledoc """
  The Results context.
  """

  alias Api.Results.Season

  @doc """
  Returns the list of seasons.

  ## Examples

      iex> list_seasons()
      [%Season{}, ...]

  """
  def list_seasons do
    Season.list_all()
  end
end
