defmodule Navigator.Config do
  alias Navigator.LinkApp
  alias Navigator.LinkAppStore
  alias Navigator.Link

  def parse!(all_env \\ Application.get_all_env(:navigator)) do
    active_class = get_active_class(all_env)

    all_env
    |> Keyword.get(:links, %{})
    |> Enum.reduce(
      [],
      fn {app_config, link_configs}, link_apps ->
        links = build_tree(app_config, link_configs, active_class)
        attrs = build_attrs(app_config, links)
        link_app = struct!(LinkApp, attrs)
        {:ok, _} = LinkAppStore.put(link_app)

        [link_app.otp_app | link_apps]
      end
    )
    |> Enum.reverse()
  end

  @default_active_class "active"
  defp get_active_class(all_env) do
    Keyword.get(all_env, :active_class, @default_active_class)
  end

  defp build_tree(app_config, link_configs, active_class) do
    app_id = get_app_id(app_config)
    root_node = OrderedNaryTree.Node.new(app_id)
    tree = OrderedNaryTree.new(root_node)
    add_children(tree, root_node.id, link_configs, active_class)
  end

  defp add_children(tree, parent_id, link_configs, active_class) do
    case link_configs do
      [] ->
        tree

      [link_config | remaining_link_configs] ->
        {link, children} = build_link(link_config, active_class)
        child_node = OrderedNaryTree.Node.new(link)
        {:ok, tree} = OrderedNaryTree.add_child(tree, parent_id, child_node)

        tree
        |> add_children(child_node.id, children, active_class)
        |> add_children(parent_id, remaining_link_configs, active_class)
    end
  end

  defp get_app_id(app_config) do
    case app_config do
      {app_id, _class} -> app_id
      app_id -> app_id
    end
  end

  defp build_link(link_config, active_class) do
    label = Map.fetch!(link_config, :label)
    to = Map.fetch!(link_config, :to)
    children = Map.get(link_config, :children) || []
    class = Map.get(link_config, :class)
    icon = Map.get(link_config, :icon)
    method = Map.get(link_config, :method)
    condition = Map.get(link_config, :condition)

    link = %Link{
      label: label,
      to: to,
      active_class: active_class,
      class: class,
      icon: icon,
      method: method,
      condition: condition
    }

    {link, children}
  end

  defp build_attrs(app_config, links) do
    app_config
    |> case do
      {otp_app, class} -> %{otp_app: otp_app, class: class}
      otp_app -> %{otp_app: otp_app}
    end
    |> Map.put(:links, links)
  end
end
