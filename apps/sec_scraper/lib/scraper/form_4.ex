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

################################ PRIVATE METHODS ###############################

  defp save_filings(db_objects) do
    {filings, entities} = db_objects
    persist_filings_to_db(filings)
    persist_entities_to_db(entities)
    # process_filing_data(filings)
  end

  defp persist_filings_to_db (filing_mapset) do
    MapSet.to_list(filing_mapset)
    |> Enum.each(fn(filing) ->
      filing
      |> Filing.changeset
      |> Repo.insert_or_update
    end)
  end

  defp persist_entities_to_db (entity_mapset) do
    MapSet.to_list(entity_mapset)
    |> Enum.each(fn(entry) ->
      entry
      |> Entity.changeset
      |> Repo.insert_or_update
    end)
  end

  defp process_content(feed) do
    {%{timestamp: timestamp}, entries} = Map.pop(feed, :metadata)
    Enum.reduce(entries, {MapSet.new, MapSet.new}, fn(entry, db_objects) ->
      {filing, entities} = process_entry(entry, timestamp)
      {filing_set, entity_set} = db_objects
      {MapSet.put(filing_set, filing), MapSet.union(entity_set, entities)}
    end)
  end

  defp process_entry(entry, timestamp) do
    {accession, body} = entry
    require IEx
    IEx.pry
    issuer            = process_entity(body.issuer,    "issuer",    timestamp)
    reporting         = process_entity(body.reporting, "reporting", timestamp)
    filing            = struct(Filing,
                          %{accession: accession, form: body.form, link: body.link,
                            issuer_cik: issuer.cik, reporting_cik: reporting.cik,
                            inserted_at: timestamp, updated_at: timestamp})

    {filing, MapSet.new([issuer, reporting])}
  end

  defp process_entity(entity, role, timestamp) do
    struct(Entity, %{role: role, cik: String.to_integer(entity.cik), name: entity.subject,
      inserted_at: timestamp, updated_at: timestamp})
  end
end
