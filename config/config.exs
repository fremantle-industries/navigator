use Mix.Config

config :phoenix, :json_library, Jason

config :navigator, Support.Endpoint, []

config :navigator, links: %{
  navigator: [
    %{
      label: "Orders",
      to: "/orders"
    },
    %{
      label: "Admin",
      to: "/admin",
      children: [
        %{
          label: "Users",
          to: "/users"
        },
        %{
          label: "Settings",
          to: {Support.Router.Helpers, :settings_path, []}
        }
      ]
    }
  ]
}
