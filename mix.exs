defmodule Ethereumex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ethereumex,
      version: "0.3.2",
      elixir: "~> 1.6",
      description: "Elixir JSON-RPC client for the Ethereum blockchain",
      package: [
        maintainers: ["Ayrat Badykov", "Izel Nakri", "Geoff Hayes"],
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/exthereum/ethereumex"}
      ],
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger], mod: {Ethereumex, []}]
  end

  defp deps do
    [
      {:httpoison, "~> 1.1.0"},
      {:poison, "~> 3.1.0"},
      # {:shackle, git: "https://github.com/lpgauth/shackle.git"},
      {:exvcr, "~> 0.10", only: [:dev, :test], runtime: false},
      {:credo, "~> 0.9.1", only: [:dev, :test], runtime: false},
      {:abi, "~> 0.1.8", only: [:dev, :test], runtime: false},
      {:blockchain, "~> 0.1.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false}
    ]
  end
end
