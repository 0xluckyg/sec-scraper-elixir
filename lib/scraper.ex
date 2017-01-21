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
    IO.puts("\n")
    struct = %{
      title:   get_title(entry),
      link:    get_link(entry),
      form:    get_form(entry),
      file_id: get_file_id(entry)
    }
    print_struct(struct)
  end

  defp print_struct(struct) do
    IO.inspect(struct)
    IO.puts("\n")
    IO.puts("------------------------------------------------------------------")
    struct
  end

  defp get_title(entry) do
    [%{value: [title]}] = Quinn.find(entry, :title)
    title
  end

  defp get_link(entry) do
    [%{attr: [_, _, {_, link }]}] = Quinn.find(entry, :link)
    link
  end

  defp get_form(entry) do
    [%{attr: [_, _, {:term, term}]}] = Quinn.find(entry, :category)
    term
  end

  def get_file_id(entry) do
    [%{value: [accession_string]}] = Quinn.find(entry, :id)
    get_accession_number(accession_string)
  end

  def get_accession_number(accession_string) do
    regex = ~r/[a-z].+accession-number=(?<accession>[0-9-]+)/
    Regex.named_captures(regex, accession_string)["accession"]
  end
end
