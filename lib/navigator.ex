defmodule Navigator do
  def render("horizontal.html", assigns) do
    Navigator.Layouts.Horizontal.render(assigns)
  end
end
