require IEx

defmodule Scraper do
  @url "https://www.sec.gov/cgi-bin/browse-edgar?company=&CIK=&type=&owner=include&count=100&action=getcurrent&output=atom"
  #
  def start(_type, _args) do
    IO.puts "starting"
    Task.start(fn -> scrape end)
  end

  def scrape do
    {:ok, response} =  HTTPoison.get @url
    response_body = Quinn.parse(response.body)
    filings = %{metadata: %{}}
    Quinn.find(response_body, :entry)
    |> Enum.map(fn(raw_entry) -> entry_struct(raw_entry) end)
    |> Enum.reduce(filings, fn(entry_struct, filings) ->
      construct_entry(entry_struct, filings)
    end)
  end

  defp construct_entry(entry_struct, filings) do
    {filing_id, new_entry} = entry_struct
    existing_entry = filings[filing_id] || %{}
    merged_entries = Map.merge(existing_entry, new_entry)
    Map.put(filings, filing_id, merged_entries)
  end

  defp entry_struct(entry) do
    file_id = get_file_id(entry)
    {key, body} = get_title(entry)
    entry = %{
      key => body,
      form: get_form(entry),
      link: get_link(entry)
    }
    {file_id, entry}
  end

  defp get_title(entry) do
    [%{value: [title]}] = Quinn.find(entry, :title)
    parse_title(title)
  end

  defp get_link(entry) do
    [%{attr: [_, _, {_, link }]}] = Quinn.find(entry, :link)
    link
  end

  defp get_form(entry) do
    [%{attr: [_, _, {:term, term}]}] = Quinn.find(entry, :category)
    term
  end

  defp get_file_id(entry) do
    [%{value: [accession_string]}] = Quinn.find(entry, :id)
    get_accession_number(accession_string)
  end

  defp get_accession_number(accession_string) do
    regex = ~r/[a-z].+accession-number=(?<accession>[0-9-]+)/
    accession = Regex.named_captures(regex, accession_string)["accession"]
    String.to_atom(accession)
  end

  defp parse_title(title_string) do
    regex = ~r/(?<form>\S+) - (?<subject>[\w .,-\/]+) \((?<id>[0-9]+)\) \((?<role>\w+)\)/
    title = Regex.named_captures(regex, title_string)
    key = String.to_atom(String.downcase(title["role"]))
    body = %{
      form: title["form"],
      id: title["id"],
      subject: title["subject"]
    }
    {key, body}
  end
end

# ~r/(?<form>\S+) - (?<subject>[\w .-]+) \((?<id>[0-9]+)\) \((?<role>\w+\>)/
