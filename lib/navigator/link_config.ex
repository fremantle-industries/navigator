defmodule Navigator.LinkConfig do
  @type link :: Navigator.Link.t()
  @type app_name :: atom
  @type app_links :: %{
          optional(app_name) => [link]
        }

  @spec parse(map) :: {:ok, app_links}
  def parse(app_config_links \\ Application.get_env(:navigator, :links, %{})) do
    apps =
      app_config_links
      |> Enum.reduce(
        %{},
        fn {app_name, app_attrs}, acc ->
          links = build_links(app_attrs)
          Map.put(acc, app_name, links)
        end
      )

    {:ok, apps}
  end

  defp build_links(configs) do
    Enum.map(configs, &build_link/1)
  end

  defp build_link(config) do
    label = get(config, :label)
    to = get(config, :to)
    children = get(config, :children, [])
    class = get(config, :class)
    icon = get(config, :icon)
    method = get(config, :method)
    condition = get(config, :condition)

    %Navigator.Link{
      label: label,
      to: to,
      children: children,
      class: class,
      icon: icon,
      method: method,
      condition: condition
    }
  end

  defp get(config, key, default \\ nil) do
    value = Map.get(config, key, default)

    case key do
      :children -> build_links(value)
      _ -> value
    end
  end
end
