defmodule Navigator.LinkConfigTest do
  use ExUnit.Case

  @valid_config %{
    app_1: [
      %{label: "App 1 - Link 1", to: "/app_1_link_1"},
      %{label: "App 1 - Link 2", to: "/app_1_link_2"},
    ],
    app_2: [
      %{label: "App 2 - Link 1", to: "/app_2_link_1"},
    ]
  }
  @valid_link_config %{label: "Valid Link", to: "/valid_link"}

  test ".parse/1 returns a map of links for each app" do
    assert {:ok, app_links} = Navigator.LinkConfig.parse(@valid_config)
    assert map_size(app_links) == 2

    app_1_links = app_links[:app_1]
    assert length(app_1_links) == 2
    app_1_link_1 = Enum.at(app_1_links, 0)
    assert app_1_link_1.label == "App 1 - Link 1"
    assert app_1_link_1.to == "/app_1_link_1"
    assert app_1_link_1.children == []
    app_1_link_2 = Enum.at(app_1_links, 1)
    assert app_1_link_2.label == "App 1 - Link 2"
    assert app_1_link_2.to == "/app_1_link_2"
    assert app_1_link_2.children == []

    app_2_links = app_links[:app_2]
    assert length(app_2_links) == 1
    app_2_link_1 = Enum.at(app_2_links, 0)
    assert app_2_link_1.label == "App 2 - Link 1"
    assert app_2_link_1.to == "/app_2_link_1"
    assert app_2_link_1.children == []
  end

  test ".parse/1 can assign child links recursively" do
    grand_children_config = [
      %{label: "App 1 - Child Link 1 - Grand Child Link 1", to: "/app_1_child_link_1_grand_child_link_1"},
    ]
    children_config = [
      %{label: "App 1 - Child Link 1", to: "/app_1_child_link_1", children: grand_children_config},
      %{label: "App 1 - Child Link 2", to: "/app_1_child_link_2"},
    ]
    config = %{
      app_1: [
        %{label: "App 1 - Link 1", to: "/app_1_link_1", children: children_config},
      ]
    }

    assert {:ok, app_links} = Navigator.LinkConfig.parse(config)

    app_1_links = app_links[:app_1]
    assert length(app_1_links) == 1

    link = Enum.at(app_1_links, 0)
    assert length(link.children) == 2

    child_link_1 = Enum.at(link.children, 0)
    assert child_link_1.label == "App 1 - Child Link 1"
    assert child_link_1.to == "/app_1_child_link_1"
    assert length(child_link_1.children) == 1
    assert Enum.at(child_link_1.children, 0).label == "App 1 - Child Link 1 - Grand Child Link 1"
    assert Enum.at(child_link_1.children, 0).to == "/app_1_child_link_1_grand_child_link_1"

    child_link_2 = Enum.at(link.children, 1)
    assert child_link_2.label == "App 1 - Child Link 2"
    assert child_link_2.to == "/app_1_child_link_2"
    assert length(child_link_2.children) == 0
  end

  test ".parse/1 can assign class" do
    config = %{
      app_1: [
        Map.put(@valid_link_config, :class, "new-class")
      ]
    }

    assert {:ok, app_links} = Navigator.LinkConfig.parse(config)

    app_1_links = app_links[:app_1]
    assert length(app_1_links) == 1
    assert Enum.at(app_1_links, 0).class == "new-class"
  end

  test ".parse/1 can assign icon" do
    config = %{
      app_1: [
        Map.put(@valid_link_config, :icon, "new-icon")
      ]
    }

    assert {:ok, app_links} = Navigator.LinkConfig.parse(config)

    app_1_links = app_links[:app_1]
    assert length(app_1_links) == 1
    assert Enum.at(app_1_links, 0).icon == "new-icon"
  end

  test ".parse/1 can assign method" do
    config = %{
      app_1: [
        Map.put(@valid_link_config, :method, :get)
      ]
    }

    assert {:ok, app_links} = Navigator.LinkConfig.parse(config)

    app_1_links = app_links[:app_1]
    assert length(app_1_links) == 1
    assert Enum.at(app_1_links, 0).method == :get
  end

  test ".parse/1 can assign condition" do
    config = %{
      app_1: [
        Map.put(@valid_link_config, :condition, {MyModule, :my_func, []})
      ]
    }

    assert {:ok, app_links} = Navigator.LinkConfig.parse(config)

    app_1_links = app_links[:app_1]
    assert length(app_1_links) == 1
    assert Enum.at(app_1_links, 0).condition == {MyModule, :my_func, []}
  end
end
