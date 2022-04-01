defmodule Navigator.Application do
  @moduledoc false

  use Application

  require Logger

  def start(_type, _args) do
    children = [
      Navigator.LinkAppStore
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Navigator.Supervisor)
  end

  def start_phase(:configure, _start_type, _phase_args) do
    link_apps = Navigator.Config.parse!()
    log_configured(link_apps)

    :ok
  end

  defp log_configured(link_apps) do
    "configured links for applications: ~s"
    |> :io_lib.format([
      link_apps |> Enum.join(", ")
    ])
    |> Logger.debug()
  end
end
