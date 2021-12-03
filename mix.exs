defmodule Navigator.MixProject do
  use Mix.Project

  def project do
    [
      app: :navigator,
      version: "0.0.5",
      elixir: "~> 1.10",
      package: package(),
      start_permanent: Mix.env() == :prod,
      description: description(),
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_view, "~> 0.17"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:assert_html, ">= 0.0.1", only: :test},
      {:ex_unit_notifier, "~> 1.0", only: :test},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end

  defp description do
    "Global navigation between multiple Phoenix endpoints"
  end

  defp package do
    %{
      licenses: ["MIT"],
      maintainers: ["Alex Kwiatkowski"],
      links: %{"GitHub" => "https://github.com/fremantle-industries/navigator"}
    }
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
