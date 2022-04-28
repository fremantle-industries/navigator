defmodule Navigator.Layouts.HorizontalTest do
  use ExUnit.Case
  use AssertHTML
  import Phoenix.View

  setup do
    start_supervised!(Support.Endpoint)
    :ok
  end

  test "renders links for the endpoint otp app of the connection" do
    conn = struct(Plug.Conn, request_path: "/orders", private: %{phoenix_endpoint: Support.Endpoint})

    rendered = render_to_string(Navigator, "horizontal.html", conn: conn)
    assert_html rendered, ~r{Orders}
    assert_html rendered, ~r{Admin}
    assert_html rendered, "a.active", count: 1
    refute_html rendered, ~r{Users}
    refute_html rendered, ~r{Settings}
  end

  test "renders empty when there are no matches" do
    conn = struct(Plug.Conn, request_path: "/", private: %{phoenix_endpoint: Support.Endpoint})

    rendered = render_to_string(Navigator, "horizontal.html", conn: conn)
    refute_html rendered, ~r{Orders}
    refute_html rendered, ~r{Admin}
    refute_html rendered, ~r{Users}
    refute_html rendered, ~r{Settings}
    refute_html rendered, "a.active"
  end

  test "renders links without children when the request_path matches the parent to path" do
    conn = struct(Plug.Conn, request_path: "/admin", private: %{phoenix_endpoint: Support.Endpoint})

    rendered = render_to_string(Navigator, "horizontal.html", conn: conn)
    assert_html rendered, ~r{Orders}
    assert_html rendered, ~r{Admin}
    assert_html rendered, "a.active", count: 1
    refute_html rendered, ~r{Users}
    refute_html rendered, ~r{Settings}
  end

  test "renders parent & sibling links when the request_path equals the to path" do
    conn = struct(Plug.Conn, request_path: "/users", private: %{phoenix_endpoint: Support.Endpoint})

    rendered = render_to_string(Navigator, "horizontal.html", conn: conn)
    assert_html rendered, ~r{Orders}
    assert_html rendered, ~r{Admin}
    assert_html rendered, ~r{Users}
    assert_html rendered, ~r{Settings}
    assert_html rendered, "a.active", count: 2
  end

  test "renders parent & sibling links when request_path starts with the to path" do
    conn = struct(Plug.Conn, request_path: "/users/new", private: %{phoenix_endpoint: Support.Endpoint})

    rendered = render_to_string(Navigator, "horizontal.html", conn: conn)
    assert_html rendered, ~r{Orders}
    assert_html rendered, ~r{Admin}
    assert_html rendered, ~r{Users}
    assert_html rendered, ~r{Settings}
    assert_html rendered, "a.active", count: 2
  end
end
