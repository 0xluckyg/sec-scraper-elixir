defmodule SecScraper.Repo do
  use Ecto.Repo,
  otp_app: :sec_scraper
end

defmodule Insider.Entity do
  use Ecto.Schema
  @primary_key {:cik, :integer, autogenerate: false}

  schema "entity" do
    field :type
    field :name
    has_many :filings, SecScraper.Filing
  end
end

defmodule Insider.Filing do
  alias Insider.Entity
  use Ecto.Schema

  schema "filing" do
    field :accession
    field :form
    timestamps type: :utc_datetime
    belongs_to :issuer, Entity, references: :cik
    belongs_to :reporting, Entity, references: :cik
  end
end
