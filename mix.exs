defmodule SecFilings.Mixfile do
  use Mix.Project

  def project do
    [apps_path: "apps",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     aliases: aliases()
    ]
  end


  defp aliases do
    [
     restart: ["ecto.drop", "ecto.create", "ecto.migrate", "scrape"],
     reset: ["ecto.drop", "ecto.create", "ecto.migrate"],
     setup: ["ecto.create", "ecto.migrate"],
     c: "compile",
   ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options.
  #
  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps folder
  defp deps do
    []
  end
end
