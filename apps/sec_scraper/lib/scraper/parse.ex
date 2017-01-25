defmodule SecScraper.SecAtomFeed do

  @base_url "https://www.sec.gov/cgi-bin/browse-edgar"
  @default_opts %{ owner: :include, count: 10, action: :getcurrent, output: :atom }

  def scrape(opts \\ %{}) do
    url = @base_url <> build_query_string(opts)
    {:ok, response} =  HTTPoison.get url
    response_body = Quinn.parse(response.body)
    filings = %{metadata: %{}}
    Quinn.find(response_body, :entry)
    |> Enum.map(fn(raw_entry) -> entry_struct(raw_entry) end)
    |> Enum.reduce(filings, fn(entry_struct, filings) ->
      construct_entry(entry_struct, filings)
    end)
  end

################################ PRIVATE METHODS ###############################

  # ?action=getcurrent&count=10&output=atom&owner=include by default
  def build_query_string(opts \\ %{}) do
    opts = Map.merge(@default_opts, opts)
    Enum.map(opts, fn(key_pair) ->
      {key, value} = key_pair
      "#{key}=#{value}"
    end)
    |> Enum.join("&")
    |> (fn(query_string) -> "?" <> query_string end).()
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

  defp construct_entry(entry_struct, filings) do
    {filing_id, new_entry} = entry_struct
    existing_entry = filings[filing_id] || %{}
    merged_entries = Map.merge(existing_entry, new_entry)
    Map.put(filings, filing_id, merged_entries)
  end

################################### HELPERS ####################################


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
    regex = ~r/(?<form>.+) - (?<subject>[\w .,&-\/]+) \((?<id>[0-9]+)\) \((?<role>.+)\)/
    title = Regex.named_captures(regex, title_string)
    role_string = String.downcase(String.replace(title["role"], " ", "_"))
    key = String.to_atom(role_string)
    body = %{
      form: title["form"],
      id: title["id"],
      subject: title["subject"]
    }
    {key, body}
  end
end
