defmodule Navigator do
  use Phoenix.HTML

  def render("horizontal.html", assigns) do
    conn = assigns[:conn]
    class = assigns[:class]

    ~E"""
    <nav class="flex flex-row items-center space-x-4 <%= class %>">
      <%= for l <- Navigator.Links.all(otp_app(conn), conn) do %>
        <%= link l.label, link_args(l) %>
      <% end %>
    </nav>
    """
  end

  defp otp_app(%Phoenix.LiveView.Socket{} = socket) do
    socket.endpoint.config(:otp_app)
  end

  defp otp_app(%Plug.Conn{} = conn) do
    conn.private.phoenix_endpoint.config(:otp_app)
  end

  @default_class "text-black hover:text-opacity-75"

  defp link_args(nav_link) do
    [to: to(nav_link), class: @default_class]
    |> with_method(nav_link)
    |> with_class(nav_link)
  end

  defp to(nav_link) do
    case nav_link.link do
      {h, f, a} -> apply(h, f, a)
      link -> link
    end
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
