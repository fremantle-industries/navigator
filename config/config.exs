use Mix.Config

config :phoenix, :json_library, Jason

config :navigator,
  links: %{
    storefront: [
      %{
        label: "Storefront Home",
        link: {StorefrontWeb.Router.Helpers, :home_path, [StorefrontWeb.Endpoint, :index]},
        class: "text-4xl"
      },
      %{
        label: "Orders",
        link: {StorefrontWeb.Router.Helpers, :order_path, [StorefrontWeb.Endpoint, :index]}
      },
      %{
        label: "Admin",
        link: {AdminWeb.Router.Helpers, :home_url, [AdminWeb.Endpoint, :index]}
      }
    ],
    admin: [
      %{
        label: "Admin Home",
        link: {AdminWeb.Router.Helpers, :home_path, [AdminWeb.Endpoint, :index]},
        class: "text-4xl"
      },
      %{
        label: "Order Admin",
        link: {AdminWeb.Router.Helpers, :order_path, [AdminWeb.Endpoint, :index]}
      },
      %{
        label: "Analytics",
        link: "https://analytics.google.com"
      }
    ]
  }
