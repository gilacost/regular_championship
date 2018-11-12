defmodule Api.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.
  """
  use ExUnit.Case, async: true
  use ExUnit.CaseTemplate

  using do
    quote do
    end
  end
end
