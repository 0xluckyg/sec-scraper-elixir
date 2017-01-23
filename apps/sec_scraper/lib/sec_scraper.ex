defmodule SecScraper do
  use Application
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Aggregator.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: Aggregator.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
