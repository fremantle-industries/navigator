defmodule Navigator.ConfigTest do
  use Navigator.DataCase

  @links_env %{
    :app_1 => [
      %{label: "App 1 - Link 1", to: "/app_1_link_1"},
      %{label: "App 1 - Link 2", to: "/app_1_link_2"},
    ],
    {:app_2, "app-2-class"} => [
      %{label: "App 2 - Link 1", to: "/app_2_link_1"},
    ]
  }
  @all_env [links: @links_env]
  @valid_link_config %{label: "Valid Link", to: "/valid_link"}

  test ".parse/1 hydrates link applications & can assign an optional css class" do
    assert [:app_1, :app_2] = Navigator.Config.parse!(@all_env)

    assert {:ok, link_app_1} = Navigator.LinkAppStore.find(:app_1)
    assert link_app_1.class == nil
    assert {:ok, link_tree_1_root} = OrderedNaryTree.root(link_app_1.links)
    assert link_tree_1_root.value == :app_1
    assert {:ok, link_tree_1_children} = OrderedNaryTree.children(link_app_1.links)
    assert length(link_tree_1_children) == 2
    link_tree_1_child_1 = Enum.at(link_tree_1_children, 0)
    assert link_tree_1_child_1.value.label == "App 1 - Link 1"
    assert link_tree_1_child_1.value.to == "/app_1_link_1"
    assert length(link_tree_1_child_1.children) == 0
    link_tree_1_child_2 = Enum.at(link_tree_1_children, 1)
    assert link_tree_1_child_2.value.label == "App 1 - Link 2"
    assert link_tree_1_child_2.value.to == "/app_1_link_2"
    assert length(link_tree_1_child_2.children) == 0

    assert {:ok, link_app_2} = Navigator.LinkAppStore.find(:app_2)
    assert link_app_2.class == "app-2-class"
    assert {:ok, link_tree_2_root} = OrderedNaryTree.root(link_app_2.links)
    assert link_tree_2_root.value == :app_2
    assert {:ok, link_tree_2_children} = OrderedNaryTree.children(link_app_2.links)
    assert length(link_tree_2_children) == 1
    link_tree_2_child_1 = Enum.at(link_tree_2_children, 0)
    assert link_tree_2_child_1.value.label == "App 2 - Link 1"
    assert link_tree_2_child_1.value.to == "/app_2_link_1"
    assert length(link_tree_2_child_1.children) == 0
  end

  test ".parse/1 can assign child links recursively" do
    grand_children_config = [
      %{label: "App 1 - Child Link 1 - Grand Child Link 1", to: "/app_1_child_link_1_grand_child_link_1"},
    ]
    children_config = [
      %{label: "App 1 - Child Link 1", to: "/app_1_child_link_1", children: grand_children_config},
      %{label: "App 1 - Child Link 2", to: "/app_1_child_link_2"},
    ]
    links_env = %{
      app_1: [
        %{label: "App 1 - Link 1", to: "/app_1_link_1", children: children_config},
      ]
    }

    assert [:app_1] = Navigator.Config.parse!(links: links_env)

    assert {:ok, app_1} = Navigator.LinkAppStore.find(:app_1)
    assert {:ok, root_node} = OrderedNaryTree.root(app_1.links)
    assert root_node.value == :app_1

    assert {:ok, root_children} = OrderedNaryTree.children(app_1.links)
    assert length(root_children) == 1
    depth_1_child_node_1 = Enum.at(root_children, 0)
    assert depth_1_child_node_1.value.label == "App 1 - Link 1"

    assert {:ok, depth_1_child_node_1_children} = OrderedNaryTree.children(app_1.links, depth_1_child_node_1.id)
    assert length(depth_1_child_node_1_children) == 2
    depth_2_child_node_1 = Enum.at(depth_1_child_node_1_children, 0)
    assert depth_2_child_node_1.value.label == "App 1 - Child Link 1"
    assert depth_2_child_node_1.value.to == "/app_1_child_link_1"
    depth_2_child_node_2 = Enum.at(depth_1_child_node_1_children, 1)
    assert depth_2_child_node_2.value.label == "App 1 - Child Link 2"
    assert depth_2_child_node_2.value.to == "/app_1_child_link_2"

    assert {:ok, depth_2_child_node_1_children} = OrderedNaryTree.children(app_1.links, depth_2_child_node_1.id)
    assert length(depth_2_child_node_1_children) == 1
    depth_3_child_node_1 = Enum.at(depth_2_child_node_1_children, 0)
    assert depth_3_child_node_1.value.label == "App 1 - Child Link 1 - Grand Child Link 1"
    assert depth_3_child_node_1.value.to == "/app_1_child_link_1_grand_child_link_1"
    assert {:ok, depth_2_child_node_2_children} = OrderedNaryTree.children(app_1.links, depth_2_child_node_2.id)
    assert length(depth_2_child_node_2_children) == 0
  end

  test ".parse/1 can assign class" do
    links_env = %{
      app_1: [
        Map.put(@valid_link_config, :class, "new-class")
      ]
    }

    assert [:app_1] = Navigator.Config.parse!(links: links_env)
    assert {:ok, app_1} = Navigator.LinkAppStore.find(:app_1)

    assert {:ok, root_children} = OrderedNaryTree.children(app_1.links)
    assert length(root_children) == 1
    child_node_1 = Enum.at(root_children, 0)
    assert child_node_1.value.class == "new-class"
  end

  test ".parse/1 can assign icon" do
    links_env = %{
      app_1: [
        Map.put(@valid_link_config, :icon, "new-icon")
      ]
    }

    assert [:app_1] = Navigator.Config.parse!(links: links_env)
    assert {:ok, app_1} = Navigator.LinkAppStore.find(:app_1)

    assert {:ok, root_children} = OrderedNaryTree.children(app_1.links)
    assert length(root_children) == 1
    child_node_1 = Enum.at(root_children, 0)
    assert child_node_1.value.icon == "new-icon"
  end

  test ".parse/1 can assign method" do
    links_env = %{
      app_1: [
        Map.put(@valid_link_config, :method, :get)
      ]
    }

    assert [:app_1] = Navigator.Config.parse!(links: links_env)
    assert {:ok, app_1} = Navigator.LinkAppStore.find(:app_1)

    assert {:ok, root_children} = OrderedNaryTree.children(app_1.links)
    assert length(root_children) == 1
    child_node_1 = Enum.at(root_children, 0)
    assert child_node_1.value.method == :get
  end

  test ".parse/1 can assign condition" do
    links_env = %{
      app_1: [
        Map.put(@valid_link_config, :condition, {MyModule, :my_func, []})
      ]
    }

    assert [:app_1] = Navigator.Config.parse!(links: links_env)
    assert {:ok, app_1} = Navigator.LinkAppStore.find(:app_1)

    assert {:ok, root_children} = OrderedNaryTree.children(app_1.links)
    assert length(root_children) == 1
    child_node_1 = Enum.at(root_children, 0)
    assert child_node_1.value.condition == {MyModule, :my_func, []}
  end
end
