defmodule Navigator.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.
  """

  use ExUnit.CaseTemplate

  setup _tags do
    Application.stop(:navigator)
    {:ok, _} = Application.ensure_all_started(:navigator)

    :ok
  end
end
