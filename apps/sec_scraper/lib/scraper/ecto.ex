defmodule SecScraper.Repo do
  use Ecto.Repo,
  otp_app: :sec_scraper
end

defmodule Insider.Entity do
  alias Insider.Filing
  use Ecto.Schema

  @primary_key {:cik, :integer, autogenerate: false}

  schema "entity" do
    field :role
    field :name
    has_many :filings, Filing
    timestamps type: :utc_datetime
  end
end

defmodule Insider.Filing do
  alias Insider.Entity
  use Ecto.Schema

  schema "filing" do
    field :accession
    field :form
    timestamps type: :utc_datetime
    belongs_to :issuer,    Entity, foreign_key: :issuer_cik,    references: :cik
    belongs_to :reporting, Entity, foreign_key: :reporting_cik, references: :cik
  end
end
