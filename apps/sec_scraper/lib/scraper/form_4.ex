defmodule SecScraper.Form4 do
  alias SecScraper.AtomFeed, as: Feed
  alias SecScraper.Repo
  alias Insider.Filing
  alias Insider.Entity

  def process_feed do
    Feed.scrape(%{owner: :only})
    |> process_content()
    |> save_filings()
  end

  defp save_filings(db_objects) do
    {filing_list, entity_list} = db_objects
    filings  = Repo.insert_all(Filing, filing_list, returning: true)
    entities = Repo.insert_all(Entity, entity_list, returning: true)
    process_filing_data(filings)
    {filings, entities}
  end

  defp process_content(feed) do
    {%{timestamp: timestamp}, entries} = Map.pop(feed, :metadata)
    Enum.reduce(entries, {[], []}, fn(entry, db_objects) ->
      {filing, entities} = process_entry(entry, timestamp)
      {filing_list, entity_list} = db_objects
      {filing_list ++ [filing], entity_list ++ entities}
    end)
  end

  defp process_entry(entry, timestamp) do
    {accession, body} = entry
    issuer            = process_entity(body.issuer,    "issuer",    timestamp)
    reporting         = process_entity(body.reporting, "reporting", timestamp)
    filing            = %{accession: accession, form: body.form,
                          inserted_at: timestamp, updated_at: timestamp,
                          issuer_cik: issuer.cik, reporting_cik: reporting.cik}

    {filing, [issuer] ++ [reporting]}
  end

  def process_filing_data(filings) do
    #TODO
  end

  defp process_entity(entity, role, timestamp) do
    %{role: role, cik: String.to_integer(entity.cik), name: entity.subject,
      inserted_at: timestamp, updated_at: timestamp}
  end
end
