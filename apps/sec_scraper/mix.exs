defmodule SecScraper.Mixfile do
  use Mix.Project

  def project do
    [app: :sec_scraper,
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [extra_applications: [:logger, :httpoison, :quinn, :postgrex, :ecto],
     mod: {SecScraper, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      { :httpoison, "~> 0.11.0" },
      { :quinn, "~> 1.0.0" },
      { :postgrex, "~> 0.13.0" },
      { :ecto, "~> 2.1.3" },
      { :floki, "~> 0.13.1" },
    ]
  end
end
