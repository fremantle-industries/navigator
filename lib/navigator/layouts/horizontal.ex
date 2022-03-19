defmodule Navigator.Layouts.Horizontal do
  use Phoenix.HTML
  import Phoenix.LiveView.Helpers, only: [sigil_H: 2]

  def render(assigns) do
    conn = assigns[:conn]
    class = assigns[:class]
    links = assigns[:links] || Navigator.Links.all(otp_app(conn), conn)
    {prepared_links, child_links} = prepare_links(links)
    child_assigns = Map.put(assigns, :links, child_links)

    ~H"""
    <nav class={"flex flex-row items-center space-x-4 #{class}"}>
      <%= for {label, opts} <- prepared_links do %>
        <%= link label, opts %>
      <% end %>
    </nav>
    <%= if Enum.any?(child_links) do %>
      <%= render(child_assigns) %>
    <% end %>
    """
  end

  defp otp_app(c) do
    case c do
      %Phoenix.LiveView.Socket{} -> c.endpoint.config(:otp_app)
      %Plug.Conn{}  -> c.private.phoenix_endpoint.config(:otp_app)
    end
  end

  defp prepare_links(links) do
    links
    |> Enum.reduce(
      {[], []},
      fn link, {l, c} ->
        label = generate_label(link)
        prepared_links = l ++ [{label, link_options(link)}]
        child_links = c ++ link.children
        {prepared_links, child_links}
      end
    )
  end

  defp generate_label(link) do
    case link.label do
      {m, f, a} -> apply(m, f, a)
      l -> l
    end
  end

  defp link_options(link) do
    []
    |> put_to(link)
    |> put_class(link)
    |> put_option(:method, link.method)
  end

  defp put_to(options, link) do
    to = generate_to(link)
    Keyword.put(options, :to, to)
  end

  defp generate_to(link) do
    case link.to do
      {h, f, a} -> apply(h, f, a)
      to -> to
    end
  end

  @default_class "text-black hover:text-opacity-75"
  defp put_class(options, link) do
    class = if link.class == nil, do: link.class, else: "#{@default_class} #{link.class}"
    Keyword.put(options, :class, class)
  end

  defp put_option(options, key, value) do
    case value do
      nil -> options
      _ -> Keyword.put(options, key, value)
    end
  end
end
