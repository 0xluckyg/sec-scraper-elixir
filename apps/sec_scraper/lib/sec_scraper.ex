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

  def go(url \\ "https://www.sec.gov/Archives/edgar/data/1682600/000006501117000049/0000065011-17-000049-index.htm") do
    HTTPoison.get!(url).body
    |> Floki.find("table.tableFile")
    |> Floki.find("a")
    |> get_links()
    |> Enum.map(fn({key, node}) ->
      {_tag, [{_href, link}], [_children]} = node
      {key, link}
    end)
    # |> save_all()
  end

  def save_all(list) do
    save(html: list[:html])
    save(xml: list[:xml])
    save(txt: list[:txt])
  end

  def get_links([html, xml, next | tail]) do
    [html: html, xml: xml, txt: get_txt(tail, next)]
  end

  def get_txt([], last),  do: last
  def get_txt([next | tail], _cur) do
    get_txt(tail, next)
  end

  def save(html: html), do: html
  def save(xml: xml), do: xml
  def save(txt: txt), do: txt

  # def process_node(html_node) do
  #   {tag_name, attributes, children_nodes} = html_node
  # end

end
