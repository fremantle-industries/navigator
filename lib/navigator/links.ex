defmodule Navigator.Links do
  @type app_name :: Navigator.LinkConfig.app_name()
  @type conn :: term
  @type link :: Navigator.Link.t()

  @spec all(app_name, conn) :: [link]
  def all(app_name, conn, config_links \\ Application.get_env(:navigator, :links, %{})) do
    config_links
    |> Navigator.LinkConfig.parse()
    |> case do
      {:ok, app_links} -> app_links
    end
    |> Map.get(app_name, [])
    |> Enum.filter(fn
      %_{condition: nil} -> true
      %_{condition: {m, f, a}} -> apply(m, f, [conn] ++ a)
    end)
  end
end
