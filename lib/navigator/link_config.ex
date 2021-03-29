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
          app_links =
            app_attrs
            |> Enum.map(fn link_attrs ->
              struct!(Navigator.Link, link_attrs)
            end)

          Map.put(acc, app_name, app_links)
        end
      )

    {:ok, apps}
  end
end
