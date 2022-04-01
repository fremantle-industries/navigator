defmodule Navigator.Layouts.Horizontal do
  use Phoenix.HTML
  import Phoenix.LiveView.Helpers, only: [sigil_H: 2]

  alias Navigator.OtpApps
  alias Navigator.LinkApps

  def render(assigns) do
    conn = assigns[:conn]
    otp_app = OtpApps.get!(conn)
    link_app = LinkApps.get!(otp_app)
    tree = link_app.links
    active_node_id = find_active_node_id(tree, conn.request_path)
    rows = build_rows(tree, active_node_id)

    render_nav_rows(rows, %{class: link_app.class})
  end

  defp render_nav_rows(rows, assigns) do
    case rows do
      [] ->
        ""

      [row_nodes | rows] ->
        prepared_links = prepare_links(row_nodes)

        ~H"""
        <nav class={"flex flex-row items-center space-x-4 #{@class}"}>
          <%= for {label, opts} <- prepared_links do %>
            <%= link label, opts %>
          <% end %>
        </nav>
        <%= render_nav_rows(rows, %{class: nil}) %>
        """
    end
  end

  defp find_active_node_id(_tree, ""), do: nil
  defp find_active_node_id(tree, request_path) do
    tree
    |> OrderedNaryTree.find(fn n ->
      case n.value do
        %Navigator.Link{} = link -> generate_to(link) == request_path
        _ -> false
      end
    end
    )
    |> case do
      {:ok, active_node} ->
        active_node.id

      {:error, :not_found} ->
        request_path_segments = String.split(request_path, "/")
        parent_length = length(request_path_segments) - 1
        parent_request_path = request_path_segments |> Enum.take(parent_length) |> Enum.join("/")
        find_active_node_id(tree, parent_request_path)
    end
  end

  defp build_rows(tree, active_node_id, rows \\ []) do
    rows = case OrderedNaryTree.children(tree, active_node_id) do
      {:ok, []} ->
        rows

      {:ok, children} ->
        [children | rows]

      {:error, :not_found} ->
        {:ok, children} = OrderedNaryTree.children(tree)
        [children]
    end

    case OrderedNaryTree.parent(tree, active_node_id) do
      {:ok, p} -> build_rows(tree, p.id, rows)
      {:error, :not_found} -> rows
    end
  end

  defp prepare_links(row_nodes) do
    row_nodes
    |> Enum.map(
      fn row_node ->
        link = row_node.value
        label = generate_label(link)
        options = link_options(link)

        {label, options}
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
