require IEx

defmodule Scraper do
  @url "https://www.sec.gov/cgi-bin/browse-edgar?company=&CIK=&type=&owner=include&count=1&action=getcurrent&output=atom"

  def start(_type, _args) do
    IO.puts "starting"
    Task.start(fn -> scrape end)
  end

  def scrape do
    {:ok, response} =  HTTPoison.get @url
    struct = Quinn.parse(response.body)
    Quinn.find(struct, :entry)
      |> Enum.map(fn(entry) -> map_entry(entry) end)
  end

  defp map_entry(entry) do
    IO.inspect(entry)
    %{
      title: get_title(entry),
      link:  get_link(entry)
    }
  end

  defp get_title(entry) do
    [%{value: [title]}] = Quinn.find(entry, :title)
    title
  end

  defp get_link(entry) do
    [%{attr: [_, _, {_, link }]}] = Quinn.find(entry, :link)
    link
  end

end
