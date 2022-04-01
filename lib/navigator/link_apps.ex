defmodule Navigator.LinkApps do
  alias Navigator.LinkAppStore
  alias Navigator.LinkApp

  @spec get!(LinkApp.id()) :: LinkApp.t()
  def get!(otp_app) do
    {:ok, link_app} = LinkAppStore.find(otp_app)
    link_app
  end
end
