defmodule SecScraper.Form4 do
  alias SecScraper.AtomFeed, as: Feed
  alias SecScraper.Repo
  alias SecScraper.Filing
  alias SecScraper.Insider
  alias SecScraper.Company

  def process_feed do
    Feed.scrape(%{owner: :only})
    |> process_content()
    |> save_filings()
  end

################################ PRIVATE METHODS ###############################

  def process_content(feed) do
    {%{timestamp: timestamp}, entries} = Map.pop(feed, :metadata)
    Enum.reduce(entries, {MapSet.new, MapSet.new, MapSet.new}, fn(entry, db_objects) ->
      {filing, company, insider} = process_entry(entry, timestamp)
      {filing_set, company_set, insider_set} = db_objects
      {MapSet.put(filing_set,  filing),
       MapSet.put(company_set, company),
       MapSet.put(insider_set, insider)}
    end)
  end

  def process_entry(entry, timestamp) do
    {accession, body} = entry
    company = process(company: body.issuer, timestamp: timestamp)
    insider = process(insider: body.reporting, timestamp: timestamp)
    filing  = process(filing: %{
      accession: accession, body: body, timestamp: timestamp,
      company_cik: company.cik, insider_cik: insider.cik
    })
    {filing, company, insider}
  end

  def process(company: company, timestamp: timestamp) do
    struct(Company, %{
      cik: String.to_integer(company.cik), name: company.subject,
      inserted_at: timestamp, updated_at: timestamp
    })
  end

  def process(insider: insider, timestamp: timestamp) do
    struct(Insider, %{
      cik: String.to_integer(insider.cik), name: insider.subject,
      inserted_at: timestamp, updated_at: timestamp
    })
  end

  def process(filing: opts) do
    struct(Filing, %{
      accession: opts[:accession], form: opts[:body].form, link: opts[:body].link,
      company_cik: opts[:company_cik], insider_cik: opts[:insider_cik],
      inserted_at: opts[:timestamp], updated_at: opts[:timestamp]
    })
  end

  def save_filings(db_objects) do
    require IEx
    IEx.pry
    {filings, companies, insiders} = db_objects
    persist(filings: filings)
    persist(insiders: insiders)
    persist(companies: companies)
  end

  def persist(filings: filings) do
    MapSet.to_list(filings)
    |> Enum.each(fn(filing) ->
      filing
      |> Filing.changeset
      |> Repo.insert_or_update
    end)
  end

  def persist(companies: companies) do
    MapSet.to_list(companies)
    |> Enum.each(fn(company) ->
      company
      |> Company.changeset
      |> Repo.insert_or_update
    end)
  end

  def persist(insiders: insiders) do
    MapSet.to_list(insiders)
    |> Enum.each(fn(insider) ->
      insider
      |> Insider.changeset
      |> Repo.insert_or_update
    end)
  end
end
