defmodule SecScraper.Form4 do
  alias SecScraper.AtomFeed, as: Feed
  alias SecScraper.Repo
  alias Insider.Filing
  alias Insider.Entity

  def process_feed do
    Feed.scrape
    |> process_metadata()
    |> Enum.reduce( {[], []}, fn(entry, db_objects) ->
      {filing_list, entity_list} = db_objects
      {filing, entities} = process_entry(entry)
      {filing_list ++ [filing], entity_list ++ entities}
    end)
    |> persist_to_db()
  end

  def process_entry(entry) do
    {accession, body} = entry
    issuer = struct(Entity, process_entity(body.issuer, :issuer))
    reporting = struct(Entity, process_entity(body.reporting, :reporting))
    filing = %Filing{accession: accession, form: body.form,
                     issuer_cik: issuer.cik, reporting_cik: reporting.cik}
    {filing, [issuer] ++ [reporting]}
  end

  defp persist_to_db(db_objects) do
    {filing_list, entity_list} = db_objects
    Repo.insert_all(Filing, filing_list, returning: true)
    Repo.insert_all(Entity, entity_list, returning: true, on_conflict: :nothing)
  end

  defp process_metadata(feed) do
    {_metadata, entries} = Map.pop(feed, :metadata)
    entries
  end

  defp process_entity(entity, type) do
    %{type: type, cik: entity.cik, name: entity.subject}
  end
end
