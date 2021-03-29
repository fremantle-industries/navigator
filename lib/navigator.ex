defmodule Navigator do
  use Phoenix.HTML

  def render("horizontal.html", assigns) do
    ~E"""
    <header class="bg-gray-50 py-4">
      <div class="mx-4">
        <nav class="flex flex-row items-center space-x-4">
          <%= for l <- Navigator.Links.all(otp_app(assigns.conn), assigns.conn) do %>
            <%= link l.label, link_args(l) %>
          <% end %>
        </nav>
      </div>
    </header>
    """
  end

  defp otp_app(%_{} = conn) do
    conn.private.phoenix_endpoint.config(:otp_app)
  end

  @default_class "text-black hover:text-opacity-75"

  defp link_args(link) do
    {h, f, a} = link.link

    [to: apply(h, f, a), class: @default_class]
    |> with_method(link)
    |> with_class(link)
  end

  defp with_method(args, link) do
    if link.method do
      Keyword.put(args, :method, link.method)
    else
      args
    end
  end

  defp with_class(args, link) do
    if link.class do
      Keyword.put(args, :class, "#{@default_class} #{link.class}")
    else
      args
    end
  end
end
