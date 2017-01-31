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

  def go do
    url = "https://www.sec.gov/Archives/edgar/data/1659166/000165916617000034/0001659166-17-000034-index.htm"
    HTTPoison.get!(url).body
    |> Floki.find("a")
    |> Enum.each(fn(html_node) ->
      {tag_name, attributes, children_nodes} = html_node
      IO.inspect "tag name: "
      IO.inspect tag_name
      IO.inspect "attributes: "
      IO.inspect attributes
      IO.inspect "children nodes: "
      IO.inspect children_nodes
    end)
  end
end
