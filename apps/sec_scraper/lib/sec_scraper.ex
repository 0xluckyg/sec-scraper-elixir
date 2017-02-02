defmodule SecScraper do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(SecScraper.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: SecScraper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
