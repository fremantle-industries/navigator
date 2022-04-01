defmodule Navigator.Layouts.HorizontalTest do
  use ExUnit.Case
  use AssertHTML
  import Phoenix.View

  setup do
    start_supervised!(Support.Endpoint)
    :ok
  end

  test "renders links for the endpoint otp app of the connection" do
    conn = struct(Plug.Conn, request_path: "/", private: %{phoenix_endpoint: Support.Endpoint})

    rendered = render_to_string(Navigator, "horizontal.html", conn: conn)
    assert_html rendered, ~r{Orders}
    assert_html rendered, ~r{Admin}
    refute_html rendered, ~r{Users}
    refute_html rendered, ~r{Settings}
  end

  test "renders child links when the request_path matches the to path" do
    conn = struct(Plug.Conn, request_path: "/admin", private: %{phoenix_endpoint: Support.Endpoint})

    rendered = render_to_string(Navigator, "horizontal.html", conn: conn)
    assert_html rendered, ~r{Orders}
    assert_html rendered, ~r{Admin}
    assert_html rendered, ~r{Users}
    assert_html rendered, ~r{Settings}
  end

  test "renders parent & sibling links when the request_path equals the to path" do
    conn = struct(Plug.Conn, request_path: "/users", private: %{phoenix_endpoint: Support.Endpoint})

    rendered = render_to_string(Navigator, "horizontal.html", conn: conn)
    assert_html rendered, ~r{Orders}
    assert_html rendered, ~r{Admin}
    assert_html rendered, ~r{Users}
    assert_html rendered, ~r{Settings}
  end

  test "renders parent & sibling links when request_path starts with the to path" do
    conn = struct(Plug.Conn, request_path: "/users/new", private: %{phoenix_endpoint: Support.Endpoint})

    rendered = render_to_string(Navigator, "horizontal.html", conn: conn)
    assert_html rendered, ~r{Orders}
    assert_html rendered, ~r{Admin}
    assert_html rendered, ~r{Users}
    assert_html rendered, ~r{Settings}
  end
end
