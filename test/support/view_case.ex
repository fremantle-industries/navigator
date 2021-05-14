defmodule Navigator.ViewCase do
  use ExUnit.CaseTemplate
  use Phoenix.HTML

  def render(module, template, assigns) do
    module
    |> apply(:render, [template, assigns])
    |> safe_to_string()
  end

  using do
    quote do
      use AssertHTML

      import Navigator.ViewCase
    end
  end
end
