defmodule NavigatorTest do
  use Navigator.ViewCase
  doctest Navigator

  defmodule StorefrontWeb.Endpoint do
    def config(:otp_app), do: :storefront
  end

  # defmodule AdminWebEndpoint do
  #   def config(:otp_app), do: :admin
  # end

  describe ".render/2 horizontal.html" do
    test "displays links configured for the application endpoint" do
      conn = %Plug.Conn{private: %{phoenix_endpoint: StorefrontWeb.Endpoint}}
      html = render(Navigator, "horizontal.html", conn: conn)

      assert assert_html(html, "a", max: 5)
    end
  end

  # describe ".render/2 vertical.html" do
  # end
end
